package xml

import (
	"encoding/json"
	"encoding/xml"
	"fmt"
	"io/ioutil"
	"os"
	"path/filepath"
)

// XMLToJSONConverter handles the XML to JSON conversion
type XMLToJSONConverter struct{}

// NewXMLToJSONConverter creates a new converter instance
func NewXMLToJSONConverter() *XMLToJSONConverter {
	return &XMLToJSONConverter{}
}

// ConvertFile converts an XML file to JSON and saves it
func (c *XMLToJSONConverter) ConvertFile(inputPath string) (string, error) {
	// Read XML file
	xmlData, err := ioutil.ReadFile(inputPath)
	if err != nil {
		return "", fmt.Errorf("error reading XML file: %v", err)
	}

	// Create a dynamic interface to store XML data
	var data interface{}
	if err := xml.Unmarshal(xmlData, &data); err != nil {
		return "", fmt.Errorf("error parsing XML: %v", err)
	}

	// Convert to JSON
	jsonData, err := json.MarshalIndent(data, "", "    ")
	if err != nil {
		return "", fmt.Errorf("error converting to JSON: %v", err)
	}

	// Create output file path (same name but .json extension)
	outputPath := changeExtensionToJSON(inputPath)

	// Write JSON file
	if err := ioutil.WriteFile(outputPath, jsonData, 0644); err != nil {
		return "", fmt.Errorf("error writing JSON file: %v", err)
	}

	return outputPath, nil
}

// changeExtensionToJSON changes the file extension to .json
func changeExtensionToJSON(filename string) string {
	extension := filepath.Ext(filename)
	return filename[0:len(filename)-len(extension)] + ".json"
}

// ValidateXMLFile checks if the file exists and has .xml extension
func (c *XMLToJSONConverter) ValidateXMLFile(filePath string) error {
	// Check if file exists
	if _, err := os.Stat(filePath); os.IsNotExist(err) {
		return fmt.Errorf("file does not exist: %s", filePath)
	}

	// Check file extension
	if ext := filepath.Ext(filePath); ext != ".xml" {
		return fmt.Errorf("invalid file extension: %s. Expected .xml", ext)
	}

	return nil
}

// ma

// package xml

// // package main

// import (
// 	"encoding/json"
// 	"encoding/xml"
// 	"fmt"
// 	"io"
// 	"log"
// 	"net/http"

// 	"gofr.dev/pkg/gofr"
// )

// // XMLToJSONConverter handles XML to JSON conversion
// type XMLToJSONConverter struct {
// 	XMLName xml.Name               `xml:"root" json:"-"`
// 	Data    map[string]interface{} `xml:"-" json:",omitempty"`
// 	Attrs   []xml.Attr             `xml:",any,attr" json:"attributes,omitempty"`
// 	Content []interface{}          `xml:",any" json:"content,omitempty"`
// }

// // UnmarshalXML implements custom XML unmarshaling
// func (c *XMLToJSONConverter) UnmarshalXML(d *xml.Decoder, start xml.StartElement) error {
// 	c.Attrs = start.Attr
// 	c.Data = make(map[string]interface{})

// 	for {
// 		token, err := d.Token()
// 		if err == io.EOF {
// 			break
// 		}
// 		if err != nil {
// 			return err
// 		}

// 		switch t := token.(type) {
// 		case xml.StartElement:
// 			var subConverter XMLToJSONConverter
// 			if err := d.DecodeElement(&subConverter, &t); err != nil {
// 				return err
// 			}

// 			// Convert nested elements
// 			var value interface{}
// 			if len(subConverter.Content) == 1 && len(subConverter.Attrs) == 0 {
// 				value = subConverter.Content[0]
// 			} else {
// 				value = subConverter
// 			}

// 			// Handle multiple elements with same name
// 			if existing, ok := c.Data[t.Name.Local]; ok {
// 				switch v := existing.(type) {
// 				case []interface{}:
// 					c.Data[t.Name.Local] = append(v, value)
// 				default:
// 					c.Data[t.Name.Local] = []interface{}{v, value}
// 				}
// 			} else {
// 				c.Data[t.Name.Local] = value
// 			}

// 		case xml.CharData:
// 			if len(t.Copy()) > 0 {
// 				c.Content = append(c.Content, string(t.Copy()))
// 			}
// 		}
// 	}
// 	return nil
// }

// // // UnmarshalJSON implements custom JSON unmarshaling
// func (c *XMLToJSONConverter) UnmarshalJSON(data []byte) error {
// 	return json.Unmarshal(data, &c.Data)
// }

// func ConvertXMLToJSON(xmlData []byte) ([]byte, error) {
// 	var converter XMLToJSONConverter
// 	if err := xml.Unmarshal(xmlData, &converter); err != nil {
// 		return nil, fmt.Errorf("error unmarshaling XML: %v", err)
// 	}

// 	jsonData, err := json.MarshalIndent(converter.Data, "", "  ")
// 	if err != nil {
// 		return nil, fmt.Errorf("error marshaling to JSON: %v", err)
// 	}

// 	return jsonData, nil
// }

// // HandleXMLToJSON is the HTTP handler function
// func HandleXMLToJSON(ctx *gofr.Context) (interface{}, error) {
// 	// Read the XML data from the request body
// 	xmlData, err := io.ReadAll(ctx.Request)
// 	if err != nil {
// 		return nil, fmt.Errorf("Error reading request body: %v", err)
// 	}

// 	// Convert XML to JSON
// 	jsonData, err := ConvertXMLToJSON(xmlData)
// 	if err != nil {
// 		return nil, fmt.Errorf("Conversion error: %v", err)
// 	}

// 	// Parse JSON into map to return as interface{}
// 	var result map[string]interface{}
// 	err = json.Unmarshal(jsonData, &result)
// 	if err != nil {
// 		return nil, fmt.Errorf("Error unmarshaling JSON: %v", err)
// 	}

// 	return result, nil
// }

// func main() {
// 	http.HandleFunc("/convert", HandleXMLToJSON)
// 	log.Fatal(http.ListenAndServe(":8080", nil))
// }

// // package xml

// // import (
// // 	"bytes"
// // 	"encoding/json"
// // 	"encoding/xml"
// // 	"fmt"
// // 	"io"

// // 	// "github.com/gofr-dev/gofr"
// // 	"gofr.dev/pkg/gofr"
// // )

// // // XMLToJSONConverter handles XML to JSON conversion
// // type XMLToJSONConverter struct {
// // 	XMLName xml.Name               `xml:"root" json:"-"`
// // 	Data    map[string]interface{} `xml:"-" json:",omitempty"`
// // 	Attrs   []xml.Attr             `xml:",any,attr" json:"attributes,omitempty"`
// // 	Content []interface{}          `xml:",any" json:"content,omitempty"`
// // }

// // // UnmarshalXML implements custom XML unmarshaling
// // func (c *XMLToJSONConverter) UnmarshalXML(d *xml.Decoder, start xml.StartElement) error {
// // 	c.Attrs = start.Attr
// // 	c.Data = make(map[string]interface{})

// // 	for {
// // 		token, err := d.Token()
// // 		if err == io.EOF {
// // 			break
// // 		}
// // 		if err != nil {
// // 			return err
// // 		}

// // 		switch t := token.(type) {
// // 		case xml.StartElement:
// // 			var subConverter XMLToJSONConverter
// // 			if err := d.DecodeElement(&subConverter, &t); err != nil {
// // 				return err
// // 			}

// // 			var value interface{}
// // 			if len(subConverter.Content) == 1 && len(subConverter.Attrs) == 0 {
// // 				value = subConverter.Content[0]
// // 			} else {
// // 				value = subConverter
// // 			}

// // 			if existing, ok := c.Data[t.Name.Local]; ok {
// // 				switch v := existing.(type) {
// // 				case []interface{}:
// // 					c.Data[t.Name.Local] = append(v, value)
// // 				default:
// // 					c.Data[t.Name.Local] = []interface{}{v, value}
// // 				}
// // 			} else {
// // 				c.Data[t.Name.Local] = value
// // 			}

// // 		case xml.CharData:
// // 			if len(t.Copy()) > 0 {
// // 				c.Content = append(c.Content, string(t.Copy()))
// // 			}
// // 		}
// // 	}
// // 	return nil
// // }

// // func ConvertXMLToJSON(xmlData []byte) ([]byte, error) {
// // 	var converter XMLToJSONConverter
// // 	if err := xml.Unmarshal(xmlData, &converter); err != nil {
// // 		return nil, fmt.Errorf("error unmarshaling XML: %v", err)
// // 	}

// // 	jsonData, err := json.MarshalIndent(converter.Data, "", "  ")
// // 	if err != nil {
// // 		return nil, fmt.Errorf("error marshaling to JSON: %v", err)
// // 	}

// // 	return jsonData, nil
// // }

// // // Handler for XML to JSON conversion
// // func handleXMLToJSON(ctx *gofr.Context) (interface{}, error) {
// // 	body, err := io.ReadAll(ctx.Request().Body)
// // 	if err != nil {
// // 		return nil, err
// // 	}
// // 	defer ctx.Request().Body.Close()

// // 	jsonData, err := ConvertXMLToJSON(body)
// // 	if err != nil {
// // 		return nil, err
// // 	}

// // 	// Parse JSON into map to return as interface{}
// // 	var result map[string]interface{}
// // 	err = json.Unmarshal(jsonData, &result)
// // 	if err != nil {
// // 		return nil, err
// // 	}

// // 	return result, nil
// // }

// // func main() {
// // 	// Initialize GoFr app
// // 	app := gofr.New()

// // 	// Register the XML to JSON conversion endpoint
// // 	app.POST("/convert", handleXMLToJSON)

// // 	// Start the server
// // 	go app.Start()

// // 	// Example: Make a test POST request
// // 	sampleXML := `<?xml version="1.0" encoding="UTF-8"?>
// //     <root>
// //         <person id="1">
// //             <name>John</name>
// //             <age>30</age>
// //             <hobbies>
// //                 <hobby>Reading</hobby>
// //                 <hobby>Gaming</hobby>
// //             </hobbies>
// //         </person>
// //     </root>`

// // 	// Create a new HTTP client using gofr
// // 	client := gofr.NewHTTPClient()

// // 	// Make POST request
// // 	resp, err := client.Post("http://localhost:8000/convert",
// // 		"application/xml",
// // 		bytes.NewBufferString(sampleXML))

// // 	if err != nil {
// // 		fmt.Printf("Error making request: %v\n", err)
// // 		return
// // 	}
// // 	defer resp.Body.Close()

// // 	// Read and print the response
// // 	responseBody, err := io.ReadAll(resp.Body)
// // 	if err != nil {
// // 		fmt.Printf("Error reading response: %v\n", err)
// // 		return
// // 	}

// // 	fmt.Printf("Converted JSON:\n%s\n", string(responseBody))
// // }
