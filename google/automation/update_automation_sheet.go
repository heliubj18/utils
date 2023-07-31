package main

import (
	"context"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"
	"sort"
	"strings"

	"golang.org/x/oauth2"
	"golang.org/x/oauth2/google"
	"google.golang.org/api/option"
	sheetsv4 "google.golang.org/api/sheets/v4"
)

const (
	HOUserStorySheetID = "1uy_J6lUcp_BnhCWOBqo9C5U6gyG6HcFhuftIKgiaLQY"
)

type AutoSheet struct {
	ID       string
	Title    string
	Platform string
	Type     string
	Version  string
	Owner    string
	Status   string
	Comment  string
	BugLink  string
}

type AutoSheetList []AutoSheet

func (as AutoSheetList) Len() int {
	return len(as)
}

func (as AutoSheetList) Less(i, j int) bool {
	return as[i].ID < as[j].ID
}

func (as AutoSheetList) Swap(i, j int) {
	as[i], as[j] = as[j], as[i]
}

// Retrieve a token, saves the token, then returns the generated client.
func getClient(config *oauth2.Config) *http.Client {
	// The file token.json stores the user's access and refresh tokens, and is
	// created automatically when the authorization flow completes for the first
	// time.
	tokFile := "token.json"
	tok, err := tokenFromFile(tokFile)
	if err != nil {
		tok = getTokenFromWeb(config)
		saveToken(tokFile, tok)
	}
	return config.Client(context.Background(), tok)
}

// Request a token from the web, then returns the retrieved token.
func getTokenFromWeb(config *oauth2.Config) *oauth2.Token {
	authURL := config.AuthCodeURL("state-token", oauth2.AccessTypeOffline)
	fmt.Printf("Go to the following link in your browser then type the "+
		"authorization code: \n%v\n", authURL)

	var authCode string
	if _, err := fmt.Scan(&authCode); err != nil {
		log.Fatalf("Unable to read authorization code: %v", err)
	}

	tok, err := config.Exchange(context.TODO(), authCode)
	if err != nil {
		log.Fatalf("Unable to retrieve token from web: %v", err)
	}
	return tok
}

// Retrieves a token from a local file.
func tokenFromFile(file string) (*oauth2.Token, error) {
	f, err := os.Open(file)
	if err != nil {
		return nil, err
	}
	defer f.Close()
	tok := &oauth2.Token{}
	err = json.NewDecoder(f).Decode(tok)
	return tok, err
}

// Saves a token to a file path.
func saveToken(path string, token *oauth2.Token) {
	fmt.Printf("Saving credential file to: %s\n", path)
	f, err := os.OpenFile(path, os.O_RDWR|os.O_CREATE|os.O_TRUNC, 0600)
	if err != nil {
		log.Fatalf("Unable to cache oauth token: %v", err)
	}
	defer f.Close()
	json.NewEncoder(f).Encode(token)
}

func appendDataToSheet(srv *sheetsv4.Service, spreadsheetId, appendRange string, data [][]interface{}) error {
	valueRange := &sheetsv4.ValueRange{
		Values: data,
	}
	_, err := srv.Spreadsheets.Values.Append(spreadsheetId, appendRange, valueRange).ValueInputOption("USER_ENTERED").Do()
	if err != nil {
		return fmt.Errorf("failed to append data to sheet: %v", err)
	}

	fmt.Println("Data has been appended to sheet")
	return nil
}

func getPlatformByTitle(title string) string {
	if title == "" {
		return ""
	}

	if strings.Contains(strings.ToLower(title), "azure") {
		return "Azure"
	}

	return "AWS"
}

func getAutoTypeByTitle(title string) string {
	if title == "" {
		return ""
	}

	t := strings.ToLower(title)
	if strings.Contains(t, "install") ||
		strings.Contains(t, "create") ||
		strings.Contains(t, "delete") ||
		strings.Contains(t, "destroy") ||
		strings.Contains(t, "remove") ||
		strings.Contains(t, "stuck") ||
		strings.Contains(t, "clear") ||
		strings.Contains(t, "private") ||
		strings.Contains(t, "endpoint") ||
		strings.Contains(t, "proxy") {
		return "Install"
	}

	return "Function"

}

func main() {
	creds := os.Getenv("GOOGLE_API_CREDENTIALS")
	_, err := os.Stat(creds)
	if err != nil {
		log.Fatalf("check credentials file error: %v", err)
	}

	ctx := context.Background()
	b, err := os.ReadFile(creds)
	if err != nil {
		log.Fatalf("Unable to read client secret file: %v", err)
	}

	// If modifying these scopes, delete your previously saved token.json.
	config, err := google.ConfigFromJSON(b, "https://www.googleapis.com/auth/spreadsheets")
	if err != nil {
		log.Fatalf("Unable to parse client secret file to config: %v", err)
	}
	client := getClient(config)

	srv, err := sheetsv4.NewService(ctx, option.WithHTTPClient(client))
	if err != nil {
		log.Fatalf("Unable to retrieve Sheets client: %v", err)
	}

	spreadsheetId := HOUserStorySheetID
	autoSheetName := "Automation"
	autoReadRange := autoSheetName + "!A2:G"
	resp, err := srv.Spreadsheets.Values.Get(spreadsheetId, autoReadRange).Do()
	if err != nil {
		log.Fatalf("Unable to retrieve data from sheet: %v", err)
	}

	//find existing auto case IDs
	autoCases := make(map[string]struct{}, 100)
	if len(resp.Values) == 0 {
		fmt.Println("No data found.")
	} else {
		fmt.Printf("\n>>>>>>>> auto len %d\n", len(resp.Values))
		for i := 0; i < len(resp.Values); i++ {
			row := resp.Values[i]
			if len(row) > 0 {
				autoCases[strings.Trim(row[0].(string), " ")] = struct{}{}
			}
		}
	}

	fmt.Println("auto cases ", autoCases)

	//find all existing cases
	allCases := "User stories"
	allCaseReadRange := allCases + "!B4:H"
	resp, err = srv.Spreadsheets.Values.Get(spreadsheetId, allCaseReadRange).Do()
	if err != nil {
		log.Fatalf("Unable to retrieve data from sheet %s: %v", allCases, err)
	}

	//find all case IDs
	allCasesMap := make(map[string]AutoSheet, 50)
	separators := func(c rune) bool {
		return c == ',' || c == ' '
	}
	fmt.Printf("\n>>>>>>>> all case len %d\n", len(resp.Values))
	if len(resp.Values) == 0 {
		fmt.Println("No data found.")
	} else {
		for i := 0; i < len(resp.Values); i++ {
			row := resp.Values[i]
			if len(row) > 6 {
				caseID := strings.Trim(row[6].(string), " ")
				if strings.HasPrefix(caseID, "OCP-") {
					record := AutoSheet{
						Title:    row[1].(string),
						Status:   "ToDo",
						Platform: getPlatformByTitle(row[1].(string)),
						Type:     getAutoTypeByTitle(row[1].(string)),
					}

					if v := strings.Split(row[2].(string), " "); len(v) > 0 {
						record.Version = strings.Trim(strings.TrimSpace(v[len(v)-1]), ",")
					}

					jiraID := row[0].(string)
					if jiraID != "" && strings.HasPrefix(jiraID, "OCPBUGS-") {
						record.Comment = jiraID
					}

					ids := strings.FieldsFunc(caseID, separators)
					for _, id := range ids {
						record.ID = id
						allCasesMap[id] = record
					}
				}
			}
		}
	}

	fmt.Println("all cases ", allCasesMap)

	//diff IDs
	var diff AutoSheetList
	for id, v := range allCasesMap {
		if _, ok := autoCases[id]; !ok {
			diff = append(diff, v)
		}
	}

	sort.Sort(diff)

	fmt.Println("sorted diff: ", diff)

	//change to column
	data := make([][]interface{}, len(diff))
	for i := 0; i < len(diff); i++ {
		data[i] = []interface{}{
			diff[i].ID,
			diff[i].Title,
			diff[i].Platform,
			diff[i].Type,
			diff[i].Version,
			//owner
			"",
			diff[i].Status,
			diff[i].Comment,
		}
	}

	//check target sheet exist or not
	targetSheetName := "test"
	targetReadRange := targetSheetName + "!A2:D1"
	_, err = srv.Spreadsheets.Values.Get(spreadsheetId, targetReadRange).Do()
	if err != nil {
		log.Fatalf("Failed to read data from sheet: %v", err)
	}

	appendDataToSheet(srv, HOUserStorySheetID, targetReadRange, data)
}
