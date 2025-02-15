# Baffalo

<img src="./icons/Baffalo3.png" alt="Baffalo" style="zoom: 50%;" />

Baffalo是开源的Matlab工具箱来建立系统分析的工具，他可将文件导出到ANSYS或者Simpack

Baffalo本身不是求解器，他可以提供网格、画图和工程计算的功能.

---

1. 首先打开**setBaffaloPath**函数设置对应路径

如果你拥有ANSYS,将ANSYS路径设置如下,ANSYS是优秀的有限元分析软件。

```matlab
% Set ANSYS Path
ANSYS_Path='C:\Program Files\ANSYS Inc\v201\ansys\bin\winx64\ANSYS201.exe';
```

如果你拥有Simpack, 将Simpack路径设置如下，Simapck可提供系统的多体动力学分析。

```matlab
% SetSimpackPath
Simpack_Path='D:\SimPack\run\bin\win64';
```

Paraview（https://www.paraview.org) 是一款开源的可视化软件，Baffalo可将网格导出为VTK格式文件，Paraview路径设置如下：
```matlab
% SetParaViewPath
ParaViewDir="D:\005_Lib\ParaView\bin";
```

2.  运行**setBaffaloPath**

Baffalo说明文档存放于Document中，案例文件存放于Tesing文件夹中。

更多的信息可参见 https://www.feacat.com/

---


Baffalo is open source Matlab tool to do the system simulation, it can output file to ANSYS or Simpack.

Baffalo itself is not a solver, can provide the mesh 、figure 、engineer calculation functions

---

1. First open the **setBaffaloPath** function to set the corresponding path

If you own ANSYS, set the ANSYS path as follows. ANSYS is an excellent finite element analysis software.

```matlab
% Set ANSYS Path
ANSYS_Path='C:\Program Files\ANSYS Inc\v201\ansys\bin\winx64\ANSYS201.exe';
```
If you have Simpack, set the Simpack path as follows. Simapck can provide multi-body dynamics analysis of the system.

```matlab
% SetSimpackPath
Simpack_Path='D:\SimPack\run\bin\win64';
```

Paraview (https://www.paraview.org) is an open source visualization software. Baffalo can export grids to VTK format files. The Paraview path is set as follows:

```matlab
% SetParaViewPath
ParaViewDir="D:\005_Lib\ParaView\bin";
```

2. Run **setBaffaloPath**

Baffalo documentation is stored in Document, and case files are stored in the Tesing folder.

For more information:  https://www.feacat.com/
