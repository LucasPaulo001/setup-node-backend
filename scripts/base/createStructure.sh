#!/bin/bash

#Estrutura de pastas
mkdir -p backend/src/{routes,models,middlewares,controllers,settings/database}

cd backend || exit

# Configurando o .gitignore
cat <<EOF > .gitignore
 node_modules
 .env
EOF

# Criando o .env
cat <<EOF > .env
PORT=8080
EOF

