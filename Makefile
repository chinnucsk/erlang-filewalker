.PHONY: all deps compile release debs test clean

REBAR=rebar
FPM=fpm

RELEASES = rel/filewalker

all: deps compile

deps:
	@$(REBAR) get-deps
	@$(REBAR) update-deps
compile: deps
	@$(REBAR) compile

release: compile
	@$(REBAR) generate

test:
	@$(REBAR) skip_deps=true eunit
clean:
	-@rm *.deb
	@$(REBAR) clean
	@$(REBAR) delete-deps

debs: release 
	-@rm *.deb
	$(foreach rel, $(RELEASES), \
		@$(FPM) \
			-s dir \
			-t deb \
			-n $(notdir $(rel)) \
			-v $(shell git describe) \
			--prefix /opt/$(notdir $(rel)) \
			-C $(rel) \
			$(shell ls $(rel)) \
		; \
	)
