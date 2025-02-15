function result=Schaffer(x1)
    %Schaffer函数
    %输入x,给出相应的y值,在x=(0,0,…,0)处有全局极大点1.
    [row,~]=size(x1);
    if row1
        error('输入的参数错误');
    end
    x=x1(1,1);
    y=x1(1,2);
    temp=x^2+y^2;
    result=0.5-(sin(sqrt(temp))^2-0.5)(1+0.001temp)^2;
end