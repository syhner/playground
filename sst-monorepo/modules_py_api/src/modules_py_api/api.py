from fastapi import FastAPI, Request
from modules_py_core.echo import echo
from sst import Resource

api = FastAPI()


@api.get("/")
async def root(request: Request) -> str:
    print(f"event: {request.scope['aws.event']}")
    print(f"context: {request.scope['aws.context']}")

    # Use the SST SDK to access resources
    print(f"Resource.Linkable.foo: {Resource.Linkable.foo}")

    return "hello world"


@api.get("/echo")
async def handle(input: int) -> int:
    return echo(input)
