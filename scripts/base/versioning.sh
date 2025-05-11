#!/bin/bash

RESET="\033[0m"

RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW='\033[0;33m'
CYAN='\033[1;36m'

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