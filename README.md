# setup-node-init

> 🛠️ Script automatizado para inicializar rapidamente uma estrutura base de projeto Node.js.

Este pacote cria uma estrutura inicial para projetos backend com Node.js, incluindo criação de diretórios, inicialização do `package.json` e instalação de dependências padrão.

---

## 📦 Instalação

- Você pode executar diretamente com `npx` (não precisa instalar globalmente):

```bash
npx @_lucaspaul0_/setup-node-init

```
---
- Se preferir instalar globalmente:

```bash
npm install -g @_lucaspaul0_/setup-node-init
setup-node

```

--- 
### O que é criado:

- 📁 src/
- ├── 📁 controllers/
- ├── 📁 models/
- ├── 📁 routes/
- ├── 📁 middlewares/
- ├── 📁 views/ `(Caso escolha configurar)`
- - ├── 📁 layouts/📄 main.handlebars
- - ├── 📁 pages/📄 home.handlebars
- ├── 📁 config/
- └── app.js
- 📄 package.json
- 📄 .env
- 📄 .gitignore

---

### Também instala automaticamente pacotes essenciais como:

``express``
``dotenv``
``nodemon``
``cors``
``mongoose (opcional)``
``entre outros``

---

### 🧠 Por que usar?
- ✅ Evita trabalho repetitivo
- ✅ Rápido e direto ao ponto
- ✅ Ideal para prototipação ou projetos pequenos/médios
- ✅ Configura view engines (caso escolha).

---
## 👨‍💻 Autor
- > `Lucas Paulo`
- > `GitHub: @LucasPaulo001`
- > `Pacote NPM: @lucaspaul0/setup-node-init`
