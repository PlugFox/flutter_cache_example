.PHONY: create build

create:
	@docker compose -f ./docker-compose.yml build

build:
	-docker run --rm -it -v ${PWD}:/root/app -w /root/app --network none --name flutter_cache_example flutter_cache_example /bin/bash \
		-ci 'shopt -s dotglob && cp -rf /root/dependencies/* ./ \
		&& flutter analyze --no-pub --current-package --congratulate \
		--current-package --no-fatal-infos --fatal-warnings --no-preamble'
