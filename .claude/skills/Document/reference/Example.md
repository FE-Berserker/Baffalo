---
tags:
  - Baffalo_Component
---
# Example

<center>Xie Yu</center>

## 介绍

类的基本极少

## 原理



## 类结构

![](./Bolt.assets/Fig7.jpg)

==输入 input:==

* input1 : 输入参数1

==参数 params:==

* material : 材料属性

==输出 output :==

* Assembly : 网格装配

==基准 Baseline：==

* Basline1 : 安全基准1

==安全裕度 Capacity :==

* SF : 安全系数1


## 案例

### Create Bolt with Nut (Flag=1)

案例介绍：



图表：



源代码：

``` matlab
inputStruct.d=12;
inputStruct.l=60;
inputStruct.lk=42;
paramsStruct.ThreadType=1;
paramsStruct.MuG=0.1;
paramsStruct.MuK=0.1;
paramsStruct.Nut=1;
obj= bolt.Bolt(paramsStruct, inputStruct);
obj= obj.solve();
Plot2D(obj);
Plot3D(obj);
ANSYS_Output(obj.output.Assembly);
```

## 参考文献

[1] VDI2230_blatt_1_2015

[2] VDI2230_blatt_2_2014
