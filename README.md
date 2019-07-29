# README

## Requirements
* Add-on "cookies.txt" of Firefox
* Curl

#### How to install cookies.txt
Download it at [cookies.txt](https://addons.mozilla.org/en-US/firefox/addon/cookies-txt/?src=search)

#### How to install Curl
Use the following command
```bash
sudo apt install curl
```

## How to use
* Open firefox
* Log in at www.polito.it and go to the webpage of the videolecture 1
* Export cookies by clicking on the add-on icon (upper right corner)
* Copy the webpage url of the videolecture 1
* Run the script:
	+ 1st parameter: cookies
	+ 2nd parameter: url (between quotes)
	+ 3rd parameter: path where to download videolectures
	+ Example: ./download.sh cookies.txt "https://didattica.polito.it/portal/pls/portal/sviluppo.videolezioni.vis?cor=410&arg=Lezioni%20on-line&lez=17584" ./Videolectures
