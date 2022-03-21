.PHONY: clean cache build shell

clean:
	@flutter clean

cache: clean
	@docker compose -f ./docker-compose.yml build

# --network none
build: clean
	-docker run --rm -it -v ${PWD}:/root/app -w /root/app --user=root:root \
		--name flutter_cache_example flutter_cache_example /bin/bash \
		-ci 'shopt -s dotglob && cp -rf /tmp/dependencies/* ./ \
		&& flutter analyze --no-pub --current-package --congratulate \
			--current-package --no-fatal-infos --fatal-warnings --no-preamble \
		&& flutter build apk --no-pub --release --target-platform android-x64'

check: clean
	-docker run --rm -it -v ${PWD}:/root/app -w /root/app --user=root:root \
    		--name flutter_cache_example flutter_cache_example /bin/bash \
    		-ci 'shopt -s dotglob && cp -rf /tmp/dependencies/* /root/app/ \
			&& flutter analyze --no-pub --current-package --congratulate \
				--current-package --no-fatal-infos --fatal-warnings --no-preamble \
			&& /bin/bash'

shell:
	-docker run --rm -it -v ${PWD}:/root/app -w /root/app --user=root:root \
		--name flutter_cache_example flutter_cache_example /bin/bash

