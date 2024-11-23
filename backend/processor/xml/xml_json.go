package xml

import (
	"encoding/json"
	"encoding/xml"
	"fmt"
	"io/ioutil"

	// "os"
	"path/filepath"
	"strings"
)

// XMLToJSONConverter handles the XML to JSON conversion
type XMLToJSONConverter struct{}

// XMLNode represents an XML node with attributes
type XMLNode struct {
	XMLName  xml.Name
	Attrs    []xml.Attr `xml:",any,attr"`
	Content  []byte     `xml:",chardata"`
	Children []XMLNode  `xml:",any"`
}

// NewXMLToJSONConverter creates a new converter instance
func NewXMLToJSONConverter() *XMLToJSONConverter {
	return &XMLToJSONConverter{}
}

func (c *XMLToJSONConverter) ConvertFile(inputPath string) (string, error) {
	xmlData, err := ioutil.ReadFile(inputPath)
	if err != nil {
		return "", fmt.Errorf("error reading XML file: %v", err)
	}

	// Create XMLNode to store the data
	var root XMLNode
	if err := xml.Unmarshal(xmlData, &root); err != nil {
		return "", fmt.Errorf("error parsing XML: %v", err)
	}

	// Convert XMLNode to map
	jsonMap := c.nodeToMap(&root)
	fmt.Print(jsonMap)
	jsonData, err := json.MarshalIndent(jsonMap, "", "    ")
	if err != nil {
		return "", fmt.Errorf("error converting to JSON: %v", err)
	}

	outputPath := changeExtensionToJSON(inputPath)

	if err := ioutil.WriteFile(outputPath, jsonData, 0644); err != nil {
		return "", fmt.Errorf("error writing JSON file: %v", err)
	}

	return outputPath, nil
}

func (c *XMLToJSONConverter) nodeToMap(node *XMLNode) map[string]interface{} {
	result := make(map[string]interface{})

	// Add attributes if present
	if len(node.Attrs) > 0 {
		attrs := make(map[string]string)
		for _, attr := range node.Attrs {
			attrs[attr.Name.Local] = attr.Value
		}
		result["@attributes"] = attrs
	}

	// Add children
	childrenMap := make(map[string]interface{})
	for _, child := range node.Children {
		childContent := string(child.Content)
		childName := child.XMLName.Local

		// Skip empty nodes
		if childName == "" {
			continue
		}

		// Process child node
		var value interface{}
		if len(child.Children) > 0 {
			value = c.nodeToMap(&child)
		} else if len(child.Content) > 0 {
			value = strings.TrimSpace(childContent)
		}

		// Add to children map
		if existing, ok := childrenMap[childName]; ok {
			// If key already exists, convert to array
			switch existing.(type) {
			case []interface{}:
				childrenMap[childName] = append(existing.([]interface{}), value)
			default:
				childrenMap[childName] = []interface{}{existing, value}
			}
		} else {
			childrenMap[childName] = value
		}
	}

	// Add text content if present and no children
	if len(node.Content) > 0 && len(childrenMap) == 0 {
		content := strings.TrimSpace(string(node.Content))
		if content != "" {
			result["#text"] = content
		}
	}

	// Merge children into result
	for k, v := range childrenMap {
		result[k] = v
	}

	return result
}

// changeExtensionToJSON changes the file extension to .json
func changeExtensionToJSON(filename string) string {
	extension := filepath.Ext(filename)
	return filename[0:len(filename)-len(extension)] + ".json"
}

// func (c *XMLToJSONConverter) ValidateXMLFile(filePath string) error {
// 	if _, err := os.Stat(filePath); os.IsNotExist(err) {
// 		return fmt.Errorf("file does not exist: %s", filePath)
// 	}

// 	if ext := filepath.Ext(filePath); ext != ".xml" {
// 		return fmt.Errorf("invalid file extension: %s. Expected .xml", ext)
// 	}

// 	return nil
// }
