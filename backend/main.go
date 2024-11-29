package main

import (
	"fmt"
	"os"

	"github.com/spf13/cobra"

	// "github.com/alfiyafatima09/NextGoGen/backend/processor"
	"github.com/alfiyafatima09/NextGoGen/backend/processor/sql"
	// "gofr.dev/pkg/gofr"
)

func main() {

	// app := gofr.New()
	// app.POST("/toJson", processor.HandleConversion)

	var rootCmd = &cobra.Command{Use: "app"}
	var sqlCmd = &cobra.Command{
		Use:   "sql",
		Short: "Process SQL database",
		Run: func(cmd *cobra.Command, args []string) {
			fmt.Println(args)
			sql.ConvertSQLToJSON(cmd, args)
		},
	}

	rootCmd.AddCommand(sqlCmd)
	if err := rootCmd.Execute(); err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	// app.Run()

}
