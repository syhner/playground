from unittest.mock import MagicMock
import sys

mock_sst = MagicMock()
mock_sst.Resource.Linkable.foo = "mocked-resource-value"
sys.modules["sst"] = mock_sst

from modules_py_fn.aws_lambda import handler


def test_echo():
    mock_event = {"queryStringParameters": {"input": 42}}
    mock_context = {}

    response = handler(mock_event, mock_context)

    assert response["statusCode"] == 200
    assert response["body"] == "42"
