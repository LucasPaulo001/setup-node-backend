#!/bin/bash

#Caminhos absolutos
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

#Caminho para a base do projeto
BASE_DIR="$SCRIPT_DIR/base"

#Criando estrutura
bash <(curl -s https://raw.githubusercontent.com/LucasPaulo001/setup-node-backend/devShell_plusConfig/scripts/base/createStructure.sh)

#Iniciando npm
bash <(curl -s https://raw.githubusercontent.com/LucasPaulo001/setup-node-backend/devShell_plusConfig/scripts/base/initNPM.sh)


#Instalação de de pendências
bash <(curl -s https://raw.githubusercontent.com/LucasPaulo001/setup-node-backend/devShell_plusConfig/scripts/base/installDeps.sh)

   

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
