BIN="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." >/dev/null 2>&1 && pwd )"
JQ="${BIN}/bin/jq.exe"
IMAGES="${BIN}/images"
AWSCLI="$(pip show awscli | grep Location | sed 's/Location: //')/awscli"

POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -b|--boxName)
    VAGRANT_BOX_NAME="$2"
    shift # past argument
    shift # past value
    ;;
    -v|--vagrantBoxVersion)
    VAGRANT_BOX_VERSION="$2"
    shift # past argument
    shift # past value
    ;;
    -p|--providerType)
    VAGRANT_PROVIDER_TYPE="$2"
    shift # past argument
    shift # past value
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

if [ "$(uname -s)" != 'Linux' ]; then
  CURL='/usr/bin/curl'
else
  CURL='/c/Program\ Files/Git/mingw64/bin/curl.exe'
fi

if [ ! -f "$JQ" ]; then
    if [ "$(uname -s)" != 'Linux' ]; then
        $CURL -L https://github.com/stedolan/jq/releases/download/jq-1.6/jq-win64.exe -o "$JQ"
    else
        $CURL -L https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 -o "$JQ"
    fi
fi

boxfile=$(cat manifest.json | $JQ --raw-output ".builds[] | select(.artifact_id | contains(\"$VAGRANT_PROVIDER_TYPE\")) | .files[0].name")

python $AWSCLI s3 cp "$IMAGES/$boxfile" "s3://vagrant-cloud/$VAGRANT_BOX_NAME/$VAGRANT_PROVIDER_TYPE-$VAGRANT_BOX_VERSION.box" --endpoint-url=https://s3.wasabisys.com --profile wasabi