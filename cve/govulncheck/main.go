// Copyright 2022 The Go Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
package main

import (
	"context"
	"fmt"
	"golang.org/x/telemetry"
	"golang.org/x/vuln/scan"
	"os"
)

func main() {
	telemetry.Start(telemetry.Config{ReportCrashes: true})
	ctx := context.Background()
	cmd := scan.Command(ctx, os.Args[1:]...)
	err := cmd.Start()
	if err == nil {
		err = cmd.Wait()
	}
	switch err := err.(type) {
	case nil:
	case interface{ ExitCode() int }:
		os.Exit(err.ExitCode())
	default:
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}
}
