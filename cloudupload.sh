!# /bin/bash
# User should enter name of file, location to upload to

if [ $# -eq 0 ]
then
    echo "Syntax to use this script is: cloudupload.sh file_path destination"
exit 1
fi

#if file does not exits:
if [ ! -f $1 ]
then
echo "File does not exist. Please enter a valid file path."
exit 1
fi

file_path=$1
destination=$2

# Check if AWS CLI is installed
if [ ! command -v aws &> /dev/null ]
then
    echo "AWS CLI could not be found. Please install AWS CLI."
    exit 1
fi

# check logged in user
# ~./aws/credentials file should be present with cloud-upload credentials
if [ ! -f ~/.aws/credentials ]
then
echo "Please install AWS CLI, create user with S3 bucket permissions, and add as profile s3-access"
exit 1
fi

# check cloud upload profile exists in credentials file

if [ -z "$(grep "s3-access" ~/.aws/credentials)" ]
then
echo "Please create a AWS profile using the command: aws configure --profile s3-access"
exit 1
fi

# check if destination bucket exists
 aws s3 ls s3://$destination
