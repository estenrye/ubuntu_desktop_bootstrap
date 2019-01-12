pip install awscli --upgrade --user

AWSCLI="$(pip show awscli | grep Location | sed 's/Location: //')/awscli"

python $AWSCLI configure set region us-east-1 --profile wasabi
python $AWSCLI configure set output json --profile wasabi
python $AWSCLI configure set s3.endpoint_url https://s3.wasabisys.com --profile wasabi
