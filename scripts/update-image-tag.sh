#!/bin/bash

# This script receives a deployment or rollout yaml file, finds the row which defines the "image" of the container.
# The script will replace this line with a new line which is exactly the same except for the image TAG which will be
# equal to TAG (-t) argument sent to this script.

echo "updating image tag.."

while getopts f:t: flag
do
    case "${flag}" in
        f) FILE=${OPTARG};;
        t) TAG=${OPTARG};;
    esac
done

if [ -z "$FILE" ] || [ -z "$TAG" ];
then
      echo "\$TAG or \$FILE are empty"
      exit 1
fi

echo "updating file: $FILE";
echo "tag: $TAG";

LINE=$(cat $FILE | grep image: | sed 's/^[ \t]*//')
VESION_TO_REPLACE=$(cat $FILE | grep image: | cut -d ":" -f 3)
NEW_LINE=$(echo $LINE | sed -e "s/$VESION_TO_REPLACE/$TAG/")
sed -i "s|$LINE|$NEW_LINE|g" $FILE