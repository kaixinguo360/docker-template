
# Display Help Information
if [ "$1" = "-h" -o "$1" = "--help" ]; then
    printf "Usage: %s [profile]\n" $(basename $0)
    exit 0
fi

# Change Working Directory
cd $(dirname $0)/..

# Get Default Stack Name
export DEPLOY_STACK_NAME="$(basename $(realpath $(pwd)))"

# Load Profile
set -o allexport
[ -z "$1" -a -f ./deploy.env ] && . ./deploy.env
[ -n "$1" ] && . "./deploy-$1.env"
set +o allexport

