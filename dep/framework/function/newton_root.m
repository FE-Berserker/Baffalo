function  varargout = newton_root(equ_func, x0,eps,max_iter, varargin)
%% 牛顿法求解方程的根，包含简化牛顿法 simplify ，牛顿法 newton ，牛顿加速哈利法 halley ，牛顿下山法 downhill 和重根情形 multi_r 。
% 1. equ_func表示待求（非）线性方程，要求是符号函数定义
% 2. x0表示迭代求解的初值
% 3. varargin  表示可变参数
% 4. 输出参数varargout为可变参数：
% 4.1 如果输出参数为3个，则第1个参数为近似解，第2个参数为近似解的精度误差，第3个参数为退出条件
% 4.2 如果输出参数为2个，则第1个参数为近似解，第2个参数为近似解的精度误差
% 4.3 如果输出参数为1个，则表示牛顿法求解的结构体，包括各种迭代过程中的信息

%% 1.输入参数的判别与处理
if nargin < 2
    error("输入参数不足，请输入完整参数equ_func和x0....")
end

if class(equ_func) ~= "sym"
    error("缺失参数 equ_func 或参数 equ_func 定义错误...")
end

if class(x0) ~= "double"
    error("缺失参数 x0 或参数 x0 定义错误...")
end

args = inputParser; % 函数的输入解析器
addParameter(args, 'method', "newton"); % 设置牛顿法的求解形式，默认值普通newton法
addParameter(args, 'eps', 1e-10); % 设置求解精度参数eps，默认值1e-10
addParameter(args, 'display', 'final'); % 设置是否显示迭代过程参数display，默认值final，可为iter
addParameter(args, 'max_iter', 200); % 设置最大迭代次数参数max_iter，默认值200
parse(args,varargin{:}); % 对输入变量进行解析，如果检测到前面的变量被赋值，则更新变量取值

method = args.Results.method;  % 求解方法
eps = args.Results.eps;  % 若未传参，精度获取默认值
display = args.Results.display;  % 是否显示迭代过程
max_iter = int16(args.Results.max_iter);  % 若未传参，最大迭代次数获取默认值

%% 2. 计算f(x)的一阶导和二阶导函数，并转换为匿名函数
[fx, dfx, d2fx] = solve_diff_fun(equ_func);

%% 3. 根据所采用的求解方法method选择对应的牛顿法形式求解
if lower(method) == "newton"
    method_message = "普通牛顿迭代法";
    iter_info = newton(fx, dfx, x0);  % 普通牛顿法
elseif lower(method) == "halley"
    method_message = "牛顿—哈利迭代法";
    iter_info = newton_halley(fx, dfx, d2fx, x0);  % 牛顿—哈利法
elseif lower(method) == "simplify"
    method_message = "简化的牛顿迭代法";
    iter_info = simplify_newton(fx, dfx, x0);  % 简化牛顿法
elseif lower(method) == "downhill"
    method_message = "牛顿下山迭代法";
    [iter_info, downhill_lambda] = newton_downhill(fx, dfx, x0);  % 牛顿下山法
elseif lower(method) == "multi_r"
    method_message = "牛顿重根情形迭代法";
    iter_info = newton_multi_root(fx, dfx, d2fx, x0);  % 牛顿重根情形
else
    warning("牛顿法仅限于【newton、halley、simple、downhill和multi_r】之一，此处采用牛顿法求解！")
    method_message = "普通牛顿迭代法";
    iter_info = newton(fx, dfx, x0);  % 普通牛顿法
end

%% 4. 根据参数display，显示迭代过程或迭代结果信息
if lower(display) == "iter"
    disp(method_message)
    disp(array2table(iter_info, 'VariableNames', ["IterNums", "ApproximateSol", "ErrorPrecision"]))
elseif lower(display) == "final"
    fprintf(method_message + "：IterNum = %d,  ApproximateSolution = %.15f,  ErrorPrecision = %.15e\n", ...
        iter_info(end, 1), iter_info(end, 2), iter_info(end, 3));
else
    warning("参数display仅限于【iter、final】之一！")
end

%% 2. 1求符号方程的一阶导和二阶导，并转换为匿名函数，方便计算
    function [equ_expr, diff_equ, diff2_equ] = solve_diff_fun(equ)
        x = symvar(equ);    % 获取符号函数的变量
        diff_equ = matlabFunction(diff(equ, x, 1));  % 一阶导数方程，并转换为匿名函数
        diff2_equ = matlabFunction(diff(equ, x, 2));  % 二阶导数方程，并转换为匿名函数
        equ_expr = matlabFunction(equ);  % 原符号方程转换为匿名函数
    end

%% 3. 1 牛顿法求解
    function iter_info = newton(fx, dfx, x0)
        var_iter = 0;  % 迭代次数变量
        sol_tol = fx(x0);  % 方程在当前迭代值的精度，初始为初值时的精度
        if abs(sol_tol) < eps
            iter_info = [1, x0, sol_tol];
            return
        end
        x_cur = x0;  % 迭代过程中的对应于x_(k)
        iter_info =zeros(max_iter, 3);  % 存储迭代过程信息，思考如何预分配内存？

        % 算法具体迭代多少次，不清楚，故用while。可用for循环，在循环体内，满足精度要求退出循环
        while abs(sol_tol) > eps && var_iter < max_iter
            var_iter = var_iter + 1;  % 迭代次数增一
            x_next = x_cur - fx(x_cur) / dfx(x_cur);  % 牛顿迭代公式
            sol_tol = fx(x_next);  % 新值的精度
            x_cur = x_next;  % 近似根的迭代更替
            iter_info(var_iter, :) = [var_iter, x_next, sol_tol];
        end

        if var_iter < max_iter
            iter_info(var_iter + 1:end, :) = [];  % 删除未赋值的区域
        end
    end

%% 3. 2 牛顿—哈利法法求解
    function iter_info = newton_halley(fx, dfx, d2fx, x0)
        var_iter = 0;  % 迭代次数变量
        sol_tol = fx(x0);  % 方程在当前迭代值的精度，初始为初值时的精度
        if abs(sol_tol) < eps
            iter_info = [1, x0, sol_tol];
            return
        end
        x_cur = x0;  % 迭代过程中的对应于x_(k)
        iter_info =zeros(max_iter, 3);  % 存储迭代过程信息

        while abs(sol_tol) > eps && var_iter < max_iter
            var_iter = var_iter + 1;  % 迭代次数增一
            fval = fx(x_cur);  % 当前近似解的方程精度
            df_val = dfx(x_cur);  % 当前近似解的方程一阶导数精度
            d2f_val = d2fx(x_cur);  % 当前近似解的方程二阶导数精度
            x_next = x_cur - fval / df_val / (1 - fval * d2f_val / (2* df_val^2));  % 牛顿哈利迭代公式
            sol_tol = fx(x_next);  % 新值的精度
            x_cur = x_next;  % 近似根的迭代更替
            iter_info(var_iter, :) = [var_iter, x_next, sol_tol];
        end

        if var_iter < max_iter
            iter_info(var_iter + 1:end, :) = [];  % 删除未赋值的区域
        end
    end

%% 3. 3 简化牛顿法求解
    function iter_info = simplify_newton(fx, dfx, x0)
        var_iter = 0;  % 迭代次数变量
        lambda = 1 / dfx(x0);  % 简化牛顿法的常数
        sol_tol = fx(x0);  % 方程在当前迭代值的精度，初始为初值时的精度
        if abs(sol_tol) < eps
            iter_info = [1, x0, sol_tol];
            return
        end
        x_cur = x0;  % 迭代过程中的对应于x_(k)
        iter_info =zeros(max_iter, 3);  % 存储迭代过程信息，思考如何预分配内存？

        while abs(sol_tol) > eps && var_iter < max_iter
            var_iter = var_iter + 1;  % 迭代次数增一
            x_next = x_cur - lambda * fx(x_cur);  % 简化牛顿迭代公式
            sol_tol = fx(x_next);  % 新值的精度
            x_cur = x_next;  % 近似根的迭代更替
            iter_info(var_iter, :) = [var_iter, x_next, sol_tol];
        end

        if var_iter < max_iter
            iter_info(var_iter + 1:end, :) = [];  % 删除未赋值的区域
        end
    end

%% 3. 4 牛顿下山法求解
    function [iter_info, downhill_lambda] = newton_downhill(fx, dfx, x0)
        var_iter = 0;  % 迭代次数变量
        sol_tol = fx(x0);  % 方程在当前迭代值的精度，初始为初值时的精度
        if abs(sol_tol) < eps
            iter_info = [1, x0, sol_tol];
            downhill_lambda = 1;
            return
        end
        x_cur = x0;  % 迭代过程中的对应于x_(k)
        iter_info =zeros(max_iter, 3);  % 存储迭代过程信息，思考如何预分配内存？
        downhill_lambda = ones(max_iter);  % 存储下山因子

        while abs(sol_tol) > eps && var_iter < max_iter
            var_iter = var_iter + 1;  % 迭代次数增一
            f_val = fx(x_cur);  % 当前近似解的方程精度
            df_val = dfx(x_cur);  % 当前近似解的方程一阶导数精度
            x_next = x_cur - f_val / df_val;  % 牛顿迭代公式
            sol_tol = fx(x_next);  % 新值的精度

            % 判别是否满足下降条件
            while abs(sol_tol) > abs(f_val)
                downhill_lambda(var_iter) = downhill_lambda(var_iter) / 2;  % 下山因子减半
                x_next = x_cur - downhill_lambda(var_iter) * f_val / df_val;  % 牛顿下山迭代公式
                sol_tol = fx(x_next);  % 新值的精度
            end

            x_cur = x_next;  % 近似根的迭代更替
            iter_info(var_iter, :) = [var_iter, x_next, sol_tol];
        end

        if var_iter < max_iter
            iter_info(var_iter + 1:end, :) = [];  % 删除未赋值的区域
            downhill_lambda(var_iter + 1:end) = [];  % 删除未赋值的区域
        end
    end

%% 3. 5 牛顿法重根情形求解
    function iter_info = newton_multi_root(fx, dfx,d2fx, x0)
        var_iter = 0;  % 迭代次数变量
        sol_tol = fx(x0);  % 方程在当前迭代值的精度，初始为初值时的精度
        if abs(sol_tol) < eps
            iter_info = [1, x0, sol_tol];
            return
        end
        x_cur = x0;  % 迭代过程中的对应于x_(k)
        iter_info =zeros(max_iter, 3);  % 存储迭代过程信息，思考如何预分配内存？

        while abs(sol_tol) > eps && var_iter < max_iter
            var_iter = var_iter + 1;  % 迭代次数增一
            fval = fx(x_cur);  % 当前近似解的方程精度
            df_val = dfx(x_cur);  % 当前近似解的方程一阶导数精度
            d2f_val = d2fx(x_cur);  % 当前近似解的方程二阶导数精度
            x_next = x_cur -fval * df_val / (df_val^2 - fval * d2f_val);  % 牛顿重根情形迭代公式
            sol_tol = fx(x_next);  % 新值的精度
            x_cur = x_next;  % 近似根的迭代更替
            iter_info(var_iter, :) = [var_iter, x_next, sol_tol];
        end

        if var_iter < max_iter
            iter_info(var_iter + 1:end, :) = [];  % 删除未赋值的区域
        end
    end

%% 5. 输出参数结构体的构造
sol.ApproximateSolution = iter_info(end, 2);  % 数值近似解
sol.ErrorPrecision =iter_info(end, 3);  % 数值近似解误差
sol.NumerOfIterations = iter_info(end, 1);  % 迭代次数
sol.NewtonMethod = method;  % 所采用的方法
sol.IntrationProcessInfomation = iter_info;  % 迭代过程信息
if length(iter_info) == max_iter
    sol.info = "已达最大迭代次数";
end
if length(iter_info) < max_iter
    sol.convergence = "收敛到满足精度的近似解";
else
    sol.convergence = "精度过高，或未收敛到满足精度的解，增大迭代次数或修改初值或降低精度要求";
end
if lower(method) == "downhill"
    sol.DownhillLambda = downhill_lambda;
end

%% 6. 输出参数的判别
if nargout == 3
    varargout{1} = iter_info(end, 2);
    varargout{2} = iter_info(end, 3);
    if length(iter_info) == max_iter
        varargout{3} = 0;  % 退出标记
    else
        varargout{3} = 1; % 退出标记
    end
elseif nargout == 2
    varargout{1} = iter_info(end, 2);
    varargout{2} = iter_info(end, 3);
elseif nargout == 1
    varargout{1} = sol;
elseif nargout == 0
	 varargout{1} = iter_info(end, 2); % 仅给出近似解
else
    error("输出参数最多为3个....")
end
end