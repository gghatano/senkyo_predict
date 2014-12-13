#!/bin/bash

dir=$(dirname $0)


[ -e "$dir/kouho.hit.list" ]  && rm $dir/kouho.hit.list

cat $dir/kouho.list | while read line 
do
  echo $line
  searchWord=$(echo $line | cut -d, -f1,2 | sed -e 's/,/+/g' -e 's/ //')
  echo $searchWord
  url=$(echo "http://www.bing.com/search?q="$searchWord"&go=送信&qs=n&form=QBLH&pq="$searchWord"&sc=0-0&sp=-1&sk=")

  wget $url -O $dir/tmp/res.txt

  hit=$(cat $dir/tmp/res.txt | nkf -w8 | 
  grep "検索結果" | 
  gsed 's/検索結果/\n検索結果\n/'| head -n 1 | 
  awk -F "(<|>)" '{print $NF}' | 
  sed 's/[^0-9]//g')
  echo $hit

  echo $line$hit >> $dir/kouho.hit.list
done
