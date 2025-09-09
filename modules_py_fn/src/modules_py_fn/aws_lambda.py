from sst import Resource
from modules_py_core.echo import echo


def handler(event, context):
    print(f"event: {event}")
    print(f"context: {context}")

    # Use the SST SDK to access resources
    print(f"Resource.Linkable.foo: {Resource.Linkable.foo}")

    return {
        "statusCode": 200,
        "body": f"{echo(event['queryStringParameters']['input'])}",
    }
