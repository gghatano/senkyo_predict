#!/bin/bash

## scrapte the html file in $dir/htmls/pref_[0-9].html
dir=$(dirname $0)

[ -e "$dir/kouho.list" ] && rm $dir/kouho.list

for file in `ls $dir/htmls | grep "pref"`
do
  echo $file
  rowNum=$(cat $dir/htmls/$file | wc -l)
  echo $rowNum
  cat $dir/htmls/$file | nkf -w8 | 
  grep -E -A $rowNum "kouho_A[0-9]{2} BGN" | 
  grep -E -B $rowNum "kouho_A[0-9]{2} END" | 
  sed 's/<td class="\([^"]*\)">/\1,/' | 
  sed 'y/０１２３４５６７８９/0123456789/' | 
  grep -E "([0-9]区|namae|party|age|status)" | 
  grep -v "区域" | 
  grep -v "th" | 
  sed -e 's/<[^>]*>//g' -e 's/　/ /' | 
  gsed 's/\(^[^0-9]*[0-9][0-9]*区\)/%\n\1/' | 
  tr '\n' ',' | 
  tr '%' '\n' | sed 's/^,//' | grep -v "^$" > $dir/tmp/${file}_block.dat

  cat $dir/tmp/${file}_block.dat | 
  while read line 
  do
    block=$(echo $line | cut -d, -f1)
    echo $block
    echo $line | gsed 's/namae/\nnamae/g' | 
    sed "s/^/$block,/" | 
    sed -e 's/[namae|age|party|status]//g' -e 's/,,,$/,/' | 
    awk -F, '{if(NF==10) print $0}' | 
    sed 's/,,/,/g' >> $dir/kouho.list
  done
done

cat ./kouho.list
