package handlers

import (
	"github.com/gofiber/fiber/v2"
	"kafka-microservice/kafka"
)

func SendData(producer *kafka.KafkaProducer, topic string) fiber.Handler {
	return func(c *fiber.Ctx) error {
		var data map[string]interface{}
		if err := c.BodyParser(&data); err != nil {
			return c.Status(400).SendString("Invalid data")
		}

		message, _ := json.Marshal(data)
		err := producer.SendMessage(topic, string(message))
		if err != nil {
			return c.Status(500).SendString("Failed to send data")
		}

		return c.SendString("Data sent successfully")
	}
}
