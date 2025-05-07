#!/bin/bash

#Estrutura de pastas
echo -e "Nome da pasta (ENTER para manter como API): " 
read package

if [ "$package" = "" ]; then
    package="API"
    mkdir -p $package/src/{routes,models,middlewares,controllers,settings/database}

else
    mkdir -p $package/src/{routes,models,middlewares,controllers,settings/database}
fi
export package
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

