package main

import (
	"fmt"
	"os"
	"strings"

	"github.com/alfiyafatima09/NextGoGen/backend/processor/csv"
	"github.com/alfiyafatima09/NextGoGen/backend/processor/xml"
	"github.com/spf13/cobra"

	"github.com/alfiyafatima09/NextGoGen/backend/processor/sql"
	"gofr.dev/pkg/gofr"
)

type ConversionRequest struct {
	FilePath string `json:"filePath"`
}

type ConversionResponse struct {
	OutputPath string `json:"outputPath"`
	Message    string `json:"message"`
}

func handleConversion(ctx *gofr.Context) (interface{}, error) {

	var req ConversionRequest
	if err := ctx.Bind(&req); err != nil {
		return nil, fmt.Errorf("invalid request format: %v", err)
	}
	path := req.FilePath

	fmt.Println(path)
	fmt.Println(strings.HasSuffix(path, ".xml"))
	if strings.HasSuffix(path, ".xml") || true {
		x, _ := xml.NewXMLToJSONConverter().ConvertFile(req.FilePath)
		fmt.Println(x)
	}
	if strings.HasSuffix(path, ".csv") {
		return csv.ConvertCSVToJSON(req.FilePath)
	}
	// if strings.HasSuffix(path, ".sql") {
	// 	return sql.HandleEmployees(ctx)
	// 	// return sql.ConvertSQLToJSON(req.FilePath)

	// }

	// x, _ := csv.ConvertCSVToJSON(req.FilePath)
	// return string(x), nil
	// return csv.ConvertCSVToJSON(req.FilePath)
	// Create converter instance
	// xmlConverter := cs.NewXMLToJSONConverter()

	// Validate input file
	// if err := xmlConverter.ValidateXMLFile(req.FilePath); err != nil {
	// 	return nil, err
	// }

	// outputPath, err := xmlConverter.ConvertFile(req.FilePath)
	// if err != nil {
	// return nil, err
	// }

	return ConversionResponse{
		OutputPath: "outputPath",
		Message:    "File converted successfully",
	}, nil
}

func main() {

	app := gofr.New()
	app.POST("/toJson", handleConversion)
	// app.GET("/employees", sql.HandleEmployees)

	var rootCmd = &cobra.Command{Use: "app"}
	var sqlCmd = &cobra.Command{
		Use:   "sql",
		Short: "Process SQL database",
		Run: func(cmd *cobra.Command, args []string) {
			sql.HandleEmployees(cmd, args)
		},
		// Run: func(cmd *cobra.Command, args []string) {
		// ctx := gofr.NewContext(nil, nil, nil)
		// result, err := sql.HandleEmployees(ctx)
		// if err != nil {
		// 	fmt.Println("Error:", err)
		// 	os.Exit(1)
		// }
		// fmt.Println(result)
		// },
		// func(cmd *cobra.Command, args []string) {
		// 	ctx := gofr.NewContext(nil, nil, nil)
		// 	result, err := sql.HandleEmployees(ctx)
		// 	if err != nil {
		// 		fmt.Println("Error:", err)
		// 		os.Exit(1)
		// 	}
		// 	fmt.Println(result)
		// },
	}

	rootCmd.AddCommand(sqlCmd)
	if err := rootCmd.Execute(); err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	app.Run()

}
