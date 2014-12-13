#!/bin/bash

dir=$(dirname $0)

## scrape senkyo-data 
## http://www.asahi.com/senkyo/sousenkyo46/kouho/A"$prefNum".html

for pref in `seq 1 47`
do
  prefNum=$(printf "%02d\n" "$pref")
  echo $prefNum
  url="http://www.asahi.com/senkyo/sousenkyo46/kouho/A"$prefNum".html"
  echo $url
  curl $url >$dir/htmls/pref_${prefNum}.html
  sleep 1
done
