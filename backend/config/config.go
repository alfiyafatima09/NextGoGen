package config

import (
	"log"
	"os"

	"github.com/joho/godotenv"
)

type Config struct {
	KafkaBrokers string
	RawTopic     string
	ProcessedTopic string
}

func LoadConfig() *Config {
	err := godotenv.Load(".env")
	if err != nil {
		log.Fatalf("Error loading .env file")
	}

	return &Config{
		KafkaBrokers:   os.Getenv("KAFKA_BROKERS"),
		RawTopic:       os.Getenv("RAW_TOPIC"),
		ProcessedTopic: os.Getenv("PROCESSED_TOPIC"),
	}
}