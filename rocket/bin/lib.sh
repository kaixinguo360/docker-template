
# Display Help Information
if [ "$1" = "-h" -o "$1" = "--help" ]; then
    printf "Usage: %s [profile]\n" $(basename $0)
    exit 0
fi

# Change Working Directory
cd $(dirname $0)/..

# Get Profile Name
if [ -n "$1" ]; then
    if [ "$1" = "-" ]; then
        PROFILE=
    elif [ -n "$(echo "$1"|grep '^.*deploy.*.env$')" ]; then
        PROFILE=$(printf '%s' "$1"|sed -nE 's/^.*deploy-([a-zA-Z0-9]*)\.env$/\1/p')
    elif [ -n "$(echo "$1"|grep '^.*docker-compose.*.yml$')" ]; then
        PROFILE=$(printf '%s' "$1"|sed -nE 's/^.*docker-compose-([a-zA-Z0-9]*)\.yml$/\1/p')
    else
        PROFILE="$1"
    fi
    shift
fi

# Set Default Stack Name & Profile File
if [ -n "$PROFILE" ]; then
    export DEPLOY_STACK_NAME="$(basename $(realpath $(pwd)))-$PROFILE"
    export DEPLOY_PROFILE_FILE="./deploy-$PROFILE.env"
else
    export DEPLOY_STACK_NAME="$(basename $(realpath $(pwd)))"
    export DEPLOY_PROFILE_FILE="./deploy.env"
fi

# Load Profile
set -o allexport
[ -f "$DEPLOY_PROFILE_FILE" ] && . "$DEPLOY_PROFILE_FILE"
set +o allexport

