package processor

import (
	"encoding/base64"
	"fmt"

	"github.com/alfiyafatima09/NextGoGen/backend/processor/csv"
	"github.com/alfiyafatima09/NextGoGen/backend/processor/xml"
	"gofr.dev/pkg/gofr"
)

type ConversionRequest struct {
	FileData  string `json:"fileData"`
	Extension string `json:"extension"`
	FileName  string `json:"fileName"`
}
type ConversionResponse struct {
	OutputPath []byte `json:"outputPath"`
	Message    string `json:"message"`
}

func toJson(fileBytes []byte, extension string) (interface{}, error) {
	if extension == "xml" {
		jsonData, err := xml.NewXMLToJSONConverter().ConvertBytesToJson(fileBytes)
		if err != nil {
			return nil, fmt.Errorf("error converting XML to JSON: %v", err)
		}
		return jsonData, nil
	} else if extension == "csv" {
		jsonData, err := csv.NewCSVToJSONConverter().ConvertBytesToJson(fileBytes)
		if err != nil {
			return nil, fmt.Errorf("error converting CSV to JSON: %v", err)
		}
		return jsonData, nil
	}
	return nil, nil
}
func HandleConversion(ctx *gofr.Context) (interface{}, error) {
	var req ConversionRequest
	if err := ctx.Bind(&req); err != nil {
		return nil, fmt.Errorf("invalid request format: %v", err)
	}

	fileBytes, err := base64.StdEncoding.DecodeString(req.FileData)
	if err != nil {
		return nil, fmt.Errorf("error decoding base64 data: %v", err)
	}

	jsonData, err := toJson(fileBytes, req.Extension)
	if err != nil {
		return nil, fmt.Errorf("error converting file to JSON: %v", err)
	}

	return ConversionResponse{
		OutputPath: jsonData.([]byte),
		Message:    "File converted successfully",
	}, nil
}
