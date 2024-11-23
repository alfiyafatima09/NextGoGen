package routes

import (
	"github.com/gofiber/fiber/v2"
	"github.com/alfiyafatima09/NextGoGen/backend/handlers"
	"github.com/alfiyafatima09/NextGoGen/backend/kafka"
	"github.com/alfiyafatima09/NextGoGen/backend/config"
)

func SetupRoutes(app *fiber.App, cfg *config.Config, producer *kafka.KafkaProducer) {
	app.Post("/send-data", handlers.SendData(producer, cfg.RawTopic))
}
