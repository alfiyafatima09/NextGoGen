package csv

import (
	"encoding/csv"
	"encoding/json"
	"fmt"
	"io"
	"os"
)

type CsvRecord map[string]string

func ConvertCSVToJSON(csvFilePath string) (string, error) {
	// fmt.Print("Hello 123")
	file, err := os.Open(csvFilePath)
	if err != nil {
		return "", fmt.Errorf("could not open CSV file: %v", err)
	}
	defer file.Close()

	reader := csv.NewReader(file)

	var records []CsvRecord

	headers, err := reader.Read()
	if err != nil {
		if err == io.EOF {
			return "", fmt.Errorf("CSV file is empty")
		}
		return "", fmt.Errorf("could not read header line: %v", err)
	}

	for {
		record, err := reader.Read()
		if err == io.EOF {
			break
		}
		if err != nil {
			return "", fmt.Errorf("could not read record: %v", err)
		}

		recordMap := make(CsvRecord)
		for i, field := range record {
			recordMap[headers[i]] = field
		}

		records = append(records, recordMap)
	}
	jsonData, err := json.MarshalIndent(records, "", "  ")
	if err != nil {
		return "", fmt.Errorf("could not convert to JSON: %v", err)
	}
	fmt.Println(string(jsonData))
	return string(jsonData), nil
}
