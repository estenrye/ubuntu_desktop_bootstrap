BIN="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." >/dev/null 2>&1 && pwd )"
JQ="${BIN}/bin/jq.exe"
IMAGES="${BIN}/images"
AWSCLI="$(pip show awscli | grep Location | sed 's/Location: //')/awscli"

if [ -z "$PACKER_BUILDER_TYPE" ]; then
  echo 'PACKER_BUILDER_TYPE is undefined.  using default: hyperv-iso'
  PACKER_BUILDER_TYPE='hyperv-iso'
fi 

echo $BIN
echo $JQ
echo $PACKER_BUILDER_TYPE
echo $AWSCLI

if [ ! -f "$JQ" ]; then
    if [ "$(uname -s)" != 'Linux' ]; then
        curl -L https://github.com/stedolan/jq/releases/download/jq-1.6/jq-win64.exe -o "$JQ"
    else
        curl -L https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 -o "$JQ"
    fi
fi

boxfile=$(cat manifest.json | $JQ --raw-output ".builds[] | select(.name | contains(\"$PACKER_BUILDER_TYPE\")) | .files[0].name")

python $AWSCLI s3 cp "$IMAGES/$boxfile" "s3://vagrant-cloud/ubuntu-desktop/$boxfile" --endpoint-url=https://s3.wasabisys.com --profile wasabi