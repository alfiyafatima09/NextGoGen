package main

import (
	"gofr.dev/pkg/gofr"
)

func helloWorld(ctx *gofr.Context) (interface{}, error) {
	return "Hello, World!", nil
}

func main() {
	app := gofr.New()
	app.GET("/", helloWorld)
	app.Run()
}
