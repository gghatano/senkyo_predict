選挙の結果を予測する
===

小選挙区選挙の結果を予想します. 

"選挙区 名前"で検索をかけて, ヒット数が人気を反映していると考えます. 

ヒット数が最大の人が当選すると予測します. 

データは[Githubにあげてあります](https://github.com/gghatano/senkyo_predict).

選挙区+名前を[bing](http://www.bing.com)で検索して, ヒット数を抜き出しました. 

googleやyahooだとヒット数抜き出しが大変そうなので, bingを使っています. 


```r
library(data.table)
library(dplyr)
library(ggplot2)
```

## 内容確認

データの内容を確認します. 立候補者数と平均年齢. 

```r
dat = fread("~/works/election/kouho.hit.list")
dat %>% 
  setnames(c("BLOCK", "NAME", "AGE", "PARTY", "STATUS", "HIT"))

dat %>% head
```

```
##        BLOCK        NAME AGE PARTY STATUS     HIT
## 1: 北海道1区   横路 孝弘  73  民主     前  153000
## 2: 北海道1区 野呂田 博之  56  共産     新  346000
## 3: 北海道1区   船橋 利実  54  自民     前 2680000
## 4: 北海道1区   飯田 佳宏  41  無所     新  543000
## 5: 北海道2区   吉川 貴盛  64  自民     前  541000
## 6: 北海道2区   池田 真紀  42  無所     新 1520000
```

```r
## 全体の平均
dat_all = 
  dat %>% 
  mutate(PARTY = "ALL") %>% 
  group_by(PARTY) %>% 
  summarise(CANDIDATE=n(), MEAN_AGE = mean(AGE)) 

dat %>% 
  group_by(PARTY) %>% 
  summarise(CANDIDATE=n(), MEAN_AGE = mean(AGE)) %>% 
  arrange(desc(CANDIDATE)) %>% 
  rbind(dat_all)
```

```
##     PARTY CANDIDATE MEAN_AGE
##  1:  共産       292 53.18836
##  2:  自民       283 53.34629
##  3:  民主       178 50.59551
##  4:  維新        77 45.31169
##  5:  無所        45 53.17778
##  6:  次世        39 50.46154
##  7:  社民        18 56.83333
##  8:  生活        13 54.23077
##  9:  公明         9 52.11111
## 10:  諸派         5 52.40000
## 11:   ALL       959 52.07821
```
全体で1247人, 平均年令は50.2歳でした. おっさんです. 

共産党の出馬数が案外多いです. 

## 当選者予測

本題です. 

各ブロックで, 最もヒット数が多い人を当選者とします. 


```r
## ブロックごとに検索ヒット数最大の人を当選者と予測します
dat_predict_win = 
  dat %>% 
  group_by(BLOCK) %>% 
  filter(HIT == max(HIT))
dat_predict_win %>% write.csv("predict.csv", quote=FALSE, row.names=FALSE)
```

## 党別当選者数の予測

小選挙区選挙で, 各党が何議席獲得するかです. 

```r
dat_party = 
  dat %>% 
  group_by(BLOCK) %>% 
  filter(HIT == max(HIT))  %>% 
  group_by(PARTY, add=FALSE) %>% 
  summarise(NUM = n()) %>% 
  arrange(desc(NUM)) 
  #mutate(ORDER=1:dim(.)[1])

## 結果
dat_party
```

```
## Source: local data table [9 x 2]
## 
##   PARTY NUM
## 1  自民  99
## 2  共産  90
## 3  民主  41
## 4  維新  20
## 5  無所  17
## 6  次世   9
## 7  生活   7
## 8  公明   6
## 9  社民   6
```

```r
# 円グラフ
#  dat_party %>% 
#    ggplot(aes(x = "", y=NUM, fill=reorder(PARTY, ORDER))) +  
#    theme_set(theme_gray(base_size=12, base_family="HiraKakuProN-W3")) +
#    geom_bar(stat="identity", width=1) + coord_polar("y") + ylab("議席数") + 
#    guides(fill=guide_legend(title=NULL)) 
```

共産党が多く, 公明党が少ないですね. ダメっぽいです. 

12月15日に結果を見て, 正答率を調査しようと思います. 

以上です. 

