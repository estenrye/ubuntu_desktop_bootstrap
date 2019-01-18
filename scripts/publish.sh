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

if [ "$(uname -s)" = 'Linux' ]; then
  CURL='/usr/bin/curl'
else
  CURL='/c/Program Files/Git/mingw64/bin/curl.exe'
fi

# Create a new box
"$CURL" --header "Content-Type: application/json" --header "Authorization: Bearer $VAGRANT_CLOUD_TOKEN" https://app.vagrantup.com/api/v1/boxes --data "{ \"box\": { \"username\": \"$VAGRANT_CLOUD_USERNAME\", \"name\": \"$VAGRANT_BOX_NAME\", \"is_private\":false } }"

# Create a new version
"$CURL" --header "Content-Type: application/json" --header "Authorization: Bearer $VAGRANT_CLOUD_TOKEN" https://app.vagrantup.com/api/v1/box/$VAGRANT_CLOUD_USERNAME/$VAGRANT_BOX_NAME/versions --data "{ \"version\": { \"version\": \"$VAGRANT_BOX_VERSION\" } }"

# Create a new provider
"$CURL" --header "Content-Type: application/json" --header "Authorization: Bearer $VAGRANT_CLOUD_TOKEN" https://app.vagrantup.com/api/v1/box/$VAGRANT_CLOUD_USERNAME/$VAGRANT_BOX_NAME/version/$VAGRANT_BOX_VERSION/providers --data "{ \"provider\": { \"name\": \"$VAGRANT_PROVIDER_TYPE\", \"url\":\"https://s3.wasabisys.com/vagrant-cloud/$VAGRANT_BOX_NAME/$VAGRANT_PROVIDER_TYPE-$BUILD_BUILDNUMBER.box\" } }"
