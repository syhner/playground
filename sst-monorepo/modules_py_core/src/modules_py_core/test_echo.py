from modules_py_core.echo import echo


class TestEcho:
    """Test cases for the echo function."""

    def test_echo_string(self):
        """Test echo with string input."""
        input_str = "hello world"
        result = echo(input_str)
        assert result == input_str
        assert isinstance(result, str)

    def test_echo_integer(self):
        """Test echo with integer input."""
        input_int = 42
        result = echo(input_int)
        assert result == input_int
        assert isinstance(result, int)

    def test_echo_float(self):
        """Test echo with float input."""
        input_float = 3.14159
        result = echo(input_float)
        assert result == input_float
        assert isinstance(result, float)

    def test_echo_boolean_true(self):
        """Test echo with boolean True input."""
        input_bool = True
        result = echo(input_bool)
        assert result == input_bool
        assert isinstance(result, bool)

    def test_echo_none(self):
        """Test echo with None input."""
        input_none = None
        result = echo(input_none)
        assert result == input_none
        assert result is None
