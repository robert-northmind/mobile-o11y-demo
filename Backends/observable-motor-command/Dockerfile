FROM node:alpine

COPY package.json package-lock.json* ./
RUN npm install && npm cache clean --force
COPY logger.js ./logger.js
COPY run_script.sh ./run_script.sh
COPY server.js ./server.js
RUN chmod +x ./run_script.sh

CMD ["npm", "start"]
EXPOSE 3000