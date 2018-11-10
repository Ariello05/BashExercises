#!bin/sh

#if [ ! -d "HTML" ]; then
#	mkdir "HTML"
#fi


cats=$(curl -s 'https://api.thecatapi.com/v1/images/search/' | jq -r '.[].url')
wget -r --tries=10 $cats -o logCat.txt
cats=$(echo $cats | cut -c 9-)
img2txt -W ${1:-100} -f ${2:-utf8} $cats > $cats.txt
cat $cats.txt

wget -r --tries=10 http://api.icndb.com/jokes/random/ -o logChuck.txt 
cat ./api.icndb.com/jokes/random/index.html | jq '.value.joke'
