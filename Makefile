REBAR = `which rebar`

all: deps compile

deps:
	@( $(REBAR) get-deps )

compile: clean
	@( $(REBAR) compile )

clean:
	@( $(REBAR) clean )

run:
	@( erl -noshell -pa ebin deps/*/ebin -s webserver )

plt:
	@( $(REBAR) build-plt )

dialyze: compile
	@( $(REBAR) dialyze )

.PHONY: all deps compile clean run plt dialyze
