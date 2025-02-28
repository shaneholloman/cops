# Cops Java Setup

```sh
  langgraph-mcp 3.13.2 󰎙 22.14.0  shaneholloman @ bird.yoyo.io  rfp-assistant-project  main   java -version
The operation couldn’t be completed. Unable to locate a Java Runtime.
Please visit http://www.java.com for information on installing Java.

  langgraph-mcp 3.13.2 󰎙 22.14.0  shaneholloman @ bird.yoyo.io  rfp-assistant-project  main   brew --version
Homebrew 4.4.22
  langgraph-mcp 3.13.2 󰎙 22.14.0  shaneholloman @ bird.yoyo.io  rfp-assistant-project  main  brew install openjdk
==> Downloading https://formulae.brew.sh/api/formula.jws.json
==> Downloading https://formulae.brew.sh/api/cask.jws.json
==> Downloading https://ghcr.io/v2/homebrew/core/openjdk/manifests/23.0.2
###################################################################################################################################################################################### 100.0%
==> Fetching openjdk
==> Downloading https://ghcr.io/v2/homebrew/core/openjdk/blobs/sha256:1285eadf2b5998cda49e4470ee3875e855b0be199765401ad77dc38aea573f49
###################################################################################################################################################################################### 100.0%
==> Pouring openjdk--23.0.2.arm64_sequoia.bottle.tar.gz
==> Caveats
For the system Java wrappers to find this JDK, symlink it with
  sudo ln -sfn /opt/homebrew/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk

openjdk is keg-only, which means it was not symlinked into /opt/homebrew,
because macOS provides similar software and installing this software in
parallel can cause all kinds of trouble.

If you need to have openjdk first in your PATH, run:
  echo 'export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"' >> /Users/shaneholloman/.zshrc

For compilers to find openjdk you may need to set:
  export CPPFLAGS="-I/opt/homebrew/opt/openjdk/include"
==> Summary
🍺  /opt/homebrew/Cellar/openjdk/23.0.2: 602 files, 337.4MB
==> Running `brew cleanup openjdk`...
  langgraph-mcp 3.13.2 󰎙 22.14.0  shaneholloman @ bird.yoyo.io  rfp-assistant-project  main  echo 'export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"' >> ~/.zshrc && echo 'export CPPFLA
GS="-I/opt/homebrew/opt/openjdk/include"' >> ~/.zshrc && source ~/.zshrc
  langgraph-mcp 3.13.2 󰎙 22.14.0  shaneholloman @ bird.yoyo.io  rfp-assistant-project  main  sudo ln -sfn /opt/homebrew/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachine
s/openjdk.jdk
Password:
  langgraph-mcp 3.13.2 󰎙 22.14.0  shaneholloman @ bird.yoyo.io  rfp-assistant-project  main  java -version
openjdk version "23.0.2" 2025-01-21
OpenJDK Runtime Environment Homebrew (build 23.0.2)
OpenJDK 64-Bit Server VM Homebrew (build 23.0.2, mixed mode, sharing)
```
