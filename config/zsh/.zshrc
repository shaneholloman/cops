# Path extensions
export PATH="/Users/shaneholloman/.dotfiles/bin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

# Oh My Posh configuration
eval "$(oh-my-posh init zsh --config ~/Dropbox/shane/conf/warpdeck.omp.json)"

# Environment variables
export AWS_CONFIG_FILE="null"
export null="$HOME/.aws/config"
export AWS_SHARED_CREDENTIALS_FILE="null"
export null="$HOME/.aws/credentials"
export KUBECONFIG="null"
export null="$HOME/.kube/config"
export TERRAFORM_CONFIG="null"
export null="$HOME/.terraform.d/config.tfrc"

# Load aliases
source ~/.dotfiles/config/zsh/.aliases
