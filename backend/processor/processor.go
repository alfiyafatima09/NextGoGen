package processor

import (
	"encoding/json"
	"fmt"
	"kafka-microservice/kafka"
)

func ProcessData(consumer *kafka.KafkaConsumer, producer *kafka.KafkaProducer, rawTopic, processedTopic string) {
	consumer.Consume(rawTopic, func(message string) {
		fmt.Println("Processing message:", message)

		// Add transformation logic
		var data map[string]interface{}
		_ = json.Unmarshal([]byte(message), &data)
		data["status"] = "processed"
		data["timestamp"] = fmt.Sprintf("%d", GetCurrentTimestamp())

		processedMessage, _ := json.Marshal(data)
		err := producer.SendMessage(processedTopic, string(processedMessage))
		if err != nil {
			fmt.Println("Failed to send processed message:", err)
		}
	})
}

func GetCurrentTimestamp() int64 {
	return (time.Now().UnixNano() / int64(time.Millisecond))
}
