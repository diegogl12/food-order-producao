message := '{"numero_pedido": "2d998c18-23ac-11f0-81ff-0242ac160004", "lista_produtos": ["1", "2", "3"]}'
queue_name := producao

create_message:
	aws sqs send-message \
  	--endpoint-url http://localhost:4566 \
  	--queue-url "http://localhost:4566/000000000000/$(queue_name)" \
  	--message-body $(message)\
  	--region us-east-1 \
  	--profile localstack

up:
	docker-compose down -v
	docker-compose --env-file ./.env up --build
