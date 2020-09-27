# Alpine Linux is much smaller than most distribution base images.
FROM node:14.11.0-alpine3.12

# Provide default arguments if image was not built by docker compose.
ARG ENABLE_TYPESCRIPT=false
ARG HOST=0.0.0.0
ARG PROJECT_PATH=/project

# Environment variables
ENV ENABLE_TYPESCRIPT=$ENABLE_TYPESCRIPT
ENV HOST=$HOST
ENV PROJECT_PATH=$PROJECT_PATH

# Directory Setup
RUN mkdir -p ${PROJECT_PATH}
WORKDIR ${PROJECT_PATH}

COPY . .

# Setup Vue CLI
RUN yarn global add @vue/cli

# Add TypeScript support
RUN if [ "${ENABLE_TYPESCRIPT}" = "true" ]; then yarn global add typescript; fi

# If existing vue project, install dependencies
RUN if [ -f package.json ]; then yarn install; fi

CMD ["yarn", "run", "serve"]
