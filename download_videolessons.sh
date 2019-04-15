#!/bin/bash

if [ $# -ne 3 ]; then
	echo "usage: $0 cookie url path_download"
	exit 1
fi

# declarations
base_url_video="https://didattica.polito.it"
base_url_page=$base_url_video"/portal/pls/portal/"
info="Info.html"
cookie="$1"
url_page=$2
path_download="$3"
tmp=$$

# prepare environment
mkdir $tmp
mkdir -p "$path_download"

# webpage
curl -s --cookie "$cookie" $url_page > "$path_download"/$info
course=$(cat "$path_download"/$info | grep 'h2 text-primary' | cut -d '>' -f 2 | \
	cut -d '<' -f 1 | tr ':-/\' ' ' | tr -s ' ' | tr ' ' '_' | \
	sed 's/^ *//g' | sed 's/ *$//g')  # leading/trailing white spaces and special characters removed
echo "Course:" $course

# download
cat "$path_download"/$info | grep '<a style="color:#003576;' > $tmp/list
while read line; do
	# build url of webpage
	url_page=$(echo $line | cut -d '"' -f 4)
	echo $url_page > $tmp/url
	url_page=$(awk '{gsub(/&amp;/, "\&", $0); print $0}' $tmp/url)	# replace &amp; with &
	url_page=$base_url_page$url_page

	# download webpage
	curl -s --cookie "$cookie" $url_page > $tmp/$info

	# build url and name of video
	url_video=$base_url_video$(cat $tmp/$info | grep -e '<a id="video.*Video</a>' | cut -d '"' -f 4)
	for i in {1..10}; do
		n=$(echo $line | cut -d '>' -f 2 | cut -d '<' -f 1 | cut -d ' ' -f $i)	# number of lesson
		echo $n | grep -q -e '^[0-9]+$'  # is it a number?
		if [ $? -eq 0 ]; then  
			break
		fi
	done
	filename=$course"_lez_"$n".mp4"

	# download video
	found=0
	for f in $(ls "$path_download"); do
		if [ $f = $filename ]; then
			found=1
			break
		fi
	done
	if [ $found -ne 1 ]; then
		wget -O "$path_download"/$filename -q $url_video
		echo "$filename downloaded"
	else
		echo "$filename already present"
	fi
done < $tmp/list

# clean
rm -rf $tmp

exit 0
