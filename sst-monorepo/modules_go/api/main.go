package main

import (
	"context"
	"core"
	"fmt"
	"net/http"

	"github.com/danielgtaylor/huma/v2"
	"github.com/danielgtaylor/huma/v2/adapters/humago"
	"github.com/sst/sst/v3/sdk/golang/resource"
)

type EchoOutput struct {
	Body struct {
		Message string `json:"message" example:"Hello, world!" doc:"Echo message"`
	}
}

func Server() http.Handler {
	router := http.NewServeMux()
	api := humago.New(router, huma.DefaultConfig("My API", "1.0.0"))

	router.HandleFunc("/ui", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "text/html")
		w.Write([]byte(`<!DOCTYPE html>
	<html lang="en">
	<head>
		<meta charset="utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1" />
		<meta name="description" content="SwaggerUI" />
		<title>SwaggerUI</title>
		<link rel="stylesheet" href="https://unpkg.com/swagger-ui-dist@5.11.0/swagger-ui.css" />
	</head>
	<body>
	<div id="swagger-ui"></div>
	<script src="https://unpkg.com/swagger-ui-dist@5.11.0/swagger-ui-bundle.js" crossorigin></script>
	<script>
		window.onload = () => {
			window.ui = SwaggerUIBundle({
				url: '/openapi.json',
				dom_id: '#swagger-ui',
			});
		};
	</script>
	</body>
	</html>`))
	})

	router.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		// Use the SST SDK to access resources
		linkable, _ := resource.Get("Linkable")
		fmt.Println(linkable)

		w.Header().Set("Content-Type", "text/plain")
		w.Write([]byte("hello world"))
	})

	huma.Register(api, huma.Operation{
		OperationID: "echo",
		Method:      http.MethodGet,
		Path:        "/echo",
		Summary:     "Echo input",
		Description: "Echo back the input query parameter.",
		Tags:        []string{"Echo"},
	}, func(ctx context.Context, input *struct {
		Input string `query:"input" example:"hello" doc:"Input to echo back"`
	}) (*EchoOutput, error) {
		resp := &EchoOutput{}
		resp.Body.Message = core.Echo(input.Input)
		return resp, nil
	})

	return router
}
