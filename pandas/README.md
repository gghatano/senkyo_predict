pandas_plyを使う
===

## 内容

[pandas_ply](https://github.com/coursera/pandas-ply)を使います. 

選挙のデータを使って遊んでみます. 

## 感想

そのままpandas使うより楽しい. 

並べ替えの方法が分からん. dplyr::arrangeに対応するのは何? 

## コード

pandas_plyを使うまでの準備
```python
import pandas as pd
from ply import install_ply, X, sym_call
install_ply(pd)
```

データ読み込み. 立候補者+ググった時のヒット件数のデータです. 
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
    )
```

```bash
      BLOCK    NAME  AGE PARTY STATUS      HIT
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
407  神奈川13区   伊藤 優太   29    維新      新   723000
414  神奈川15区   沼上 徳光   28    共産      新   127000
459    石川3区   渡辺 裕子   29    共産      新  1760000
633    京都6区   上條 亮一   28    共産      新   221000
672   大阪12区  堅田 壮一郎   28    維新      新   349000
813    山口3区   藤井 岳志   28    共産      新   424000
890    佐賀1区    古賀 誠   29    共産      新   282000
909    熊本1区   高本 征尚   29    共産      新    36400
```



