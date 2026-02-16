% CREWES synthetic sesimic by diffraction superposition
% The SYNSECTIONS toolbox provides a suite of tools to create synthetic seismic
% sections by superposition of hyperbolae and other events. Each function is
% designed to accept a matrix and to insert a single event into it. The event is
% always added (superimposed) on top of what is already there.
% CREWES 通过绕射叠加进行合成地震模拟
% SYNSECTIONS 工具箱提供了一套通过双曲线和其他事件叠加创建合成地震剖面的工具。
% 每个函数都设计为接受一个矩阵并在其中插入单个事件。该事件总是被叠加
% 在已存在的内容之上。
%
%Tools
% 工具
% EVENT_DIP: inserts a dipping (linear) event in a matrix
% EVENT_DIPH: 在矩阵中插入一个倾伏（线性）事件
% EVENT_DIPH: 通过绕射叠加构造一个倾伏事件
% EVENT_DIPH2: constructs a dipping event with sparse diffraction superposition
% EVENT_DIPH2: 构造一个带有稀疏绕射叠加的倾伏事件
% EVENT_HYP: inserts a hyperbolic event in a matrix.
% EVENT_HYP: 在矩阵中插入一个双曲线事件
% EVENT_PWLINH: diffraction superposition along a piecewise linear track
% EVENT_PWLINH: 沿分段线性轨迹的绕射叠加
% EVENT_SPIKE: inserts a spike in a matrix.
% EVENT_SPIKE: inserts a spike in a matrix
%
%Standard sections
% MAKESTDSYN: Make a non-diffraction synthetic to demo migration codes
% MAKESTDSYNH: Make a diffraction synthetic to demo migration codes
% DIFFRACTION_SECTION: make a section full of diffractions spaced on a 
%                       regular grid
%
%Demos
% MAKESECTIONS: demo the use of the section tools
% DEMO_HYPERBOLAS: demo the superposition of diffraction hyperbolae
%
%3D Rayleigh-Sommerfeld modelling
% SHOT_MODEL3D ... model a 3D shot
% STACK_MODEL3D ... model a 3D stack
%
 
