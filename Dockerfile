FROM node:20-slim AS build

WORKDIR /usr/src/app

COPY package.json yarn.lock ./

RUN corepack enable

RUN npm install && yarn

COPY . .

RUN yarn run build

RUN yarn install --production --frozen-lockfile && yarn cache clean

FROM node:20-alpine3.22

WORKDIR /usr/src/app

COPY --from=build /usr/src/app/dist ./dist
COPY --from=build /usr/src/app/node_modules ./node_modules

EXPOSE 3000

CMD ["node", "dist/main.js"]