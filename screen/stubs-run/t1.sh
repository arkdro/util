#!/bin/sh

export GOPATH=$HOME/util/go
cd $HOME/stubs/dummy-server
go run server.go
