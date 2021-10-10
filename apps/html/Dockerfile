# FROM node:14-alpine AS deps
# RUN apk add --no-cache libc6-compat
# WORKDIR /app

# COPY ./dist/apps/html .

# RUN yarn install --frozen-lockfile

# EXPOSE 3000

# CMD ["yarn", "start"]
FROM node:lts-alpine
WORKDIR /app
COPY ./dist/apps/html .
ENV PORT=3334
EXPOSE ${PORT}
RUN npm install --production
RUN npm install reflect-metadata tslib rxjs hbs
CMD node ./main.js