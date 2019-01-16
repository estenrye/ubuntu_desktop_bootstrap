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
    -v|--buildNumber)
    BUILD_BUILDNUMBER="$2"
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

if [ ! -f "$JQ" ]; then
    if [ "$(uname -s)" != 'Linux' ]; then
        curl -L https://github.com/stedolan/jq/releases/download/jq-1.6/jq-win64.exe -o "$JQ"
    else
        curl -L https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 -o "$JQ"
    fi
fi

boxfile=$(cat manifest.json | $JQ --raw-output ".builds[] | select(.artifact_id | contains(\"$VAGRANT_PROVIDER_TYPE\")) | .files[0].name")

python $AWSCLI s3 cp "$IMAGES/$boxfile" "s3://vagrant-cloud/$VAGRANT_BOX_NAME/$VAGRANT_PROVIDER_TYPE-$BUILD_BUILDNUMBER.box" --endpoint-url=https://s3.wasabisys.com --profile wasabi