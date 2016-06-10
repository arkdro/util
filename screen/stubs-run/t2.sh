#!/bin/sh

export GOPATH=$HOME/util/go
cd $HOME/stubs/xmpp-web-tester
go run server.go
