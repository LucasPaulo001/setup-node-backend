#!/bin/bash

source ./createStructure.sh

cd $package || exit
echo "Instalando dependências base..."
npm install express dotenv cors
npm install nodemon --save-dev
