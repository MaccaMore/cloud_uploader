# cloud_uploader
Simple script which simplifies the process of uploading files to S3 buckets. 

# usage
After installation, simply enter: 'cloudup <filename> [optional destination]'
- If only a filename is provided, the script will automatically upload to the default folder set during installation.
- If no default folder is set, the file will be uploaded to the root directory of the S3 bucket.
- If an optional destination folder is provided, the file will be uploaded to that specific folder inside the bucket.

# installation
to install:
1. Clone the files in this repo and run the installation script with command `sudo bash cu_install.sh install`
2. When prompted, enter a user access key for a user that has permissions to the s3 bucket
   a) Please **do not use root user key** for security reasons.
   b) Key is stored securely with AWS cli under a new account name 'cloud_uploader'
3. Enter the bucket name to use. The user access key provided must have permissions to upload to this bucket.
4. Optionally add a default destination folder. Default will be the root directory of the S3 bucket.

to remove:
1. Run the installation script with `sudo bash cu_install.sh remove`
  a) This will remove account from the AWS CLI installation, and remove the command.
  B) This will NOT remove the AWS CLI application. To remove AWS CLI you'll need to enter: `sudo rm /usr/local/bin/aws`
`sudo rm -rf /usr/local/aws-cli`


# prerequisites
macOS versions 10.15 and later required for AWS CLI
Should work on other unix based OS 
