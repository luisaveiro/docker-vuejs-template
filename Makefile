include .env

# Remove project Docker container, image, network, volume
clean:
	docker rm ${CONTAINER_NAME}
	docker rmi ${IMAGE_NAME}
	docker network rm ${NETWORK}

# Build Docker image
image:
	docker build -f docker/Dockerfile -t ${IMAGE_NAME} code

# Publish Docker image to Docker Hub
publish:
	docker push ${IMAGE_NAME}:latest

# Run Docker container
serve:
	docker run -d -p 80:8080 --name ${CONTAINER_NAME} ${IMAGE_NAME}

# Access Docker container terminal.
ssh:
	docker exec -t -i ${CONTAINER_NAME} /bin/sh

# Stop Docker container
stop:
	docker stop ${CONTAINER_NAME}
