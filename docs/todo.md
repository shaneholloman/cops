# TODO

- [ ]  add LLM setup: see: [llm](./../.ideas/llm-setup.txt)

- [ ]  php follow up

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

- [x] keep a the single config file for all the functions
- [x] break out functions to separate files from the main script
- [ ] consider using gnu stow for cops
- [ ] add namespace support for k8s functions
- [ ] add machine name function
- [ ] add a method to import some custom profile functions/aliases
- [ ] add ollama functions to pull a vision and an instruct model
- [ ] add Claude desktop MCP function to build config based on the volta set path of node, npx etc
- [ ] add a function to pull the latest version of the cops
- [ ] add a function to set default browser - defaulted to firefox
- [ ] add a function to set default editor - defaulted to vscode
- [ ] add a function to set default terminal - defaulted to iterm2
- [ ] add a function to ssh-keygen and add to ssh-agent and ssh config defaults
- [ ] add function to automatically agree to xcode license
- [ ] add function to run intune script to install company monitoring apps etc
- [ ] have a look at how mac handle SSL certs
- [ ] have a look at how mac handles SSL in regards to not using openssl, but rather uses libressl
- [ ] add a function to install some sane vscode extensions
- [ ] add a function to install some sane vscode settings
- [ ] add a function to install some sane vscode keybindings
- [ ] add a function to install some sane vscode snippets
- [ ] add a function to install some vscode themes
- [ ] add a function to install some vscode icons
- [ ] add function to add some python tools globally via `uv tool install` module must run only after brew installs
- [ ] add function to add some node tools globally via `volta install` module must run only after brew installs
- [ ] add function to add relevant env vars for aws, etc etc
