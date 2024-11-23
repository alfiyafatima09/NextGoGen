package routes

import (
	"github.com/gofiber/fiber/v2"
	"kafka-microservice/handlers"
	"kafka-microservice/kafka"
	"kafka-microservice/config"
)

func SetupRoutes(app *fiber.App, cfg *config.Config, producer *kafka.KafkaProducer) {
	app.Post("/send-data", handlers.SendData(producer, cfg.RawTopic))
}
