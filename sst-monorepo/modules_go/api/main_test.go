package main

import (
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"net/url"
	"testing"
)

func TestServer(t *testing.T) {
	server := Server()

	if server == nil {
		t.Fatal("Server() returned nil")
	}
}

func TestRootEndpoint(t *testing.T) {
	server := Server()

	req := httptest.NewRequest("GET", "/", nil)
	w := httptest.NewRecorder()

	server.ServeHTTP(w, req)

	if w.Code != http.StatusOK {
		t.Errorf("Expected status code %d, got %d", http.StatusOK, w.Code)
	}

	expectedContentType := "text/plain"
	if contentType := w.Header().Get("Content-Type"); contentType != expectedContentType {
		t.Errorf("Expected Content-Type %s, got %s", expectedContentType, contentType)
	}

	expectedBody := "hello world"
	if body := w.Body.String(); body != expectedBody {
		t.Errorf("Expected body %s, got %s", expectedBody, body)
	}
}

func TestEchoEndpoint(t *testing.T) {
	server := Server()

	tests := []struct {
		name     string
		input    string
		expected string
	}{
		{
			name:     "simple echo",
			input:    "hello",
			expected: "hello",
		},
		{
			name:     "empty string",
			input:    "",
			expected: "",
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			u, err := url.Parse("/echo")
			if err != nil {
				t.Fatalf("Failed to parse URL: %v", err)
			}
			q := u.Query()
			q.Set("input", tt.input)
			u.RawQuery = q.Encode()

			req := httptest.NewRequest("GET", u.String(), nil)
			w := httptest.NewRecorder()

			server.ServeHTTP(w, req)

			if w.Code != http.StatusOK {
				t.Errorf("Expected status code %d, got %d", http.StatusOK, w.Code)
				t.Logf("Response body: %s", w.Body.String())
				return
			}

			// Parse the JSON response directly
			var jsonResponse map[string]interface{}
			if err := json.Unmarshal(w.Body.Bytes(), &jsonResponse); err != nil {
				t.Fatalf("Failed to unmarshal response: %v\nResponse body: %s", err, w.Body.String())
			}

			message, ok := jsonResponse["message"].(string)
			if !ok {
				t.Fatalf("Expected 'message' field to be a string, got %T", jsonResponse["message"])
			}

			if message != tt.expected {
				t.Errorf("Expected message %s, got %s", tt.expected, message)
			}
		})
	}
}

func TestEchoEndpointWithoutInput(t *testing.T) {
	server := Server()

	req := httptest.NewRequest("GET", "/echo", nil)
	w := httptest.NewRecorder()

	server.ServeHTTP(w, req)

	if w.Code != http.StatusOK {
		t.Errorf("Expected status code %d, got %d", http.StatusOK, w.Code)
	}

	var jsonResponse map[string]interface{}
	if err := json.Unmarshal(w.Body.Bytes(), &jsonResponse); err != nil {
		t.Fatalf("Failed to unmarshal response: %v\nResponse body: %s", err, w.Body.String())
	}

	message, ok := jsonResponse["message"].(string)
	if !ok {
		t.Fatalf("Expected 'message' field to be a string, got %T", jsonResponse["message"])
	}

	if message != "" {
		t.Errorf("Expected empty message when no input provided, got %s", message)
	}
}
