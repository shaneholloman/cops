# TODO

- [ ] consider if it's best to leave the repo as it or set it as a template in GitHub
- [ ] renaming the main entry stript to `cops.sh`
- [ ] add git checkout hooks to lint and `analyze-scripts.sh` before commit to cops project, not the user's config!
- [ ] consider an `mcp` module to in mcp servers and clients
- [ ] add `llm` setup module: see: [llm](./../.ideas/llm-setup.txt) Simon Willison's amazing llm system!
- [ ] add softwareupdate and brew update to a new update module
- [ ] can we use terminal to install from the apple store?
- [ ] can we login to the apple store via terminal?
- [ ] php follow up

    ```sh To enable PHP in Apache add the following to httpd.conf and restart Apache:
    LoadModule php_module /opt/homebrew/opt/php/lib/httpd/modules/libphp.so
    <FilesMatch \.php$>
        SetHandler application/x-httpd-php
    </FilesMatch>

    Finally, check DirectoryIndex includes index.php
        DirectoryIndex index.php index.html
    The php.ini and php-fpm.ini file can be found in:
        /opt/homebrew/etc/php/8.4/
    To start php now and restart at login:
      brew services start php
    Or, if you don't want/need a background service you can just run:
      /opt/homebrew/opt/php/sbin/php-fpm --nodaemonize
  ```

Future, not implemented yet.

- [ ] brew services, example: `brew services start php` possibly a separate services and cron module/s
- [x] keep a the single config file for all the functions
- [x] break out functions to separate files from the main script
- [ ] consider using gnu stow for cops - likely not needed though
- [ ] add namespace support for k8s functions
- [ ] add machine name function
- [ ] add a method to import some custom profile functions.
- [X] add module for aliases
- [ ] add ollama functions to pull a vision and an instruct model - careful when testing this via GitHub workflows.
    - [ ] we need a minimal config for this and other large apps
- [ ] add Claude desktop MCP function to build config based on the volta set path of node, npx etc
- [ ] add a function to pull the latest version of the cops - need to consider how to not overwrite the user's config when pulling from upstream source (shaneholloman/cops)
- [ ] add defaults apps module
    - [ ] add a function to set default browser - defaulted to firefox
    - [ ] add a function to set default editor - defaulted to vscode
    - [ ] add a function to set default terminal - defaulted to iterm2
- [ ] add function to automatically agree to xcode license
- [ ] add function to run intune script to install company monitoring apps etc
- [ ] add a function to ssh-keygen and add to ssh-agent and ssh config defaults - defaulted to ed25519
- [ ] have a look at how mac handle SSL certs
- [ ] have a look at how mac handles SSL in regards to not using openssl, but rather uses libressl, we already add openssl, but some may not want to use it.
- [ ] add new vscode module
    - [ ] add a function to install some vscode extensions
    - [ ] add a function to install some vscode settings
    - [ ] add a function to install some vscode keybindings
    - [ ] add a function to install some vscode snippets
    - [ ] add a function to install some vscode themes
    - [ ] add a function to install some vscode icons
- [ ] add python (uv) module - yes `uv` is opinionated, but this is the way!
    - [ ] add function to add some python tools globally via `uv tool install` module must run only after brew installs example: `uv tool install mlx-whisper --python 3.12`
- [ ] add function to add some node tools globally via `volta install` module must run only after brew installs
- [ ] add module to manage relevant env vars for aws, etc etc
- [ ] add networking module
    - [ ] add function to setup vpn
    - [ ] add function to setup proxy
    - [ ] add function to setup dns
    - [ ] add function to setup firewall
- [ ] add domain join module
    - [ ] add function to join domain
    - [ ] add function to leave domain
    - [ ] could be left-to / handled-by intune
