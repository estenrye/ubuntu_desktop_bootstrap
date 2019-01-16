POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -t|--vagrantToken)
    VAGRANT_CLOUD_TOKEN="$2"
    shift # past argument
    shift # past value
    ;;
    -u|--vagrantUsername)
    VAGRANT_CLOUD_USERNAME="$2"
    shift # past argument
    shift # past value
    ;;
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
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

# Release the version
curl --header "Authorization: Bearer $VAGRANT_CLOUD_TOKEN" https://app.vagrantup.com/api/v1/box/$VAGRANT_CLOUD_USERNAME/$VAGRANT_BOX_NAME/version/$VAGRANT_BOX_VERSION/release --request PUT