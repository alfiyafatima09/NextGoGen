package main

import (
	"fmt"
	"github.com/alfiyafatima09/NextGoGen/backend/processor/xml"
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
		return nil, fmt.Errorf("invalid request format")
	}

	xmlConverter := xml.NewXMLToJSONConverter()

	if err := xmlConverter.ValidateXMLFile(req.FilePath); err != nil {
		return nil, err
	}

	outputPath, err := xmlConverter.ConvertFile(req.FilePath)
	if err != nil {
		return nil, err
	}

	return ConversionResponse{
		OutputPath: outputPath,
		Message:    "File converted successfully",
	}, nil
}

func main() {

	app := gofr.New()

	app.POST("/xml-json", handleConversion)
	app.GET("/employees", HandleEmployees)

	app.Run()
}
