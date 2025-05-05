#!/bin/bash

#Caminhos absolutos
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

#Caminho para a base do projeto
BASE_DIR="$SCRIPT_DIR/base"

#Caminho para as configurações de db
DB_DIR="$SCRIPT_DIR/db"

#Criando estrutura
bash "$BASE_DIR/createStructure.sh"

#Iniciando npm
bash "$BASE_DIR/initNPM.sh"

#Instalação de de pendências
bash "$BASE_DIR/installDeps.sh"
   

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
