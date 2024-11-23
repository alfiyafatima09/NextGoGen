package main

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"log"
	"net/http"

	_ "github.com/go-sql-driver/mysql" // MySQL driver
)

// Employee represents a single row of data from the database
type Employee struct {
	ID    int    `json:"id"`
	Name  string `json:"name"`
	Email string `json:"email"`
	Age   int    `json:"age"`
}

// Database credentials
const (
	dbUser     = "root"       // MySQL username
	dbPassword = "Geethika@1" // MySQL password
	dbHost     = "127.0.0.1"  // Database host (e.g., localhost)
	dbPort     = "3306"       // MySQL port
	dbName     = "golang"     // Your database name
)

// HandleEmployees fetches data from the database and writes it as JSON to the response writer
func HandleEmployees(w http.ResponseWriter, r *http.Request) {
	// Create a connection string
	dsn := fmt.Sprintf("%s:%s@tcp(%s:%s)/%s", dbUser, dbPassword, dbHost, dbPort, dbName)

	// Connect to the database
	db, err := sql.Open("mysql", dsn)
	if err != nil {
		http.Error(w, "Failed to connect to the database", http.StatusInternalServerError)
		log.Printf("Database connection error: %v", err)
		return
	}
	defer db.Close()

	// Query data
	query := "SELECT id, name, email, age FROM employees" // Modify `employees` to your actual table name
	rows, err := db.Query(query)
	if err != nil {
		http.Error(w, "Failed to fetch data from the database", http.StatusInternalServerError)
		log.Printf("Query execution error: %v", err)
		return
	}
	defer rows.Close()

	// Iterate over rows and construct a slice of Employee structs
	var employees []Employee
	for rows.Next() {
		var emp Employee
		if err := rows.Scan(&emp.ID, &emp.Name, &emp.Email, &emp.Age); err != nil {
			http.Error(w, "Error scanning database rows", http.StatusInternalServerError)
			log.Printf("Row scanning error: %v", err)
			return
		}
		employees = append(employees, emp)
	}

	// Check for errors during iteration
	if err := rows.Err(); err != nil {
		http.Error(w, "Error iterating through rows", http.StatusInternalServerError)
		log.Printf("Row iteration error: %v", err)
		return
	}

	// Convert the slice of structs to JSON
	jsonData, err := json.Marshal(employees)
	if err != nil {
		http.Error(w, "Error converting data to JSON", http.StatusInternalServerError)
		log.Printf("JSON marshaling error: %v", err)
		return
	}

	// Set content type and write JSON data to response
	w.Header().Set("Content-Type", "application/json")
	w.Write(jsonData)
}
