package core

import (
	"testing"
)

func TestEcho(t *testing.T) {
	name := "foo"
	want := "foo"
	msg := Echo(name)
	if msg != want {
		t.Errorf("Expected %s got %s", want, msg)
	}
}
