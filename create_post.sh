#!/usr/bin/env bash
# Convert the top-level header into a frontmatter title and current date, and
# download any non-local images and convert them into local images.
#
# Example:
#   $ echo -e "#foo bar\nbaz" | ./create_post.sh foldername
#   +++
#   title = "foo bar"
#   date = "2020-11-30"
#   +++
#   baz

# Process the body
while read line; do
    if [[ "$line" =~ \!\[.*\]\(https:\/\/(.*)\) ]]; then
        echo "$line"
        # Download remote images locally, rewrite the image include.
        for url in "${BASH_REMATCH[@]}"; do
            url="https://$url"
            # 
            # download the images to the post folder
            pfolder="./static/img/${1}/"
            echo "$pfolder"
            wget -P "$pfolder" -q "$url"
            #
            # this is the name of the downloaded file
            fname=$(basename "$url")
            #
            # this is the full path where the files will be stored
            newpath="/img/${1}/${fname}"
            line=${line//$url/$newpath}
        done
        echo "$line"
    fi
    # echo $line
done
