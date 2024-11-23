package csv

import (
	"encoding/csv"
	"encoding/json"
	"fmt"
	"io"
	"os"
)

// Struct to hold the CSV record as a map (for flexibility)
type CsvRecord map[string]string

// ConvertCSVToJSON function to convert CSV file to JSON
func ConvertCSVToJSON(csvFilePath string) ([]byte, error) {
	// Open the CSV file
	file, err := os.Open(csvFilePath)
	if err != nil {
		return nil, fmt.Errorf("could not open CSV file: %v", err)
	}
	defer file.Close()

	// Initialize CSV reader
	reader := csv.NewReader(file)

	// Read all rows from the CSV file
	var records []CsvRecord

	// Read header line (for mapping column names to keys)
	headers, err := reader.Read()
	if err != nil {
		if err == io.EOF {
			return nil, fmt.Errorf("CSV file is empty")
		}
		return nil, fmt.Errorf("could not read header line: %v", err)
	}

	// Read all records and map them to the CSV header
	for {
		record, err := reader.Read()
		if err == io.EOF {
			break
		}
		if err != nil {
			return nil, fmt.Errorf("could not read record: %v", err)
		}

		// Create a map for the current record using the headers
		recordMap := make(CsvRecord)
		for i, field := range record {
			recordMap[headers[i]] = field
		}

		// Append the record to the list of records
		records = append(records, recordMap)
	}

	// Convert the list of records to JSON
	jsonData, err := json.MarshalIndent(records, "", "  ")
	if err != nil {
		return nil, fmt.Errorf("could not convert to JSON: %v", err)
	}

	return jsonData, nil
}

func main() {
	// Path to the CSV file
	csvFilePath := "example.csv" // Replace with the actual path to your CSV file

	// Convert CSV to JSON
	jsonData, err := ConvertCSVToJSON(csvFilePath)
	if err != nil {
		fmt.Println("Error:", err)
		return
	}

	// Print the resulting JSON
	fmt.Println(string(jsonData))
}
