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
  grep -E -A $rowNum "Kouho data BGN" | 
  grep -E -B $rowNum "Kouho data END" |  
  sed 's/<td class="\([^"]*\)">/\1,/' | 
  sed 'y/０１２３４５６７８９/0123456789/' |
  sed "s/<h2>/block,/"|
  grep -E "^(namae|name|age|party|status|block)" |
  sed -e 's/<[^>]*>//g'  -e 's/　/ /' | 
  gsed 's/block/%\nblock/' | 
  tr "\n" ',' | 
  tr "%" '\n' | 
  sed 's/^,//' > $dir/tmp/${file}_block.dat

  cat $dir/tmp/${file}_block.dat |
  while read line 
  do
    block=$(echo $line | cut -d, -f2)
    echo $block
    echo $line | 
    gsed 's/namae/\nnamae/g' | 
    grep 'namae' | 
    sed 's/[namae|age|party|status]//g' |
    sed -e "s/^/$block/" -e 's/,,/,/g' >> $dir/kouho.list
  done
done

cat $dir/kouho.list
cat $dir/kouho.list | wc -l
