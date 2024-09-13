!# /bin/bash
# User should enter name of file, location to upload to

if [ $# -eq 0 ]
then
    echo "Enter the name of the file and bucket location to upload to"
exit 1
fi

#if file does not exits:
if [ ! -f $1 ]
then
echo "File does not exist"
exit 1
fi


file_path=$1
