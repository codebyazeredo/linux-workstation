# linux-workstation

Provisiona um ambiente de desenvolvimento em **Linux Mint** (ou Ubuntu) com um comando.
Cada grupo de ferramentas é um módulo em `scripts/`, então dá para instalar tudo ou só o que precisar em outra máquina.

## Do zero: passo a passo

### Parte 1 — Instalar o Linux Mint (feito no PC atual, Windows)

> Faça backup dos seus arquivos antes. Você precisa de um pendrive de 8 GB ou mais (será apagado).

1. Baixe a ISO **Linux Mint Cinnamon** (a versão mais recente, 64 bits) em <https://linuxmint.com/download.php>.
2. (Recomendado) Confira a integridade: no PowerShell, rode `Get-FileHash .\linuxmint-*.iso -Algorithm SHA256` e compare com o `sha256sum.txt` da página de download do mirror.
3. Grave a ISO no pendrive com o [Rufus](https://rufus.ie) (esquema **GPT**, modo **ISO**) ou com o [balenaEtcher](https://etcher.balena.io).
4. Com o pendrive conectado, reinicie o PC e abra o menu de boot (geralmente `F12`, `F2`, `Esc` ou `Del`, conforme o fabricante). Escolha o pendrive (`UEFI`).
5. No menu do Mint, escolha **Start Linux Mint**. Você entra num ambiente de teste: confirme que internet, vídeo e som funcionam.
6. Dê duplo clique em **Install Linux Mint** e siga o assistente:
   - Idioma e teclado (ex.: Português do Brasil / ABNT2).
   - Marque **Install multimedia codecs**.
   - Tipo de instalação:
     - **Erase disk and install Linux Mint** — apaga o Windows e usa o disco todo (o caso de trocar de PC/sistema).
     - **Something else** — só se quiser particionar manualmente ou manter o Windows em dual boot.
   - Fuso horário, nome, nome do computador, usuário e senha.
7. Ao terminar, clique em **Restart Now**, remova o pendrive quando pedir e dê Enter.

### Parte 2 — Preparar o sistema (primeiro boot do Mint)

1. Conclua o **Welcome Screen** (se aparecer) e conecte-se à internet.
2. Atualize tudo pela interface: **Menu → Update Manager → Install Updates**. Reinicie se solicitado.
3. Instale os drivers (principalmente NVIDIA/Wi-Fi): **Menu → Driver Manager**. Reinicie se instalar algo.
4. Configure o **Timeshift** (aberto pelo Welcome Screen ou pelo Menu) e crie o primeiro snapshot. Assim você consegue voltar atrás se algo der errado.
5. Abra o terminal (`Ctrl+Alt+T`) e atualize os pacotes:

   ```bash
   sudo apt update && sudo apt upgrade -y
   ```

### Parte 3 — Instalar o ambiente de desenvolvimento

1. Instale Git e curl:

   ```bash
   sudo apt install -y git curl
   ```

2. Baixe o projeto (sem GitHub, copie a pasta por pendrive e entre nela com `cd`):

   ```bash
   git clone https://github.com/SEU_USUARIO/linux-workstation.git
   cd linux-workstation
   ```

3. Dê permissão e rode (pede confirmação `s` e a senha de sudo):

   ```bash
   chmod +x install.sh
   ./install.sh
   ```

   Para já configurar a identidade do Git na mesma execução:

   ```bash
   GIT_NAME="codebyazeredo" GIT_EMAIL="matheus.azeredo.pro@gmail.com" ./install.sh
   ```

   O `./install.sh` sem argumentos instala todos os módulos, incluindo o **mise** (repositório oficial, ativado no `~/.bashrc`) e o **Go** por meio dele.
   Para instalar só o mise e o Go: `./install.sh --mise --golang`.

4. **Faça logout/login.** Isso ativa o grupo `docker` e carrega o PATH de `mise`, `pipx` e `claude`.

5. Confira o resultado:

   ```bash
   cd linux-workstation
   ./install.sh --check
   ```

Se algo falhar no meio, rode `./install.sh` de novo: o que já foi instalado é ignorado.
O log fica em `~/.local/state/linux-workstation/install.log`.

### Parte 4 — Depois de instalar

- Autentique o Claude Code: rode `claude` e siga o login.
- Gere sua chave SSH para o GitHub: `ssh-keygen -t ed25519 -C "voce@email.com"` e cadastre `~/.ssh/id_ed25519.pub` em GitHub → Settings → SSH keys.
- Confirme o mise e use-o para outras ferramentas:

  ```bash
  mise --version
  mise ls                  # versões instaladas (Go já vem do instalador)
  mise use --global node@lts   # exemplo: instalar o Node
  ```

- Crie outro snapshot no Timeshift com o ambiente pronto.
- Para manter tudo atualizado no dia a dia: `sudo apt update && sudo apt upgrade -y` (ou o Update Manager) e `mise upgrade` para as versões gerenciadas pelo mise.

## Uso

```bash
./install.sh                     # tudo (pede confirmação)
./install.sh --yes               # tudo, sem confirmação
./install.sh --base --git        # só alguns módulos
./install.sh --php --composer    # ambiente PHP
./install.sh --docker --vscode
./install.sh --check             # mostra o que já está instalado
./install.sh --list              # lista os módulos
```

Os módulos sempre rodam na ordem correta, independentemente da ordem dos argumentos.
É seguro rodar mais de uma vez: o que já está instalado é ignorado.

## Módulos

| Módulo     | O que instala                                   | Origem                          |
| ---------- | ----------------------------------------------- | ------------------------------- |
| `base`     | curl, wget, build-essential, jq, ripgrep, htop… | APT                             |
| `git`      | Git + `init.defaultBranch main`                 | APT                             |
| `docker`   | Engine, CLI, Buildx, Compose plugin             | Repositório oficial Docker      |
| `vscode`   | Visual Studio Code                              | Repositório oficial Microsoft   |
| `browsers` | Google Chrome e Brave                           | Repositórios oficiais           |
| `php`      | PHP 8.3 + extensões comuns                      | APT (PPA ondrej se necessário)  |
| `composer` | Composer (hash do instalador validado)          | Instalador oficial              |
| `python`   | python3, pip, venv, pipx                        | APT                             |
| `mise`     | Gerenciador de versões (ativado no `.bashrc`)   | Repositório oficial mise        |
| `golang`   | Go (via mise)                                   | mise                            |
| `claude`   | Claude Code                                     | Instalador nativo oficial       |

## Configuração

- Versões: [config/versions.conf](config/versions.conf) (`PHP_VERSION`, `GO_VERSION`).
- Identidade do Git (opcional):

  ```bash
  GIT_NAME="codebyazeredo" GIT_EMAIL="matheus.azeredo.pro@gmail.com" ./install.sh --git
  ```

- Log de cada execução: `~/.local/state/linux-workstation/install.log`.

## Bancos de dados (sob demanda)

MySQL e SurrealDB **não** são instalados no sistema; rodam em containers só quando necessário, sem consumir RAM o tempo todo.

```bash
cd docker/mysql
cp .env.example .env     # edite a senha; o .env não vai para o Git
docker compose up -d
docker compose down      # para quando terminar (os dados ficam no volume)
```

O mesmo vale para `docker/surrealdb`. As portas ficam acessíveis só em `127.0.0.1` (MySQL 3306, SurrealDB 8000).

## Segurança

- Nenhuma senha ou token é guardado no repositório (`.env` está no `.gitignore`).
- Repositórios APT usam chaves em `/etc/apt/keyrings` com `signed-by`.
- O Composer valida o hash antes de executar. O módulo `claude` usa o `curl | bash` oficial da Anthropic; revise `scripts/claude.sh` se quiser.

## Adicionar uma ferramenta

1. Crie `scripts/<nome>.sh` com a função `install_<nome>`.
2. Adicione `<nome>` em `MODULES` no `install.sh` (na posição das dependências).
