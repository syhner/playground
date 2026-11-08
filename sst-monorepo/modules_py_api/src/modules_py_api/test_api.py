from fastapi.testclient import TestClient
from .api import api

client = TestClient(api)


def test_echo():
    response = client.get("/echo?input=42")
    assert response.status_code == 200
    assert response.json() == 42
