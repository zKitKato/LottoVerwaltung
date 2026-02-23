FROM node:20-alpine

WORKDIR /app

# Abhängigkeiten installieren
COPY package.json ./
RUN npm install

# Source Code kopieren
COPY . .

# Expose Docusaurus Port
EXPOSE 3000

# Start Docusaurus
CMD ["npm", "run", "start"]