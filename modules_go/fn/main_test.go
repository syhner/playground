package main

import (
	"context"
	"testing"

	"github.com/aws/aws-lambda-go/events"
)

func TestHandler(t *testing.T) {
	ctx := context.Background()

	t.Run("successful request with input parameter", func(t *testing.T) {
		request := events.APIGatewayProxyRequest{
			QueryStringParameters: map[string]string{
				"input": "hello world",
			},
		}

		response, err := handler(ctx, request)

		if err != nil {
			t.Fatalf("Expected no error, got %v", err)
		}

		if response.StatusCode != 200 {
			t.Errorf("Expected status code 200, got %d", response.StatusCode)
		}

		expectedBody := "hello world"
		if response.Body != expectedBody {
			t.Errorf("Expected body '%s', got '%s'", expectedBody, response.Body)
		}
	})

	t.Run("missing input parameter", func(t *testing.T) {
		request := events.APIGatewayProxyRequest{
			QueryStringParameters: map[string]string{},
		}

		response, err := handler(ctx, request)

		if err != nil {
			t.Fatalf("Expected no error, got %v", err)
		}

		if response.StatusCode != 400 {
			t.Errorf("Expected status code 400, got %d", response.StatusCode)
		}

		expectedBody := "Missing 'input' query parameter"
		if response.Body != expectedBody {
			t.Errorf("Expected body '%s', got '%s'", expectedBody, response.Body)
		}
	})

	t.Run("nil query string parameters", func(t *testing.T) {
		request := events.APIGatewayProxyRequest{
			QueryStringParameters: nil,
		}

		response, err := handler(ctx, request)

		if err != nil {
			t.Fatalf("Expected no error, got %v", err)
		}

		if response.StatusCode != 400 {
			t.Errorf("Expected status code 400, got %d", response.StatusCode)
		}

		expectedBody := "Missing 'input' query parameter"
		if response.Body != expectedBody {
			t.Errorf("Expected body '%s', got '%s'", expectedBody, response.Body)
		}
	})

	t.Run("empty input parameter", func(t *testing.T) {
		request := events.APIGatewayProxyRequest{
			QueryStringParameters: map[string]string{
				"input": "",
			},
		}

		response, err := handler(ctx, request)

		if err != nil {
			t.Fatalf("Expected no error, got %v", err)
		}

		if response.StatusCode != 200 {
			t.Errorf("Expected status code 200, got %d", response.StatusCode)
		}

		expectedBody := ""
		if response.Body != expectedBody {
			t.Errorf("Expected body '%s', got '%s'", expectedBody, response.Body)
		}
	})
}
