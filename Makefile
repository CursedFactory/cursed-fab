.PHONY: devbox-build devbox-up devbox-shell devbox-check devbox-down

devbox-build:
	docker compose build devbox

devbox-up:
	docker compose up --build -d devbox

devbox-shell:
	docker compose exec devbox bash

devbox-check:
	docker compose run --rm devbox bash -lc 'node -v && npm -v && npx -v && bun -v && rustc -V && cargo -V && opencode --version'

devbox-down:
	docker compose down
