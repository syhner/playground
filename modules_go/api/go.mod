module api

go 1.25.0

replace core => ../core

require (
	core v0.0.0-00010101000000-000000000000
	github.com/aws/aws-lambda-go v1.49.0
	github.com/awslabs/aws-lambda-go-api-proxy v0.16.2
	github.com/danielgtaylor/huma/v2 v2.34.1
	github.com/sst/sst/v3 v3.17.10
)
