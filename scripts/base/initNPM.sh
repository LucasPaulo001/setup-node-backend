#!/bin/bash

RESET="\033[0m"

RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW='\033[0;33m'
CYAN='\033[1;36m'

#Estrutura de pastas
echo "Nome da pasta (ENTER para manter como API): " 
read package

if [ "$package" = "" ]; then
    package="API"

    mkdir -p "$package"/public/{pages,styles} \
    "$package"/src/{routes,models,middlewares,controllers} \
    "$package"/src/settings/database

else
    mkdir -p "$package"/public/{pages,styles} "$package"/src/{routes,models,middlewares,controllers} "$package"/src/settings/database

fi

cd $package

cat <<EOF > README.md
# 🚀 Setup-Node

Este é o ponto de partida para um projeto backend em Node.js com Express.

## 🧰 Tecnologias utilizadas

- Node.js
- Express
- Dotenv
- CORS
- Nodemon (desenvolvimento)

EOF


#Criando html na pasta public/pages
cd public/pages || exit

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
#Servidor
PORT=8080

#Banco de dados (Informe seus dados do banco)
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=
DB_NAME=nome_do_banco
DB_PORT=3306
EOF

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
echo -e "Escolha a engine: "
echo "1) Handlebars"
echo -e "2) Nenhuma\n"
read -p "Escolha [1/2]: " engine_choice

if [ "$engine_choice" = "1" ]; then
    echo -e "\n${YELLOW}Montando estrutura da Engine...${RESET}"
    cd src || exit
    mkdir -p views/{layouts,pages,partials}

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
echo "2) MySQL"
echo "3) PostgreSQL"
echo -e "4) Nenhum\n"
read -p "Escolha [1/2/3/4]: " db_choice

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

#Configuração de bando de dados
    if [ "$db_choice" = "1" ]; then
        echo -e "\n${YELLOW}Instalando dependências do MongoDB...${RESET}"

        #Instalando dependências
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

    #MySQL
    elif [ "$db_choice" = "2" ]; then
        echo -e "\n${YELLOW}Instalando dependências do MySQL...${RESET}"

        #Instalando dependências
        npm install mysql2

        echo -e "\n${YELLOW}Configurando código base do mysql2...${RESET}"
        echo -e "\n\n${YELLOW}⚠️ Certifique-se de que o servidor MySQL está em execução antes de continuar.${RESET}"
        echo -e "\n\n${YELLOW}➡️  Preencha os dados de conexão no arquivo .env antes de rodar a aplicação.${RESET}"
        cat << EOF > settings/database/dbConnection.mjs
import mysql from 'mysql2/promise';
import dotenv from 'dotenv'
dotenv.config()

const pool = mysql.createPool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
});

export default pool;
EOF

#Inserindo no arquivo de servidor

sed -i '/dotenv.config();/a \
\n// Configuração de banco de dados\nimport pool from "./settings/database/dbConnection.mjs";\n\
pool.query("SELECT * FROM usuarios")\n\
  .then(([rows]) => console.log(rows))\n\
  .catch(err => console.error(err));\n' app.mjs

        echo -e "\n${GREEN}------CONFIGURAÇÃO FINALIZADA------${RESET}"

    elif [ "$db_choice" =  "3" ]; then
 echo -e "\n${YELLOW}Instalando dependências do PostgreSQL...${RESET}"

        #Instalando dependências
        npm install pg

        echo -e "\n${YELLOW}Configurando código base do pg...${RESET}"
        echo -e "\n\n${YELLOW}➡️  Preencha os dados de conexão no arquivo .env com os dados do banco de dados.${RESET}"
        cat << EOF > settings/database/dbConnection.mjs
import pkg from 'pg';
const { Pool } = pkg;
import dotenv from 'dotenv';
dotenv.config();

const pool = new Pool({
  user: process.env.DB_USER || 'seu_usuario',
  host: process.env.DB_HOST || 'localhost',
  database: process.env.DB_NAME || 'seu_banco',
  password: process.env.DB_PASSWORD || 'sua_senha',
  port: process.env.DB_PORT || 5432,
});

export default pool;

EOF

sed -i '/dotenv.config();/a \
\
// Configuração de banco de dados\nimport pool from "./settings/database/dbConnection.mjs";\n\
pool.query("SELECT NOW()")\n\
  .then(res => {\n\
    console.log("Conectado ao PostgreSQL:", res.rows[0]);\n\
  })\n\
  .catch(err => {\n\
    console.error("Erro ao conectar no PostgreSQL:", err);\n\
  });' app.mjs

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
    
    #MySQL
    elif [ "$db_choice" = "2" ]; then
        echo -e "\n${YELLOW}Instalando dependências do MySQL...${RESET}"

        #Instalando dependências
        npm install mysql2

        echo -e "\n${YELLOW}Configurando código base do mysql2...${RESET}"
        echo -e "\n\n${YELLOW}⚠️ Certifique-se de que o servidor MySQL está em execução antes de continuar.${RESET}"
        echo -e "\n\n${YELLOW}➡️  Preencha os dados de conexão no arquivo .env antes de rodar a aplicação.${RESET}"
        cat << EOF > settings/database/dbConnection.js
const mysql = require('mysql2/promise');
require('dotenv').config();

const pool = mysql.createPool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
});

module.exports = pool;

EOF

sed -i '/dotenv.config();/a \
\n// Configuração de banco de dados\nconst pool = require("./settings/database/dbConnection.js");\n\
pool.query("SELECT * FROM usuarios")\n\
  .then(([rows]) => console.log(rows))\n\
  .catch(err => console.error(err));\n' app.js

    elif [ "$db_choice" =  "3" ]; then
 echo -e "\n${YELLOW}Instalando dependências do PostgreSQL...${RESET}"

        #Instalando dependências
        npm install pg

        echo -e "\n${YELLOW}Configurando código base do pg...${RESET}"
        echo -e "\n\n${YELLOW}➡️  Preencha os dados de conexão no arquivo .env com os dados do banco de dados.${RESET}"
        cat << EOF > settings/database/dbConnection.js
const pkg = require('pg') ;
const { Pool } = pkg;
require('dotenv').config();

const pool = new Pool({
  user: process.env.DB_USER || 'seu_usuario',
  host: process.env.DB_HOST || 'localhost',
  database: process.env.DB_NAME || 'seu_banco',
  password: process.env.DB_PASSWORD || 'sua_senha',
  port: process.env.DB_PORT || 5432,
});

module.exports = pool

EOF

sed -i '/dotenv.config();/a \
\
// Configuração de banco de dados\nconst pool = require("./settings/database/dbConnection.js");\n\
pool.query("SELECT NOW()")\n\
  .then(res => {\n\
    console.log("Conectado ao PostgreSQL:", res.rows[0]);\n\
  })\n\
  .catch(err => {\n\
    console.error("Erro ao conectar no PostgreSQL:", err);\n\
  });' app.js


    else
        echo -e "\nNenhum banco adicionado..."
    fi
fi


echo -e "${YELLOW}Instalando dependências base...${RESET}"
npm install express dotenv cors
npm install nodemon --save-dev

echo -e "\n${CYAN}Deseja subir o projeto para um repositório do GitHub?${RESET} ${YELLOW}*Esteja autenticado no gh auth para prosseguir!${RESET}\n" 
echo "[1]: Sim"
echo -e "[2]: Não\n"
echo "Escolha [1/2]:"
read resp


if [ "$resp" = "1"  ]; then

    if ! gh auth status &>/dev/null; then
        echo -e "${RED} Você não está autenticado no GitHub CLI ${RESET}. ${CYAN}Rodando gh auth login...${RESET}"

        gh auth login

    else

        git init
git add .
git commit -m "first commit"

echo -e "${CYAN}Nome do repositório no GitHub: ${RESET}" 
read repo_name

echo "${CYAN}Deseja que o repositório seja público ou privado?${RESET}\n"
echo "[1]: Público"
echo -e "[2]: Privado\n"
echo "Escolha [1/2]"
read privacity

    if [ "$privacity" = "1" ]; then
        gh repo create "$repo_name" --public --source=. --remote=origin --push

    elif [ "$privacity" = "2" ]; then
        gh repo create "$repo_name" --private --source=. --remote=origin --push

    fi

echo -e "${GREEN}\n Projeto '${repo_name}' enviado para o GitHub com sucesso!!${RESET}"

    fi

else

echo -e "${RED}\nEnvio negado....${RESET}\n"

fi

cd "$package"


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

echo -e "\n${GREEN}------PROJETO CRIADO!------${RESET}\n"
echo -e "\n 
╭━━╮╱╱╱╱╱╭╮╱╱╱╱╱╱╱╱╱╱╱╱╱╱╭━━━╮╱╱╱╱╱╭╮╱╱╱╭━━━┳━━━╮╭╮
┃╭╮┃╱╱╱╱╱┃┃╱╱╱╱╱╱╱╱╱╱╱╱╱╱┃╭━╮┃╱╱╱╱╱┃┃╱╱╱┃╭━╮┃╭━╮┣╯┃
┃╰╯╰┳╮╱╭╮┃┃╱╱╭╮╭┳━━┳━━┳━━┫╰━╯┣━━┳╮╭┫┃╭━━┫┃┃┃┃┃┃┃┣╮┃
┃╭━╮┃┃╱┃┃┃┃╱╭┫┃┃┃╭━┫╭╮┃━━┫╭━━┫╭╮┃┃┃┃┃┃╭╮┃┃┃┃┃┃┃┃┃┃┃
┃╰━╯┃╰━╯┃┃╰━╯┃╰╯┃╰━┫╭╮┣━━┃┃╱╱┃╭╮┃╰╯┃╰┫╰╯┃╰━╯┃╰━╯┣╯╰╮
╰━━━┻━╮╭╯╰━━━┻━━┻━━┻╯╰┻━━┻╯╱╱╰╯╰┻━━┻━┻━━┻━━━┻━━━┻━━╯
╱╱╱╱╭━╯┃
╱╱╱╱╰━━╯
\n"

wait