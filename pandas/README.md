pandas_plyを使う
===

## 内容

[pandas_ply](https://github.com/coursera/pandas-ply)を使います. 

pandasでRのdplyrみたいなことをする, というものです. 

メソッドチェーンを使えると, コードが書きやすて楽しいです. 

今回は, 選挙のデータを使って遊んでみます. 

[衆院選小選挙区立候補者名と, 名前で検索した時のヒット件数のデータ](https://github.com/gghatano/senkyo_predict/blob/master/kouho.hit.list)を使って, pandas-plyで遊びます. 

## 感想

生pandas使うより楽しい. 

並べ替えの方法が分かりません. dplyr::arrangeに対応するのは何? 

## コード

pandas_plyを使うまでの準備です. 
```python
import pandas as pd
from ply import install_ply, X, sym_call
install_ply(pd)
```

データ読み込み. 

立候補者名+ググった時のヒット件数のデータです. 
```python
data = pd.read_csv("../kouho.hit.list", encoding="utf-8", header=0)

print data.head(2)
```

```bash
   BLOCK    NAME  AGE PARTY STATUS     HIT
0  北海道1区   横路 孝弘   73    民主      前  153000
1  北海道1区  野呂田 博之   56    共産      新  346000
```

## 党別に候補者数と平均年齢を調べる

グループ化して, 集計すればいいです. 
```python
partySummarize = (
    data
    .groupby('PARTY')
    .ply_select(
      meanAge=X.AGE.mean(),
      candidateNum=X.NAME.size(),
      )
    )

print partySummarize
```

```bash
       candidateNum    meanAge
PARTY                         
公明                9  52.111111
共産              292  53.188356
次世               39  50.461538
民主              178  50.595506
無所               45  53.177778
生活               13  54.230769
社民               18  56.833333
維新               77  45.311688
自民              283  53.346290
諸派                5  52.400000
```

## 25歳以下の立候補者

dplyr::filterに対応するのはply_whereです. 

```python
## under 25 
print (data
    .ply_where(X.AGE < 30)
    .head(10)
    )
```

```bash
21    北海道7区   鈴木 貴子   28    民主      前  1670000
88     秋田2区   緑川 貴士   29    民主      新   170000
174    埼玉1区    松本 翔   29    社民      新  3070000
221    千葉1区   吉田 直義   27    共産      新  1690000
269    東京1区   野崎 孝信   27    無所      新   530000
271    東京2区   石沢 憲之   27    共産      新   156000
297    東京8区   沢田 真吾   29    共産      新   400000
306   東京11区   下村 芽生   27    無所      新   380000
390   神奈川8区   若林 靖久   29    共産      新   525000
403  神奈川12区  味村 耕太郎   25    共産      新   106000
```

## 検索した時のヒット数(万件)

dplyr::mutateに対応する操作も, ply_selectの中で可能です. 

```python
print (data
    .ply_select(
      NAME=X.NAME,
      HIT_x10000 = X.HIT / 1000
      )
    .head(10)
    )
```

```bash
  HIT_x10000    NAME
0       15.30   横路 孝弘
1       34.60  野呂田 博之
2      268.00   船橋 利実
3       54.30   飯田 佳宏
4       54.10   吉川 貴盛
5      152.00   池田 真紀
6        7.42   松木 謙公
7        5.92   金倉 昌俊
8       33.50    荒井 聰
9       30.30   吉岡 弘子

```
カラムの順番が入れ替わるのなんでだろう. 


