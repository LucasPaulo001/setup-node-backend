#!/bin/bash

SCRIPT_DIR=$(dirname "$0")
PROJECT_ROOT="$SCRIPT_DIR/../../backend"
cd "$PROJECT_ROOT" || exit

# Configuração do npm
echo "Deseja rodar 'npm init' (interativo) ou 'npm init -y' (padrão)?"
echo "1) npm init"
echo "2) npm init -y"
read -p "Escolha [1/2]: " init_choice

if [ "$init_choice" = "1" ]; then
    npm init
else 
    npm init -y
fi

# Tipo de módulo - Só pergunta se não for 'npm init -y'
if [ "$init_choice" = "1" ]; then
    echo "[Revisão de módulo]: Deseja o ESmodules (type: module) ou o CommonJs (padrão)?"
    echo "1) ESmodules"
    echo "2) CommonJs"
    read -p "Escolha [1/2]: " module_choice

# Verifica se o arquivo package.json existe
if [ -f "package.json" ]; then
        # Se a escolha for ESModules
        if [ "$module_choice" = "1" ]; then
            # Adiciona "type": "module" ao package.json
            if command -v jq &> /dev/null; then
                tmpfile=$(mktemp)
                jq '. + { "type": "module" }' package.json > "$tmpfile" && mv "$tmpfile" package.json
                echo "type: module adicionado ao package.json"
            else
                sed -i '/"main":/a\  "type": "module",' package.json
                echo "type: module adicionado ao package.json"
            fi
        # Se a escolha for CommonJS
        elif [ "$module_choice" = "2" ]; then
            # Remove "type": "module" se estiver configurado no package.json
            sed -i '/"type": "module"/d' package.json
            echo "type: module removido do package.json. Mantido como CommonJS."
        fi
    fi
fi

#Configuração de banco de dados
echo -e "\nEscolha o banco de dados:"
echo "1) MongoDB"
echo -e "2) Nenhum\n"
read -p "Escolha[1/2]: " db_choice

cd src || exit
# Configurações de servidor (app.js) - ESmodules
if [ "$init_choice" = "1" ] && [ "$module_choice" = "1" ]; then
    
    cat <<EOF > app.mjs
// Importando módulos
import express from "express";
import cors from "cors";
import dotenv from "dotenv";
// Outros módulos...

// Configuração de dependências
const app = express();
app.use(cors())
dotenv.config();

// Config. dados json e formulários
app.use(express.json());
app.use(express.urlencoded({extended: true}));

// Configuração de rotas
   import router from "./routes/Router.mjs";
   app.use(router);

// Conectando ao servidor
const PORT = process.env.PORT
app.listen(PORT, () => {
    console.log("Conectado ao servidor na porta", PORT);
})
EOF

#Configuração inicial de rotas (ES Modules)
cd routes || exit
cat <<EOF > Router.mjs

//Importando módulos
import express from "express";
const router = express.Router();

//Controllers
    // ...

//Rota de teste
router.get("/", (req, res) => {
    res.send("Rota principal rodando...");
})

//Outras rotas
    //...

//Exportando router
export default router;
EOF

#Configuração de banco de dados MongoDB
if [ "$db_choice" = "1" ]; then
    echo -e "\nInstalando dependências do MongoDB..."

    #Instalação de biblioteca
    npm i mongoose

#Configuração do arquivo
echo -e "\nConfigurando código base do Mongo, aguarde..."

cd ../settings/database || exit
cat << EOF > dbConnection.mjs
//Config do banco de dados

import mongoose from "mongoose";

const dbConnection = async (app) => {
    try{
        //mongoose.connect(<url de conxão aqui>);
        //console.log("Conectado ao mongoose...");
    }
    catch(error){
        console.log(error)
    }
}

export default dbConnection;

EOF

# Volta para src
    cd ../../

    # Insere o import e chamada da função no app.mjs
    sed -i '/dotenv.config();/a\\nimport connectToDatabase from "./settings/database/dbConnection.mjs";\nconnectToDatabase(app);\n' app.mjs
else
    echo -e "\nNenhum banco adicionado..."

fi

else
    # Configurações de servidor (app.js) - CommonJS
    cat <<EOF > app.js
// Importando módulos
const express = require("express");
const cors = require("cors");
const dotenv = require("dotenv");
// Outros módulos...

// Configuração de dependências
const app = express();
app.use(cors())
dotenv.config();

// Config. dados json e formulários
app.use(express.json());
app.use(express.urlencoded({extended: true}));

// Configuração de rotas
    const router = require("./routes/Router.js");
    app.use(router);

// Conectando ao servidor
const PORT = process.env.PORT;
app.listen(PORT, () => {
    console.log("Conectado ao servidor na porta", PORT);
});
EOF

#Configuração inicial de rotas (CommonJs)
cd routes
cat <<EOF > Router.js

//Importando módulos
const express = require("express");
const router = express.Router();

//Controllers
    // ...

//Rota de teste
router.get("/", (req, res) => {
    res.send("Rota principal rodando...");
})

//Outras rotas
    //...

//Exportando router
module.exports = router;
EOF

#Configuração de banco de dados MongoDB
if [ "$db_choice" = "1" ]; then

    echo -e "\nInstalando dependências do MongoDB..."

    #Instalação de biblioteca
    npm i mongoose

#Configuração do arquivo
echo -e "\nConfigurando código base do Mongo, aguarde..."

cd ../settings/database || exit
cat << EOF > dbConnection.js
//Config do banco de dados

const mongoose = require("mongoose");

const dbConnection = async (app) => {
    try{
        //mongoose.connect(<url de conxão aqui>);
        //console.log("Conectado ao mongoose...");
    }
    catch(error){
        console.log(error)
    }
}

module.exports = dbConnection;

EOF

# Volta para src
    cd ../../

    # Insere o import e chamada da função no app.mjs
    sed -i '/dotenv.config();/a\\nconst connectToDatabase = require("./settings/database/dbConnection.js");\nconnectToDatabase(app);\n' app.js

else
    echo -e "\nNenhum banco adicionado..."

fi


fi


