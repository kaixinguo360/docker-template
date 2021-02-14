
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

# Set Default Stack Name
if [ -n "$PROFILE" ]; then
    export DEPLOY_STACK_NAME="$(basename $(realpath $(pwd)))-$PROFILE"
else
    export DEPLOY_STACK_NAME="$(basename $(realpath $(pwd)))"
fi

# Load Profile
set -o allexport
[ -z "$PROFILE" -a -f ./deploy.env ] && . ./deploy.env
[ -n "$PROFILE" -a -f "./deploy-$PROFILE.env" ] && . "./deploy-$PROFILE.env"
set +o allexport

