REBAR=./rebar

all: deps compile_all

compile_all:
	$(REBAR) compile

compile:
	$(REBAR) compile skip_deps=true

deps:
	$(REBAR) get-deps

clean:
	$(REBAR) clean

test: test_eunit test_ct

test_eunit:
	$(REBAR) eunit skip_deps=true

shell:
	erl -pz ebin

xref: compile
	$(REBAR) xref skip_deps=true

test_ct: compile
	$(REBAR) ct skip_deps=true

dia:
	dialyzer --src -r src

.PHONY: all compile_all compile deps clean test shell xref test_ct test_eunit
