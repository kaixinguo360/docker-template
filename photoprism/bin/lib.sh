
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
[ -n "$1" ] && PROFILE="$1" && shift
set -o allexport
[ -z "$PROFILE" -a -f ./deploy.env ] && . ./deploy.env
[ -n "$PROFILE" -a -f "./deploy-$PROFILE.env" ] && . "./deploy-$PROFILE.env"
set +o allexport

