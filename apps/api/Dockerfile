FROM node:14-alpine AS deps
RUN apk add --no-cache libc6-compat
WORKDIR /app

COPY ./dist/apps/api .

RUN yarn install --frozen-lockfile

EXPOSE 3000

CMD ["yarn", "start"]
