package routes

import (
	"github.com/alfiyafatima09/NextGoGen/backend/config"
	"github.com/alfiyafatima09/NextGoGen/backend/handlers"
	"github.com/alfiyafatima09/NextGoGen/backend/kafka"
	"github.com/gofiber/fiber/v2"
)

func SetupRoutes(app *fiber.App, cfg *config.Config, producer *kafka.KafkaProducer) {
	app.Post("/send-data", handlers.SendData(producer, cfg.RawTopic))
}
