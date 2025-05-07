#!/bin/bash

#Estrutura de pastas
echo -e "Nome da pasta (ENTER para manter como API): " 
read package

if [ "$package" = "" ]; then
    package="API"
    mkdir -p "$package"/src/{routes,models,middlewares,controllers,settings/database}

else
    mkdir -p "$package"/src/{routes,models,middlewares,controllers,settings/database}
fi

cd $package || exit

# Configurando o .gitignore
cat <<EOF > .gitignore
node_modules
.env
EOF

# Criando o .env
cat <<EOF > .env
PORT=8080
EOF

ls

# Configuração do npm
echo "Deseja rodar 'npm init' (interativo) ou 'npm init -y' (padrão)?"
echo "1) npm init"
echo -e "2) npm init -y\n"
read -p "Escolha [1/2]: " init_choice

if [ "$init_choice" = "1" ]; then
    npm init
else 
    npm init -y
fi

# Tipo de módulo
if [ "$init_choice" = "1" ]; then
    echo "[Revisão de módulo]: Deseja o ESmodules (type: module) ou o CommonJs (padrão)?"
    echo "1) ESmodules"
    echo -e "2) CommonJs\n"
    read -p "Escolha [1/2]: " module_choice

    if [ -f "package.json" ]; then
        if [ "$module_choice" = "1" ]; then
            if command -v jq &> /dev/null; then
                tmpfile=$(mktemp)
                jq '. + { "type": "module" }' package.json > "$tmpfile" && mv "$tmpfile" package.json
                echo "type: module adicionado ao package.json"
            else
                sed -i '/"main":/a\  "type": "module",' package.json
                echo "type: module adicionado ao package.json"
            fi
        elif [ "$module_choice" = "2" ]; then
            sed -i '/"type": "module"/d' package.json
            echo "type: module removido do package.json. Mantido como CommonJS."
        fi
    fi
fi

# Configuração de engine
echo -e "\nEscolha a engine: "
echo "1) Handlebars"
echo -e "2) Nenhuma\n"
read -p "Escolha [1/2]: " engine_choice

if [ "$engine_choice" = "1" ]; then
    echo -e "\nMontando estrutura da Engine..."
    cd src || exit
    mkdir -p views/{layouts,pages}

    echo -e "\n------ESTRUTURA MONTADA COM SUCESSO!------"
    cat <<EOF > views/pages/home.handlebars
<h1>Olá, Mundo!</h1>
EOF

    cat << EOF > views/layouts/main.handlebars
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Projeto Node</title>
</head>
<body>
    {{{body}}}
</body>
</html>
EOF

    echo -e "\nInstalando dependências (Handlebars)..."
    npm i express-handlebars
    echo -e "\n------INSTALAÇÃO FEITA COM SUCESSO!------"
    cd ..
else
    echo -e "\nNenhuma engine adicionada!"
fi

# Configuração de banco de dados
echo -e "\nEscolha o banco de dados:"
echo "1) MongoDB"
echo -e "2) Nenhum\n"
read -p "Escolha [1/2]: " db_choice

if [ "$init_choice" = "1" ] && [ "$module_choice" = "1" ]; then
cd src || exit
    # ESModules
    cat <<EOF > app.mjs
// Importando módulos
import express from "express";
import cors from "cors";
import dotenv from "dotenv";

//Config. dependências
const app = express();
app.use(cors());
dotenv.config();

//Config. dados json e formulário
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

//Rota
import router from "./routes/Router.mjs";
app.use(router);

//Conectando ao servidor
const PORT = process.env.PORT;
app.listen(PORT, () => {
    console.log("Conectado ao servidor na porta", PORT);
});
EOF

    if [ "$engine_choice" = "1" ]; then
        sed -i '/dotenv.config();/r /dev/stdin' app.mjs <<'EOF'
// Configuração de engine
import { engine } from "express-handlebars";
app.engine("handlebars", engine());
app.set("view engine", "handlebars");
app.set("views", "./src/views");

app.get('/', (req, res) => {
    res.render('pages/home');
});
EOF
    fi

    # Rotas ESModules
    cat <<EOF > routes/Router.mjs
import express from "express";
const router = express.Router();

router.get("/", (req, res) => {
    res.send("Rota principal rodando...");
});

export default router;
EOF

    if [ "$db_choice" = "1" ]; then
        echo -e "\nInstalando dependências do MongoDB..."
        npm i mongoose

        echo -e "\nConfigurando código base do Mongo..."
        cat << EOF > settings/database/dbConnection.mjs
import mongoose from "mongoose";

const dbConnection = async (app) => {
    try {
        // mongoose.connect(<url de conexão>);
        // console.log("Conectado ao mongoose...");
    } catch (error) {
        console.log(error);
    }
};

export default dbConnection;
EOF

        sed -i '/dotenv.config();/a\
\n// Configuração de banco de dados\nimport connectToDatabase from "./settings/database/dbConnection.mjs";\nconnectToDatabase(app);' app.mjs
        echo -e "\n------CONFIGURAÇÃO FINALIZADA------"
    else
        echo -e "\nNenhum banco adicionado..."
    fi
else
    # CommonJS
    cd src || exit

    cat <<EOF > app.js
//Importando dependências
const express = require("express");
const cors = require("cors");
const dotenv = require("dotenv");

//Config. dependências
const app = express();
app.use(cors());
dotenv.config();

//Config. dados json e formulário
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

//Rota
const router = require("./routes/Router.js");
app.use(router);

//Conectando ao servidor
const PORT = process.env.PORT;
app.listen(PORT, () => {
    console.log("Conectado ao servidor na porta", PORT);
});
EOF

    if [ "$engine_choice" = "1" ]; then
        sed -i '/dotenv.config();/r /dev/stdin' app.js <<'EOF'
// Configuração de engine
const { engine } = require("express-handlebars");
app.engine("handlebars", engine());
app.set("view engine", "handlebars");
app.set("views", "./src/views");

app.get('/', (req, res) => {
    res.render('pages/home');
});
EOF
    fi

    cat <<EOF > routes/Router.js
const express = require("express");
const router = express.Router();

router.get("/", (req, res) => {
    res.send("Rota principal rodando...");
});

module.exports = router;
EOF

    if [ "$db_choice" = "1" ]; then
        echo -e "\nInstalando dependências do MongoDB..."
        npm i mongoose

        echo -e "\nConfigurando código base do Mongo..."
        cat << EOF > settings/database/dbConnection.js
const mongoose = require("mongoose");

const dbConnection = async (app) => {
    try {
        // mongoose.connect(<url de conexão>);
        // console.log("Conectado ao mongoose...");
    } catch (error) {
        console.log(error);
    }
};

module.exports = dbConnection;
EOF

        sed -i '/dotenv.config();/a\
\n// Configuração de banco de dados\nconst connectToDatabase = require("./settings/database/dbConnection.js");\nconnectToDatabase(app);' app.js
        echo -e "\n------CONFIGURAÇÃO FINALIZADA------"
    else
        echo -e "\nNenhum banco adicionado..."
    fi
fi


echo "Instalando dependências base..."
npm install express dotenv cors
npm install nodemon --save-dev

ls
cd ..

#Iniciando servidor e acessando a página
if [ "$module_choice" = "1" ]; then
node src/app.mjs & 

else 
node src/app.js &

fi

sleep 2

# Abrir navegador de forma multiplataforma

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    xdg-open http://localhost:8080/
elif [[ "$OSTYPE" == "darwin"* ]]; then
    open http://localhost:8080/
elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
    start http://localhost:8080/
fi

wait
