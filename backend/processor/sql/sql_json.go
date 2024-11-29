package sql

import (
	"database/sql"
	"fmt"
	"strings"

	_ "github.com/go-sql-driver/mysql"
	"github.com/spf13/cobra"
)

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
func ConvertSQLToJSON(cmd *cobra.Command, args []string) ([]Employee, error) {
	dsn := fmt.Sprintf("%s:%s@tcp(%s:%s)/%s", dbUser, dbPassword, dbHost, dbPort, dbName)
	dbInput := strings.Join(args, " ")
	db, err := sql.Open(dbInput, dsn)
	if err != nil {
		return nil, fmt.Errorf("failed to connect to the database: %v", err)
	}
	defer db.Close()

	rows, err := db.Query("SELECT id, name, email, age FROM employees")
	if err != nil {
		return nil, fmt.Errorf("failed to fetch data from the database: %v", err)
	}
	defer rows.Close()

	var employees []Employee
	for rows.Next() {
		var emp Employee
		if err := rows.Scan(&emp.ID, &emp.Name, &emp.Email, &emp.Age); err != nil {
			return nil, fmt.Errorf("error scanning database rows: %v", err)
		}
		employees = append(employees, emp)
	}

	if err := rows.Err(); err != nil {
		return nil, fmt.Errorf("error iterating through rows: %v", err)
	}

	return employees, nil
}
