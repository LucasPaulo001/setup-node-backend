#!/bin/bash

cd backend || exit
echo "Instalando dependências base..."
npm install express dotenv cors
npm install nodemon --save-dev
