FROM node:21.7.3-slim AS base
ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"
RUN corepack enable
COPY . /app
WORKDIR /app

FROM base AS prod-deps
RUN pnpm install

FROM base AS build
RUN pnpm install
RUN pnpm docs:build

FROM base
COPY --from=prod-deps /app/node_modules /app/node_modules
COPY --from=build /app/docs/.vitepress/dist /app/docs/.vitepress/dist

EXPOSE 4173
CMD [ "pnpm", "docs:preview" ]