up:
	docker-compose rm -f app && docker-compose build app && docker-compose up app

run:
	docker-compose rm -f app && docker-compose build app && docker-compose run app bash
