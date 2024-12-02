package main

import (
	"github.com/alfiyafatima09/NextGoGen/backend/processor"
	"github.com/alfiyafatima09/NextGoGen/backend/processor/sql"
	"gofr.dev/pkg/gofr"
)

func main() {

	app := gofr.New()
	app.POST("/toJson", processor.HandleConversion)
	app.GET("/sql", func(ctx *gofr.Context) (interface{}, error) {
		args := ctx.PathParam("args")
		return sql.ConvertSQLToJSON(nil, []string{args})
	})

	app.Run()

}
