package main

import (
	// "github.com/alfiyafatima09/NextGoGen/backend/config"
	// "encoding/xml"
	// "fmt"

	"fmt"

	"github.com/alfiyafatima09/NextGoGen/backend/processor/xml"
	// "github.com/gofiber/fiber/v2"
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

	// Create converter instance
	xmlConverter := xml.NewXMLToJSONConverter()

	// Validate input file
	if err := xmlConverter.ValidateXMLFile(req.FilePath); err != nil {
		return nil, err
	}

	// Convert file
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
	app.Run()
	// fmt.Print(abc)

	// cfg := config.LoadConfig()

	// Initialize Kafka
	// producer := kafka.NewProducer(cfg.KafkaBrokers)
	// consumer := kafka.NewConsumer(cfg.KafkaBrokers)

	// go processor.ProcessData(consumer, producer, cfg.RawTopic, cfg.ProcessedTopic)

	// Initialize Fiber app
	// app := fiber.New()
	// routes.SetupRoutes(app, cfg, producer)

	// Start server
	// app.Listen(":3000")
}
