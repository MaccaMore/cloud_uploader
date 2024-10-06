#!/bin/bash
install_location="~/.cloudupload"

setup(){
    # Check if AWS CLI is installed
    # I think there should be a better way to check if AWS CLI is installed
    if [ ! command -v aws ]
    then
        echo "AWS CLI could not be found."
        read -p "Install AWS CLI? (y/n)" install
        if [ $install == "y" ]
        then
        curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
        sudo installer -pkg AWSCLIV2.pkg -target /
        fi
    fi

    # Access key and secret key to be entered
    aws configure --profile s3-access

    # Set default bucket name to upload to
    read -p "Do you want to set a default bucket name? (y/n)" default
    if [ $default == "y" ]
    then
    read -p "Enter default bucket name: " bucket_name
    echo "default_bucket:$bucket_name" > "$install_location/default"
    setdefault "$bucket_name"
    fi
}

set-default(){
    if [ ! -f "$install_location/default" ]
    then
    mkdir -p "$install_location"
    touch "$install_location/default"
    fi
    echo "default_bucket:$1" > "$install_location/default"
}


cp() {
    # Check if the file path is provided
    if [ $# -lt 1 ]; then
        echo "Syntax for uploading a file: cloudupload cp <file_path> [destination]"
        exit 1
    fi

    # Check if the file exists
    if [ ! -f "$1" ]; then
        echo "File does not exist. Please enter a valid file path."
        exit 1
    fi

    file_path=$1
    destination=$2
    default_bucket=""

    # Check if the default bucket file exists and get the bucket name from default file
    if [ -f "$install_location/default" ]; then
        default_bucket=$(cat "$install_location/default" | cut -d ":" -f 2 | tr -d ' ')
    fi

    # If no destination bucket is provided, fall back to the default bucket
    if [ -z "$destination" ] && [ -n "$default_bucket" ]; then
        destination=$default_bucket
        echo "Using default bucket: $default_bucket"
    elif [ -z "$destination" ]; then
        echo "Please provide a destination bucket or set a default bucket using cloudupload set-default <bucket_name>"
        exit 1
    fi

    # Check if destination starts with '/' and prepend the default bucket
    if [[ $destination == /* ]]; then
        destination="$default_bucket$destination"
    fi

    # Check if the destination bucket exists using AWS CLI (this assumes AWS CLI is set up)
    if [ ! aws s3 ls "s3://$destination" > /dev/null 2>&1 ]; 
        then
        echo "Bucket does not exist. Create bucket? (y/n)"
        read create
        if [ "$create" == "y" ]; then
            aws s3 mb "s3://$destination" --profile s3-access
        else
            echo "Exiting without creating bucket."
            exit 1
        fi
    fi

    # Ensure the AWS profile 's3-access' exists in the credentials
    if [ ! grep -q '/s3-access/' ~/.aws/credentials ];
    then
        echo "Please connect an AWS profile using the command: cloudupload setup"
        exit 1
    fi

    # Upload the file to the destination
    echo "Uploading $file_path to s3://$destination..."
    aws s3 cp "$file_path" "s3://$destination" --profile s3-access
}

case "$1" in
set-default)
    set-default "$2"
    ;;
setup)
    setup
    ;;
cp)
    cp "$2" "$3"
    ;;
*)
    echo "Usage: cloudupload {set-default <bucket-name>|setup|cp <file_path> [destination]}"
    ;;
    esac
