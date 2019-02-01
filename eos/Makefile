contract  		= securitytoken
cleos           = cleos -v -u http://jungle2.cryptolions.io:80
eos_account     = hanzoooooooo
eos_private_key = 5KGmewL9h66E9ZwNSzdBFZCjNkwTDneChCrouxxojccqDmUyHhJ
eos_public_key  = EOS8c8Lt5s7TjSsz8zmEgEQvfXrahnsDV2rJKgih4oCNHQsZbcqDZ

all: build

build:
	eosio-cpp -I include -o $(contract).wasm ./src/$(contract).cpp --abigen
	eosio-abigen src/$(contract).cpp --contract=$(contract) --output=$(contract).abi
	@mkdir -p ./$(contract)
	@mv *.{abi,wasm} ./$(contract)

clean:
	rm -rf ./$(contract)

deploy:
	$(cleos) set contract $(eos_account) ./$(contract)

create:
	$(cleos) push action $(eos_account) create '{"issuer":"hanzoooooooo", "maximum_supply":"1000.0000 USTR"}' -p $(eos_account)

retire:
	$(cleos) push action $(eos_account) retire '{"quantity":"1000.0000 USTR", "memo":"test"}' -p $(eos_account)

issue:
	$(cleos) push action $(eos_account) issue '{"to":"hanzotester1", "quantity":"42.0000 UST", "memo": "test"}' -p $(eos_account)

transfer:
	$(cleos) push action $(eos_account) transfer '{"from":"hanzoooooooo", "to":"hanzotester1",  "quantity":"42.0000 USTR", "memo":"test"}' -p $(eos_account)

pause:
	$(cleos) push action $(eos_account) pause '{}' -p $(eos_account)

buyram:
	$(cleos) system buyram $(eos_account) $(eos_account) --kbytes 300
