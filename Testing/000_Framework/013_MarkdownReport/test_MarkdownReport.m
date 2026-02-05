% test_MarkdownReport - Test script for MarkdownReport class
% This script demonstrates the functionality of the MarkdownReport class
% by creating a comprehensive example report

fprintf('=== MarkdownReport Test Script ===\n\n');

%% Test 1: Basic Report Creation
fprintf('Test 1: Basic Report Creation\n');
fprintf('---------------------------\n');

report = MarkdownReport(...
    'title', '工程分析报告 / Engineering Analysis Report', ...
    'author', 'Xie Yu', ...
    'filename', 'test_report.md', ...
    'imageDir', 'images' ...
);

fprintf('Report created successfully!\n\n');

%% Test 2: Adding Headings
fprintf('Test 2: Adding Headings\n');
fprintf('---------------------\n');

report = report.addTitle('项目概述', 2);
report = report.addTitle('Project Overview', 3);

fprintf('Headings added successfully!\n\n');

%% Test 3: Adding Paragraphs
fprintf('Test 3: Adding Paragraphs\n');
fprintf('------------------------\n');

report = report.addParagraph(...
    '本报告演示了 MarkdownReport 类的基本功能。'...
);
report = report.addParagraph({...
    'This report demonstrates the basic functionality of the MarkdownReport class.', ...
    '支持中文和英文混排。', ...
    'Supports mixed Chinese and English text.' ...
});

fprintf('Paragraphs added successfully!\n\n');

%% Test 4: Adding Tables
fprintf('Test 4: Adding Tables\n');
fprintf('---------------------\n');

% Test 4.1: Table from MATLAB table
dataTable = table(...
    [1.23; 4.56; 7.89], ...
    [10; 20; 30], ...
    [100; 200; 300], ...
    'VariableNames', {'Parameter', 'Value', 'Unit'} ...
);
report = report.addTitle('数据表 / Data Table', 2);
report = report.addTable(dataTable, 'Test data table');

% Test 4.2: Table from struct
paramsStruct = struct(...
    'Material', 'Steel', ...
    'Thickness', 30, ...
    'Length', 1000, ...
    'Width', 500 ...
);
report = report.addTitle('参数表 / Parameters', 2);
report = report.addTableFromStruct(paramsStruct, '参数 / Parameter', '值 / Value');

% Test 4.3: Custom table
report = report.addTitle('自定义表 / Custom Table', 2);
headers = {'Name', 'Value', 'Unit'};
data = {'Test1', 10.5, 'mm'; 'Test2', 20.3, 'mm'; 'Test3', 30.7, 'mm'};
alignments = {':---', ':---:', '---:'};
report = report.addCustomTable(headers, data, alignments, 'Custom alignment table');

fprintf('Tables added successfully!\n\n');

%% Test 5: Adding Lists
fprintf('Test 5: Adding Lists\n');
fprintf('-------------------\n');

report = report.addTitle('列表 / Lists', 2);

% Unordered list
unorderedItems = {...
    'First item / 第一项', ...
    'Second item / 第二项', ...
    'Third item / 第三项' ...
};
report = report.addList(unorderedItems, false);

% Ordered list
orderedItems = {...
    'Step 1: Initialize / 步骤1：初始化', ...
    'Step 2: Process / 步骤2：处理', ...
    'Step 3: Output / 步骤3：输出' ...
};
report = report.addList(orderedItems, true);

fprintf('Lists added successfully!\n\n');

%% Test 6: Adding Formatting
fprintf('Test 6: Adding Text Formatting\n');
fprintf('----------------------------\n');

report = report.addTitle('文本格式 / Text Formatting', 2);
report = report.addBold('这是粗体文本 / This is bold text');
report = report.addItalic('这是斜体文本 / This is italic text');
report = report.addInlineCode('inline code');

fprintf('Text formatting added successfully!\n\n');

%% Test 7: Adding Code Blocks
fprintf('Test 7: Adding Code Blocks\n');
fprintf('--------------------------\n');

report = report.addTitle('代码块 / Code Block', 2);
report = report.addCodeBlock({...
    '% This is a MATLAB code example', ...
    'x = 1:10;', ...
    'y = sin(x);', ...
    'plot(x, y);' ...
}, 'matlab');

fprintf('Code blocks added successfully!\n\n');

%% Test 8: Adding Quotes
fprintf('Test 8: Adding Quotes\n');
fprintf('---------------------\n');

report = report.addTitle('引用 / Quote', 2);
report = report.addQuote('这是一个引用块 / This is a blockquote');

fprintf('Quotes added successfully!\n\n');

%% Test 9: Adding Images from Rplot
fprintf('Test 9: Adding Images from Rplot\n');
fprintf('--------------------------------\n');

report = report.addTitle('图形 / Figures', 2);

% Create a simple Rplot
x = 1:10;
y = sin(x);
g = Rplot('x', x, 'y', y);
g = geom_line(g);
g = set_title(g, 'Sine Wave  正弦波');
figure('Position',[100 100 800 400]);
draw(g);

% Add Rplot image to report
[report, imagePath] = report.addImageFromRplot(g, '正弦波图 / Sine wave plot', ...
    'filename', 'sine_wave', 'format', 'png');

fprintf('Rplot image added: %s\n', imagePath);
close(gcf);

%% Test 10: Adding Images from MATLAB Figure
fprintf('\nTest 10: Adding Images from MATLAB Figure\n');
fprintf('-----------------------------------------\n');

% Create another figure
x2 = 0:0.1:2*pi;
y2 = cos(x2);
fig = figure('Name', 'Cosine Wave');
plot(x2, y2, 'LineWidth', 2);
xlabel('x');
ylabel('cos(x)');
title('Cosine Wave / 余弦波');
grid on;

% Add figure to report
[report, imagePath2] = report.addImageFromFigure(fig, '余弦波图 / Cosine wave plot', ...
    'filename', 'cosine_wave', 'format', 'png', 'resolution', 300);

fprintf('MATLAB figure image added: %s\n', imagePath2);
close(fig);

%% Test 11: Horizontal Rule
fprintf('\nTest 11: Adding Horizontal Rule\n');
fprintf('--------------------------------\n');

report = report.addHorizontalRule();

fprintf('Horizontal rule added successfully!\n\n');

%% Test 12: Preview and Export
fprintf('Test 12: Preview and Export\n');
fprintf('----------------------------\n');

% Preview report (first 30 lines)
report.preview(30);

% Get report statistics
fprintf('\nReport Statistics:\n');
fprintf('  Total lines: %d\n', report.getLength());
fprintf('  Image count: %d\n', report.imageCounter);

% Export report
fprintf('\nExporting report...\n');
report.export();

fprintf('\nReport exported successfully!\n');
fprintf('Output file: test_report.md\n');
fprintf('Image directory: images/\n\n');

%% Test 13: Test Static Methods
fprintf('Test 13: Testing Static Methods\n');
fprintf('--------------------------------\n');

% Test structToMarkdown
testStruct = struct('A', 1.23, 'B', 4.56, 'C', 7.89);
mdTable = MarkdownReport.structToMarkdown(testStruct, 'Example Table');
fprintf('Generated Markdown Table:\n%s', mdTable);

%% Test 14: Test Chain Method Calling
fprintf('\nTest 14: Testing Method Chaining\n');
fprintf('--------------------------------\n');

chainedReport = MarkdownReport('title', 'Method Chaining Test', 'filename', 'chained_test.md');
chainedReport = chainedReport.addTitle('Section 1', 2) ...
    .addParagraph('First paragraph.') ...
    .addHorizontalRule() ...
    .addTitle('Section 2', 2) ...
    .addParagraph('Second paragraph.');

fprintf('Method chaining test passed!\n');
fprintf('Chained report lines: %d\n', chainedReport.getLength());

chainedReport.export();

fprintf('\n=== All Tests Completed Successfully ===\n\n');
fprintf('Generated files:\n');
fprintf('  - test_report.md\n');
fprintf('  - chained_test.md\n');
fprintf('  - images/sine_wave.png\n');
fprintf('  - images/cosine_wave.png\n');
