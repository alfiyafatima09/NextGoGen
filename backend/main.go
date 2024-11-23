package main

import (
	"github.com/alfiyafatima09/NextGoGen/backend/config"
	"github.com/alfiyafatima09/NextGoGen/backend/kafka"
	"github.com/alfiyafatima09/NextGoGen/backend/routes"
	"github.com/alfiyafatima09/NextGoGen/backend/processor"

	"github.com/gofiber/fiber/v2"
)

func main() {
	cfg := config.LoadConfig()

	// Initialize Kafka
	producer := kafka.NewProducer(cfg.KafkaBrokers)
	consumer := kafka.NewConsumer(cfg.KafkaBrokers)

	// Start data processing
	go processor.ProcessData(consumer, producer, cfg.RawTopic, cfg.ProcessedTopic)

	// Initialize Fiber app
	app := fiber.New()
	routes.SetupRoutes(app, cfg, producer)

	// Start server
	app.Listen(":3000")
}