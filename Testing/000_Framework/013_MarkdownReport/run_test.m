% Simple test for MarkdownReport class
% addpath(fullfile(pwd, '@MarkdownReport'));

fprintf('=== MarkdownReport Quick Test ===\n');

% Test 1: Create a simple report
report = MarkdownReport('title', 'Test Report', 'author', 'Xie Yu', 'filename', 'quick_test.md');
fprintf('Report created: %s\n', class(report));

% Test 2: Add content
report = report.addTitle('Section 1', 2);
report = report.addParagraph('This is a test paragraph.');
report = report.addHorizontalRule();
fprintf('Content added.\n');

% Test 3: Add table
params = struct('Material', 'Steel', 'Thickness', 30);
report = report.addTableFromStruct(params, 'Parameter', 'Value');
fprintf('Table added.\n');

% Test 4: Export
report.export();
fprintf('Report exported: quick_test.md\n');

fprintf('=== Test Complete ===\n');
