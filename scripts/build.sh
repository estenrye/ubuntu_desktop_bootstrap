POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -l|--ubuntuVersion)
    UBUNTU_VERSION="$2"
    shift # past argument
    shift # past value
    ;;
    -v|--packerVariableFile)
    VAR_FILE="$2"
    shift # past argument
    shift # past value
    ;;
    -b|--builderType)
    VAGRANT_BUILDER_TYPE="$2"
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

BIN="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." >/dev/null 2>&1 && pwd )"
PACKER="${BIN}/bin/packer.exe"
PACKER_ARCHIVE="${BIN}/bin/packer.zip"

if [ "$(uname -s)" -eq 'Linux' ]; then
  CURL='/usr/bin/curl'
else
  CURL='/c/Windows/system32/curl'
fi

if [ ! -f "$PACKER" ]; then
    $CURL -L https://releases.hashicorp.com/packer/1.3.3/packer_1.3.3_windows_amd64.zip -o "$PACKER_ARCHIVE"
    unzip -f $PACKER_ARCHIVE -d "${BIN}/bin"
fi

$PACKER build -only=$VAGRANT_BUILDER_TYPE -force -var-file="${BIN}/packer_templates/${UBUNTU_VERSION}/${$VAR_FILE}.json" ${BIN}/packer_templates/${UBUNTU_VERSION}/ubuntu.json