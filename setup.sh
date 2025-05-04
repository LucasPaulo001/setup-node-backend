#!/bin/bash

# Criando diretórios
mkdir -p backend/src/{routes,models,middlewares,controllers,settings/database}

cd backend

# Configurando o .gitignore
cat <<EOF > .gitignore
node_modules
.env
EOF

# Criando o .env
cat <<EOF > .env
PORT=8080
EOF

# Configuração do npm
echo "Deseja rodar 'npm init' (interativo) ou 'npm init -y' (padrão)?"
echo "1) npm init"
echo "2) npm init -y"
read -p "Escolha [1/2]: " init_choice

if [ "$init_choice" = "1" ]; then
    npm init
else 
    npm init -y
    # O padrão será CommonJS, então não adicionamos a chave "type" no package.json
    echo "Mantido como CommonJS (sem 'type: module')"
fi

# Tipo de módulo - Só pergunta se não for 'npm init -y'
if [ "$init_choice" = "1" ]; then
    echo "Deseja o ESmodules (type: module) ou o CommonJs (padrão)?"
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

# Configurações de servidor (app.js) - ESmodules
if [ "$init_choice" = "1" ] && [ "$module_choice" = "1" ]; then
    cd src
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

// Conexão do banco de dados
    //...

// Configuração de rotas
   import router from "./routes/Router.mjs";
   app.use(router);

// Conectando ao servidor
const PORT = process.env.PORT
app.listen(PORT, () => {
    console.log("Conectado ao servidor na porta", PORT);
})
EOF

#Configuração inicial de rotas
cd routes
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

# Criando arquivos base
cd ..
cd settings/database
cat << EOF > dbConnection.mjs
//Configuração de conexão com o banco de dados aqui...
EOF

#Voltando para a raiz do projeto
    cd ..
    cd ..
    cd ..
else
    # Configurações de servidor (app.js) - CommonJS
    cd src
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

// Conexão do banco de dados
    //...

// Configuração de rotas
    const router = require("./routes/Router.js");
    app.use(router);

// Conectando ao servidor
const PORT = process.env.PORT;
app.listen(PORT, () => {
    console.log("Conectado ao servidor na porta", PORT);
});
EOF

#Configuração inicial de rotas
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

# Criando arquivos base
cd ..
cd settings/database
cat << EOF > dbConnection.js
//Configuração de conexão com o banco de dados aqui...
EOF

#Voltando para a raiz do projeto
    cd ..
    cd ..
    cd ..
    echo "Mantido como CommonJs (sem 'type: module')"
fi

# Instalando as dependências bases
npm i express cors dotenv
npm i nodemon --save-dev

echo -e "\n--------Projeto base criado com sucesso!--------\n"
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
