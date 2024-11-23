package handlers

import (
	"context"
	"fmt"
	"log"
	"net/http"
	"os"
	"time"

	"github.com/segmentio/kafka-go"
)

// Kafka configuration
var (
	kafkaBroker     = os.Getenv("KAFKA_BROKERS")      // Kafka broker address
	processedTopic  = os.Getenv("PROCESSED_TOPIC")    // Topic to consume messages from
	groupID         = "microservice-consumer-group"   // Kafka consumer group
	consumerTimeout = 10 * time.Second                // Timeout for consuming messages
)

// RetrieveMessages retrieves processed messages from the Kafka topic
func RetrieveMessages(w http.ResponseWriter, r *http.Request) {
	// Kafka reader setup
	reader := kafka.NewReader(kafka.ReaderConfig{
		Brokers:  []string{kafkaBroker},
		Topic:    processedTopic,
		GroupID:  groupID,
		MaxWait:  1 * time.Second, // Maximum wait time for batch messages
		MinBytes: 10e3,            // Minimum message size in bytes
		MaxBytes: 10e6,            // Maximum message size in bytes
	})

	defer reader.Close()

	// Context with timeout for consumer
	ctx, cancel := context.WithTimeout(context.Background(), consumerTimeout)
	defer cancel()

	var messages []string

	for {
		msg, err := reader.ReadMessage(ctx)
		if err != nil {
			if err == context.DeadlineExceeded {
				break // Exit the loop on timeout
			}
			http.Error(w, fmt.Sprintf("Error reading message: %v", err), http.StatusInternalServerError)
			return
		}
		// Collect retrieved messages
		messages = append(messages, string(msg.Value))
	}

	// Send the messages as an HTTP response
	if len(messages) == 0 {
		w.WriteHeader(http.StatusNoContent)
		fmt.Fprint(w, "No messages available")
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	fmt.Fprintf(w, `{"messages": %q}`, messages)
	log.Printf("Retrieved messages: %v", messages)
}