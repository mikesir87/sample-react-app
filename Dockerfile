FROM node:lts AS build
WORKDIR /usr/local/app
COPY package.json yarn.lock ./
RUN --mount=type=cache,id=yarn,target=/root/.yarn yarn install
COPY ./.eslintrc.cjs ./index.html ./vite.config.js ./
COPY ./public ./public
COPY ./src ./src
RUN yarn build

FROM nginx:alpine
COPY ./nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /usr/local/app/dist /usr/share/nginx/html
