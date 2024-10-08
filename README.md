# cloud_uploader
Script which streamlines the process of uploading files to AWS S3 buckets from unix based OS. 
Effectively works using a secondary default account.

# usage
## upload files
After installation and setup, simply enter:  
`cloudup cp <filename> [optional destination]`
- If only a filename is provided, the script will automatically upload to the default folder set during installation.
- If no default folder is set, the file will be uploaded to the root directory of the S3 bucket.
- If an optional destination folder is provided, the file will be uploaded to that specific folder inside the bucket.

## set new bucket
`cloudup set-default <bucket-name>`

## input new user key
`cloudup setup`

### examples
`cloudup cp file*.txt`  
`cloudup cp *log* /log_files`
`cloudup set-default moon-pig-car`

# installation
### to install:
1. Clone the files in this repo using:  
`git glone https://github.com/MaccaMore/cloud_uploader/` 
2. Run the installation script with command:  
`sudo bash cu_install.sh install`
3. After successful install, run setup with command:
`cloudup setup`
4. When prompted, enter a user access key for a user that has permissions to an s3 bucket
	  - Please **do not use root user key** for security reasons.  
	  - Key is stored securely with AWS cli under a new account named 'cloud_uploader'
5. Enter the bucket name. The user access key provided must have permissions to upload to this bucket.
6. Optionally add a default destination folder. Default will be the root directory of the S3 bucket.

### to remove:
6. Run the installation script with  
 `sudo bash cu_install.sh uninstall`  
	- This will remove account from the AWS CLI installation, and remove the command.  
 	- This will NOT remove the AWS CLI application. To remove AWS CLI you'll need to enter:  
 `sudo rm /usr/local/bin/aws`  
 `sudo rm -rf /usr/local/aws-cli`


# prerequisites
macOS versions 10.15 and later required for AWS CLI
Should work on other unix based OS 
