function y=Rosenbrock(x)  
    %Rosenbrock 函数  
    %输入x,给出相应的y值,在x=(1,1,…,1) 处有全局极小点0,为得到最大值，返回值取相反数  
    %编制人：  
    %编制日期：  
    [row,col]=size(x);  
    if row>1  
        error('输入的参数错误');  
    end  
    y=100*(x(1,2)-x(1,1)^2)^2+(x(1,1)-1)^2;
    y=-y;
end