package kafka

import (
	"log"

	"github.com/IBM/sarama"
)

type KafkaConsumer struct {
	consumer sarama.Consumer
}

func NewConsumer(brokers string) *KafkaConsumer {
	consumer, err := sarama.NewConsumer([]string{brokers}, nil)
	if err != nil {
		log.Fatalf("Failed to create Kafka consumer: %v", err)
	}

	return &KafkaConsumer{consumer: consumer}
}

func (c *KafkaConsumer) Consume(topic string, callback func(message string)) {
	partitionConsumer, err := c.consumer.ConsumePartition(topic, 0, sarama.OffsetOldest)
	if err != nil {
		log.Fatalf("Failed to consume Kafka topic: %v", err)
	}
	defer partitionConsumer.Close()

	for message := range partitionConsumer.Messages() {
		callback(string(message.Value))
	}
}