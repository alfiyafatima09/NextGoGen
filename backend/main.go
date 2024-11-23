package main

import (
	"fmt"
	"log"
	"net/http"
)

func main() {
	http.HandleFunc("/employees", HandleEmployees)

	fmt.Println("Server is running on http://localhost:8080")
	if err := http.ListenAndServe(":8080", nil); err != nil {
		log.Fatalf("Server failed to start: %v", err)
	}
}
