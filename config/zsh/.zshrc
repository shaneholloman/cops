# Path extensions
export PATH="$HOME/.local/bin:$HOME/.cops/bin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

# Oh My Posh configuration
eval "$(oh-my-posh init zsh --config ~/Dropbox/shane/conf/warpdeck.omp.json)"

# Environment variables
export AWS_CONFIG_FILE="$HOME/.aws/config"
export AWS_SHARED_CREDENTIALS_FILE="$HOME/.aws/credentials"
export KUBECONFIG="$HOME/.kube/config"
export TERRAFORM_CONFIG="$HOME/.terraform.d/config.tfrc"

# Load aliases
source ~/.cops/config/zsh/.aliases
