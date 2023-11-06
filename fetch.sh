#!/bin/bash

# This script is meant to get data from goodreads and put it in an xml/json file
# Bookshelves options - currently-reading, to-read, read

[ -z "$1" ] && { printf "Couldn't get user personal number. Exiting...\n"; exit 2; }

USER_ID=$1
LINK="https://www.goodreads.com/review/list_rss/${USER_ID}?shelf=read"
RAW_FILE="raw.xml"
DATA_FILE="data.txt"

# Downloading the file.
wget --quiet --tries=2 --output-document="${RAW_FILE}" "${LINK}"

# Trim unnecessary data
sed -i '4,20d' "${RAW_FILE}"

[ -f "${RAW_FILE}" ] || { printf "The file could not be downloaded or is empty. Exiting...\n"; exit 1; }

# Retrieve important book data
xmllint --xpath "//book_id|//title|//author_name|//isbn|//user_rating|//num_pages" "${RAW_FILE}" > "${DATA_FILE}";

# Delete old data
rm "${RAW_FILE}"

# OR just empty it
# echo "" > ${RAW_FILE}