FROM node:lts AS base
WORKDIR /usr/local/app

FROM base AS dev
CMD ["yarn", "dev"]

FROM base AS build
COPY package.json yarn.lock ./
RUN --mount=type=cache,id=yarn,target=/root/.yarn yarn install
COPY ./.eslintrc.cjs ./index.html ./vite.config.js ./
COPY ./public ./public
COPY ./src ./src
RUN yarn build

FROM nginx:alpine
COPY ./nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /usr/local/app/dist /usr/share/nginx/html
