!# /bin/bash
# User should enter name of file, location to upload to

if [ $1 == "setup" ]
then
setup();
fi

if [ $1 == "cp" ]
then
cp();
fi

# do setup

setup(){
# Check if AWS CLI is installed
if [ $(which aws) == *"not"* ]
then
    echo "AWS CLI could not be found."
    read -p "Install AWS CLI? (y/n)" install
    if [ $install == "y"]
    then
    curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
    sudo installer -pkg AWSCLIV2.pkg -target /
    fi



fi
}

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
aws s3 ls s3://$destination --profile s3-access


echo "Uploading $filename to $destination..."
aws s3 cp $filename $destination

echo `aws
