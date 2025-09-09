package main

import (
	"context"
	"fmt"

	"core"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/sst/sst/v3/sdk/golang/resource"
)

func handler(ctx context.Context, request events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	// Use the SST SDK to access resources
	linkable, _ := resource.Get("Linkable")
	fmt.Println(linkable)

	input, exists := request.QueryStringParameters["input"]
	if !exists {
		return events.APIGatewayProxyResponse{
			StatusCode: 400,
			Body:       "Missing 'input' query parameter",
		}, nil
	}

	return events.APIGatewayProxyResponse{
		StatusCode: 200,
		Body:       core.Echo(input),
	}, nil
}

func main() {
	lambda.Start(handler)
}
