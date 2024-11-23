package main

import (
	"database/sql"
	"fmt"
	_ "github.com/go-sql-driver/mysql" 
	"gofr.dev/pkg/gofr"
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
func HandleEmployees(ctx *gofr.Context) (interface{}, error) {
	// Create a connection string
	dsn := fmt.Sprintf("%s:%s@tcp(%s:%s)/%s", dbUser, dbPassword, dbHost, dbPort, dbName)

	// Connect to the database
	db, err := sql.Open("mysql", dsn)
	if err != nil {
		return nil, fmt.Errorf("Failed to connect to the database: %v", err)
	}
	defer db.Close()

	// Query data
	query := "SELECT id, name, email, age FROM employees" // Modify `employees` to your actual table name
	rows, err := db.Query(query)
	if err != nil {
		return nil, fmt.Errorf("Failed to fetch data from the database: %v", err)
	}
	defer rows.Close()

	// Iterate over rows and construct a slice of Employee structs
	var employees []Employee
	for rows.Next() {
		var emp Employee
		if err := rows.Scan(&emp.ID, &emp.Name, &emp.Email, &emp.Age); err != nil {
			return nil, fmt.Errorf("Error scanning database rows: %v", err)
		}
		employees = append(employees, emp)
	}

	// Check for errors during iteration
	if err := rows.Err(); err != nil {
		return nil, fmt.Errorf("Error iterating through rows: %v", err)
	}

	// Return the list of employees as JSON
	return employees, nil
}
