package xml

import (
	"encoding/json"
	"encoding/xml"
	"fmt"
	"io/ioutil"

	"path/filepath"
	"strings"
)

type XMLToJSONConverter struct{}
type XMLNode struct {
	XMLName  xml.Name
	Attrs    []xml.Attr `xml:",any,attr"`
	Content  []byte     `xml:",chardata"`
	Children []XMLNode  `xml:",any"`
}

func NewXMLToJSONConverter() *XMLToJSONConverter {
	return &XMLToJSONConverter{}
}

func (c *XMLToJSONConverter) ConvertFile(inputPath string) ([]byte, error) {
	xmlData, err := ioutil.ReadFile(inputPath)
	if err != nil {
		return nil, fmt.Errorf("error reading XML file: %v", err)
	}

	var root XMLNode
	if err := xml.Unmarshal(xmlData, &root); err != nil {
		return nil, fmt.Errorf("error parsing XML: %v", err)
	}

	jsonMap := c.nodeToMap(&root)
	jsonData, err := json.MarshalIndent(jsonMap, "", "    ")
	fmt.Print(jsonData)
	if err != nil {
		return nil, fmt.Errorf("error converting to JSON: %v", err)
	}

	outputPath := changeExtensionToJSON(inputPath)

	if err := ioutil.WriteFile(outputPath, jsonData, 0644); err != nil {
		return nil, fmt.Errorf("error writing JSON file: %v", err)
	}

	return jsonData, nil
}

func (c *XMLToJSONConverter) nodeToMap(node *XMLNode) map[string]interface{} {
	result := make(map[string]interface{})

	if len(node.Attrs) > 0 {
		attrs := make(map[string]string)
		for _, attr := range node.Attrs {
			attrs[attr.Name.Local] = attr.Value
		}
		result["@attributes"] = attrs
	}

	childrenMap := make(map[string]interface{})
	for _, child := range node.Children {
		childContent := string(child.Content)
		childName := child.XMLName.Local

		if childName == "" {
			continue
		}

		var value interface{}
		if len(child.Children) > 0 {
			value = c.nodeToMap(&child)
		} else if len(child.Content) > 0 {
			value = strings.TrimSpace(childContent)
		}

		if existing, ok := childrenMap[childName]; ok {
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

	if len(node.Content) > 0 && len(childrenMap) == 0 {
		content := strings.TrimSpace(string(node.Content))
		if content != "" {
			result["#text"] = content
		}
	}

	for k, v := range childrenMap {
		result[k] = v
	}

	return result
}

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
