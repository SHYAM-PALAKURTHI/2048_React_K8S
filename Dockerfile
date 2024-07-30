FROM node:16
WORKDIR /app
COPY package.json ./
COPY .babelrc ./
RUN npm install
COPY ./src ./src
RUN npm run build

# Build Stage 2
# This build takes the production build from staging build

FROM node:10.15.2-alpine
WORKDIR /app
COPY package.json ./
COPY .babelrc ./
RUN npm install
COPY --from=0 /usr/src/app/dist ./dist
EXPOSE 3000
CMD npm start
