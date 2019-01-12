pip install awscli --upgrade --user

AWSCLI="$(pip show awscli | grep Location | sed 's/Location: //')/awscli"

python $AWSCLI configure set --profile wasabi region=us-east-1
python $AWSCLI configure set --profile wasabi output=json
python $AWSCLI configure set --profile wasabi s3.endpoint_url=https://s3.wasabisys.com
