!# /bin/bash
# User should enter name of file, location to upload to

if [ $1 == "setup" ]
then
setup();
fi

if [ $1 == "set-default" ]
then
set-default();
fi

if [ $1 == "cp" ]
then
cp();
fi




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

# Access key and secret key to be entered
aws configure --profile s3-access
fi

# Set default bucket name to upload to
read -p "Do you want to set a default bucket name? (y/n)" default
if [ $default == "y" ]
then
    # check if config file exists
    # If not create it and set the first line to be 'default_bucket: bucket_name'
    if [ ! -f ~/.cloudupload/default_bucket ]
    then
    touch ~/.cloudupload/default_bucket
    fi
    read -p "Enter default bucket name: " bucket_name
    echo "default_bucket: $bucket_name" > ~/.cloudupload/default
    fi
}

set-default(){
if [ ! -f ~/.cloudupload/default ]
then
touch ~/.cloudupload/default
fi
echo "default_bucket: $3" > ~/.cloudupload/default
}


cp(){
if [ $# -eq 0 ]
then
echo "Syntax for uploading a file: cloud-upload <command> <file_path> <destination>"
exit 1
fi

# Check file exists
if [ ! -f $1 ]
then
echo "File does not exist. Please enter a valid file path."
exit 1
fi

file_path=$1

if [ $# -eq 2 && -f ~/.cloudupload/default ];then
destination=~/.cloudupload/default
else
echo "Please enter a destination bucket name. Set default bucket using cloudupload set-default <bucket_name>"
exit 1
fi

# If destination bucket provided, and it starts with a /, set destination to defaultbucket/destination
if [ $# -eq 3 && $3 == "/"* ];then
destination=~/.cloudupload/default_bucket/$3
fi

if [ $# -eq 3 ];then
destination=$3
fi

# Check if destination bucket exists
# if not, prompt creation
if [ -z "$(aws s3 ls | grep ~/.cloudupload/default)" ];then
echo "Bucket does not exist. Create bucket? (y/n)"
read -p "Create bucket? (y/n)" create
if [ $create == "y" ];then
aws s3 mb s3://$destination --profile s3-access
fi
fi

# check cloud upload profile exists in credentials file
if [ -z "$(grep "s3-access" ~/.aws/credentials)" ]
then
echo "Please connect an AWS profile using the command: cloudupload setup"
exit 1
fi

echo "Uploading $filename to $destination..."
aws s3 cp $filename $destination --profile s3-access
}
