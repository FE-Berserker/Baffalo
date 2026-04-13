% 测试从matlab中调用python
rootDir = Baffalo.whereami;
sen=strcat(rootDir,"\.venv\Scripts\activate.bat");
dos(sen);
sen1=strcat(rootDir,"\.venv\Scripts\python.exe");
eng = pyenv(Version=sen1);

%% 验证 Python 环境
fprintf('=== Python 环境验证 ===\n');

% 检查 pyenv 配置
fprintf('Python 路径: %s\n', eng.Version);
fprintf('Python 位置: %s\n', eng.Home);