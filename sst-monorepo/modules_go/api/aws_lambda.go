package main

import (
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/awslabs/aws-lambda-go-api-proxy/httpadapter"
)

func main() {
	lambda.Start(httpadapter.NewV2(Server()).ProxyWithContext)
}
