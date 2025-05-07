#!/bin/bash

source ./createStructure.sh
ls

echo "Instalando dependências base..."
npm install express dotenv cors
npm install nodemon --save-dev
