# FROM node:14-alpine AS deps
# RUN apk add --no-cache libc6-compat
# WORKDIR /app

# COPY ./dist/apps/api .

# RUN yarn install --frozen-lockfile

# EXPOSE 3000

# CMD ["yarn", "start"]

FROM node:lts-alpine
WORKDIR /app
COPY ./dist/apps/api .
ENV PORT=3333
EXPOSE ${PORT}
RUN npm install --production
# dependencies that nestjs needs
RUN npm install reflect-metadata tslib rxjs @nestjs/platform-express
CMD node ./main.js