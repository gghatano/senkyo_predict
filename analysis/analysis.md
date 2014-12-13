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
## 1: 北海道1区 野呂田 博之  54  共産     新  346000
## 2: 北海道1区   大竹 智和  35  維新     新  318000
## 3: 北海道1区   船橋 利実  52  自民     新 2680000
## 4: 北海道1区   清水 宏保  38  大地     新   90100
## 5: 北海道1区   横路 孝弘  71  民主     前  153000
## 6: 北海道2区   高橋 美穂  47  維新     新 1870000
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
##      PARTY CANDIDATE MEAN_AGE
##  1:   共産       283 52.47350
##  2:   自民       282 51.97163
##  3:   民主       251 49.69721
##  4:   維新       146 45.13699
##  5:   未来       109 49.79817
##  6: みんな        64 44.25000
##  7:   無所        47 55.57447
##  8:   諸派        25 44.48000
##  9:   社民        22 55.63636
## 10:   公明         9 50.11111
## 11:   大地         6 40.50000
## 12:   国民         2 52.50000
## 13:   新日         1 56.00000
## 14:    ALL      1247 50.22694
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
## Source: local data table [12 x 2]
## 
##     PARTY NUM
## 1    自民  81
## 2    共産  68
## 3    民主  49
## 4    維新  39
## 5    未来  23
## 6  みんな  13
## 7    無所   8
## 8    社民   8
## 9    公明   5
## 10   諸派   3
## 11   大地   2
## 12   国民   1
```

```r
## 円グラフ
# dat_party %>% 
#   ggplot(aes(x = "", y=NUM, fill=reorder(PARTY, ORDER))) +  
#   theme_set(theme_gray(base_size=12, base_family="HiraKakuProN-W3")) +
#   geom_bar(stat="identity", width=1) + coord_polar("y") + ylab("議席数") + 
#   guides(fill=guide_legend(title=NULL)) 
```

共産党が多く, 公明党が少ないですね. ダメっぽいです. 

12月15日に結果を見て, 正答率を調査しようと思います. 

以上です. 

