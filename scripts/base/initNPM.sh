#!/bin/bash

RESET="\033[0m"

RED="\033[0;32m"
GREEN="\033[0;32m"
YELLOW='\033[0;33m'

#Estrutura de pastas
echo -e "Nome da pasta (ENTER para manter como API): " 
read package

if [ "$package" = "" ]; then
    package="API"

    mkdir -p "$package"/public/{pages,styles} "$package"/src/{routes,models,middlewares,controllers} "$package"/src/settings/database

else
    mkdir -p "$package"/public/{pages,styles} "$package"/src/{routes,models,middlewares,controllers} "$package"/src/settings/database

fi

#Criando html na pasta public/pages
cd $package/public/pages || exit

cat <<EOF > setup.html 
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Setup-Node</title>
    <link rel="stylesheet" href="../styles/style.css">
</head>
<body>
    <section id="apresentation">
        <a target="_blank" href="https://github.com/LucasPaulo001/setup-node-backend">
            <h1>Setup-Node</h1>
        </a>
    </section>
</body>
</html>

EOF

#Voltando um diretório e entrando na pasta styles
cd ..
cd styles || exit

#Criando arquivo css
cat <<EOF > style.css 
*{
    padding: 0;
    margin: 0;
    box-sizing: border-box;
    font-family: Arial, Helvetica, sans-serif;
}

body{
    background-color: #0F172A;
    color: #F8FAFC;
}

#apresentation{
    height: 100vh;
    display: flex;
    align-items: center;
    justify-content: center;
}

#apresentation a{
    text-decoration: none;
    color: #F8FAFC;
}

#apresentation a h1{
    padding: 2vw;
    background-color: #9146FF;
    border-radius: 10px;
    animation: animationTitle infinite 2s ease-in-out;
}

#apresentation a h1:hover{
    animation: animationTitle infinite .4s ease-in-out;
    cursor: pointer;
}

@keyframes animationTitle {
    0%{
        box-shadow: 4px 4px 10px 3px;
    }
    50%{
        box-shadow: 4px 4px 10px 10px;
    }
    100%{
        box-shadow: 4px 4px 10px 3px;
    }
}

EOF

#Voltando três diretórios /styles > /public > /pasta raiz do projeto
cd ..
cd ..
cd ..

#Entrando no diretório raiz
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
    echo -e "\n${YELLOW}Montando estrutura da Engine...${RESET}"
    cd src || exit
    mkdir -p views/{layouts,pages}

    echo -e "\n${GREEN}------ESTRUTURA MONTADA COM SUCESSO!------${RESET}"
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

    echo -e "\n${YELLOW}Instalando dependências (Handlebars)...${RESET}"
    npm i express-handlebars
    echo -e "\n${GREEN}------INSTALAÇÃO FEITA COM SUCESSO!------${RESET}"
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
import path from 'path';
import { fileURLToPath } from 'url';
import dotenv from "dotenv";

//Config. dependências
const app = express();
app.use(cors());
dotenv.config();

// Emular __dirname
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Caminho para a pasta onde está os arquivos .html
const publicPath = path.join(__dirname, '../public');

// Servir arquivos estáticos (CSS, JS, imagens)
app.use(express.static(publicPath));

//Config. dados json e formulário
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Servir arquivos estáticos da pasta 'public'
app.use(express.static(path.join(__dirname, 'public')));

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

//Rota principal com handlebars
//app.get('/', (req, res) => {
//res.render('pages/home');
//});
EOF
    fi

    # Rotas ESModules
    cat <<EOF > routes/Router.mjs
import express from "express";
import path from 'path';
import { fileURLToPath } from 'url';
const router = express.Router();

// Emular __dirname para este arquivo
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Caminho até o index.html
const htmlPath = path.join(__dirname, '../../public/pages/setup.html');

router.get('/', (req, res) => {
  res.sendFile(htmlPath);
});

export default router;
EOF

    if [ "$db_choice" = "1" ]; then
        echo -e "\n${YELLOW}Instalando dependências do MongoDB...${RESET}"
        npm i mongoose

        echo -e "\n${YELLOW}Configurando código base do Mongo...${RESET}"
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
        echo -e "\n${GREEN}------CONFIGURAÇÃO FINALIZADA------${RESET}"
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
const path = require("path");

//Config. dependências
const app = express();
app.use(cors());
dotenv.config();

//Config. dados json e formulário
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Servir arquivos estáticos da pasta 'public'
app.use(express.static(path.join(__dirname, '../public')));

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

//Rota principal com handlebars
//app.get('/', (req, res) => {
//    res.render('pages/home');
//});
EOF
    fi

    cat <<EOF > routes/Router.js
const express = require("express");
const router = express.Router();
const path = require("path");

router.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, '../../public', '/pages/setup.html'));
});

module.exports = router;
EOF

    if [ "$db_choice" = "1" ]; then
        echo -e "\n${YELLOW}Instalando dependências do MongoDB...${RESET}"
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
        echo -e "\n${GREEN}------CONFIGURAÇÃO FINALIZADA------${RESET}"
    else
        echo -e "\nNenhum banco adicionado..."
    fi
fi


echo -e "${YELLOW}Instalando dependências base...${RESET}"
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

#Abrir navegador de forma multiplataforma

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    xdg-open http://localhost:8080/
elif [[ "$OSTYPE" == "darwin"* ]]; then
    open http://localhost:8080/
elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
    start http://localhost:8080/
else
    echo "Sistema operacional não suportado para abrir o navegador automaticamente."
fi

wait
