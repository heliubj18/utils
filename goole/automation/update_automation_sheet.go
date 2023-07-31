package main

import (
	"context"
	"fmt"
	"log"

	"google.golang.org/api/option"
)

func main() {
	ctx := context.Background()

	creds, err := option.WithCredentialsFile("path/to/credentials.json")
	if err != nil {
		log.Fatal(err)
	}

	srv, err := sheets.NewService(ctx, creds)
	if err != nil {
		log.Fatal(err)
	}

	rangeName := "Sheet1!A1:C"

	resp, err := srv.Spreadsheets.Values.Get(spreadsheetID, rangeName).Do()
	if err != nil {
		log.Fatal(err)
	}

	if len(resp.Values) == 0 {
		fmt.Println("No data found.")
	} else {
		for _, row := range resp.Values {
			fmt.Printf("%s, %s, %s\n", row[0], row[1], row[2])
		}
	}
}

