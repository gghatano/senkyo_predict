#!/usr/local/bin/python

## http://pythonhosted.org/pandas-ply/#module-ply.methods

import pandas as pd
from ply import install_ply, X, sym_call

install_ply(pd)

data = pd.read_csv("../kouho.hit.list", encoding="utf-8", header=0)

print data.head(2)

partySummarize = (
    data
    .groupby('PARTY')
    .ply_select(
      meanAge=X.AGE.mean(),
      candidateNum=X.NAME.size(),
      )
    )

print partySummarize

## under 25 
print (data
    .ply_where(X.AGE < 30)
    )

