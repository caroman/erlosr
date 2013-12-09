all: build

%.beam: %.erl
	erlc -o test/ $<

build: c_src/erlosr.c
	./rebar compile

build-for-check: clean
	./rebar -C rebar_makecheck.config compile

check-only:  test/etap.beam
	prove test/*.t

check-only-verbose: test/etap.beam
	prove -v test/*.t

check: build-for-check check-only
	./rebar clean
	rm -fr priv

check-verbose: build-for-check check-only-verbose
	./rebar clean
	rm -fr priv

clean:
	./rebar clean
	rm -fr priv

dialyzer-build: build
	dialyzer --build_plt --output_plt erlosr.plt \
        -o dialyzer.build \
        -r src ebin
