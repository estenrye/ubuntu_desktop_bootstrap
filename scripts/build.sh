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

PACKER_ARCHIVE="${BIN}/bin/packer.zip"

mkdir -p "${BIN}/bin"

if [ "$(uname -s)" = 'Linux' ]; then
  CURL='/usr/bin/curl'
  PACKER_URI='https://releases.hashicorp.com/packer/1.3.3/packer_1.3.3_linux_amd64.zip'
  PACKER="${BIN}/bin/packer"
else
  CURL='/c/Program Files/Git/mingw64/bin/curl.exe'
  PACKER_URI='https://releases.hashicorp.com/packer/1.3.3/packer_1.3.3_windows_amd64.zip'
  PACKER="${BIN}/bin/packer.exe"
fi

if [ ! -f "$PACKER" ]; then
    "$CURL" -L $PACKER_URI -o "$PACKER_ARCHIVE"
    unzip $PACKER_ARCHIVE -d "${BIN}/bin"
fi

$PACKER build -only=$VAGRANT_BUILDER_TYPE -force -var-file="${BIN}/packer_templates/${UBUNTU_VERSION}/${VAR_FILE}.json" ${BIN}/packer_templates/${UBUNTU_VERSION}/ubuntu.json