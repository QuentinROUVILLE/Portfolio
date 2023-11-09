# Etape 1: Construction de l'application
# Utiliser une image Node.js comme base
FROM node:latest as build

# Définir le répertoire de travail dans le conteneur
WORKDIR /app

# Copier les fichiers package.json et package-lock.json
COPY package*.json ./

# Installer toutes les dépendances
RUN npm install

# Copier le reste des fichiers de l'application dans le conteneur
COPY . .

# Construire l'application pour la production
RUN npm run build

# Etape 2: Serveur de production
# Utiliser une image Nginx pour servir l'application
FROM nginx:alpine

# Copier les fichiers construits depuis l'étape de construction vers le répertoire de service Nginx
COPY --from=build /app/build /usr/share/nginx/html

# Exposer le port 80 pour permettre l'accès au conteneur
EXPOSE 80

# Lancer Nginx en arrière-plan
CMD ["nginx", "-g", "daemon off;"]
