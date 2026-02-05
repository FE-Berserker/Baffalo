classdef MarkdownReport
    % MarkdownReport - Base class for generating Markdown format technical reports
    % This class provides methods to create structured Markdown reports with
    % support for headings, tables, images, lists, and code blocks
    %
    % Author: Xie Yu
    %
    % Example:
    %   report = MarkdownReport('title', 'Engineering Report', 'filename', 'report.md');
    %   report = report.addTitle('Summary', 2);
    %   report = report.addParagraph('This is a summary.');
    %   report.export();

    properties
        % Report content (cell array of strings)
        content

        % Report title
        title

        % Report author
        author

        % Report date
        date

        % Output file path
        filepath

        % Output file name
        filename

        % Image directory (default 'images')
        imageDir

        % Image counter for automatic numbering
        imageCounter

        % Table formatting options
        tableFormat

        % Auto number images (default true)
        autoNumberImages

        % Auto save on export (default false)
        autoSave
    end

    properties (Hidden, Constant)
        % Markdown heading markers
        HEADING1 = '#';
        HEADING2 = '##';
        HEADING3 = '###';
        HEADING4 = '####';
        HEADING5 = '#####';

        % Markdown structural elements
        HORIZONTAL_RULE = '---';
        BOLD_MARKER = '**';
        ITALIC_MARKER = '*';
        CODE_MARKER = '`';

        % Table alignment markers
        ALIGN_LEFT = ':---';
        ALIGN_CENTER = ':---:';
        ALIGN_RIGHT = '---:';
    end

    methods
        function obj = MarkdownReport(varargin)
            % MarkdownReport - Constructor for the Markdown report class
            %
            % Syntax:
            %   report = MarkdownReport()
            %   report = MarkdownReport('title', 'My Report')
            %   report = MarkdownReport('title', 'My Report', 'author', 'Xie Yu', 'filename', 'report.md')
            %
            % Parameters:
            %   'title'     - Report title
            %   'author'    - Report author
            %   'date'      - Report date (default: current date)
            %   'filepath'  - Output file path
            %   'filename'  - Output file name
            %   'imageDir'  - Image directory (default: 'images')
            %   'autoNumberImages' - Auto number images (default: true)
            %   'autoSave'  - Auto save on export (default: false)

            % Initialize properties with defaults
            obj.content = {};
            obj.title = '';
            obj.author = '';
            obj.date = datestr(now, 'yyyy-mm-dd');
            obj.filepath = '';
            obj.filename = 'report.md';
            obj.imageDir = 'images';
            obj.imageCounter = 0;
            obj.tableFormat = struct('precision', 4, 'align', 'left');
            obj.autoNumberImages = true;
            obj.autoSave = false;

            % Parse input arguments using inputParser
            p = inputParser;
            addParameter(p, 'title', '', @ischar);
            addParameter(p, 'author', '', @ischar);
            addParameter(p, 'date', obj.date, @ischar);
            addParameter(p, 'filepath', '', @ischar);
            addParameter(p, 'filename', 'report.md', @ischar);
            addParameter(p, 'imageDir', 'images', @ischar);
            addParameter(p, 'autoNumberImages', true, @logical);
            addParameter(p, 'autoSave', false, @logical);

            parse(p, varargin{:});
            opt = p.Results;

            % Set properties from parsed options
            obj.title = opt.title;
            obj.author = opt.author;
            obj.date = opt.date;
            obj.filepath = opt.filepath;
            obj.filename = opt.filename;
            obj.imageDir = opt.imageDir;
            obj.autoNumberImages = opt.autoNumberImages;
            obj.autoSave = opt.autoSave;

            % Add report header if title is provided
            if ~isempty(obj.title)
                obj = obj.addTitle(obj.title, 1);
                if ~isempty(obj.author)
                    obj = obj.addParagraph(['**Author:** ' obj.author]);
                end
                obj = obj.addParagraph(['**Date:** ' obj.date]);
                obj = obj.addHorizontalRule();
            end
        end
    end

    % Content addition methods
    methods
        function obj = addTitle(obj, titleText, level)
            % addTitle - Add a heading to the report
            %
            % Parameters:
            %   titleText - The heading text
            %   level - Heading level (1-5, default: 1)
            %
            % Returns:
            %   obj - The report object for method chaining

            if nargin < 3
                level = 1;
            end

            % Validate level
            if level < 1 || level > 5
                error('Heading level must be between 1 and 5');
            end

            % Get the appropriate heading marker
            switch level
                case 1
                    marker = obj.HEADING1;
                case 2
                    marker = obj.HEADING2;
                case 3
                    marker = obj.HEADING3;
                case 4
                    marker = obj.HEADING4;
                case 5
                    marker = obj.HEADING5;
            end

            % Add heading to content
            obj.content{end+1} = [marker ' ' titleText];
            obj.content{end+1} = ''; % Empty line after heading
        end

        function obj = addParagraph(obj, text)
            % addParagraph - Add paragraph text to the report
            %
            % Parameters:
            %   text - Text content (string or cell array of strings)
            %
            % Returns:
            %   obj - The report object for method chaining

            if iscell(text)
                % Add each line in cell array
                for i = 1:length(text)
                    obj.content{end+1} = text{i};
                end
            else
                % Add single line
                obj.content{end+1} = text;
            end
            obj.content{end+1} = ''; % Empty line after paragraph
        end

        function obj = addHorizontalRule(obj)
            % addHorizontalRule - Add a horizontal rule to the report
            %
            % Returns:
            %   obj - The report object for method chaining

            obj.content{end+1} = obj.HORIZONTAL_RULE;
            obj.content{end+1} = '';
        end

        function obj = addList(obj, items, isOrdered)
            % addList - Add a list to the report
            %
            % Parameters:
            %   items - Cell array of list items
            %   isOrdered - Whether the list is ordered (default: false)
            %
            % Returns:
            %   obj - The report object for method chaining

            if nargin < 3
                isOrdered = false;
            end

            % Add each list item
            for i = 1:length(items)
                if isOrdered
                    obj.content{end+1} = [num2str(i) '. ' items{i}];
                else
                    obj.content{end+1} = ['- ' items{i}];
                end
            end
            obj.content{end+1} = '';
        end

        function obj = addBold(obj, text)
            % addBold - Add bold text to the report
            %
            % Parameters:
            %   text - Text to make bold
            %
            % Returns:
            %   obj - The report object for method chaining

            obj.content{end+1} = [obj.BOLD_MARKER text obj.BOLD_MARKER];
            obj.content{end+1} = '';
        end

        function obj = addItalic(obj, text)
            % addItalic - Add italic text to the report
            %
            % Parameters:
            %   text - Text to make italic
            %
            % Returns:
            %   obj - The report object for method chaining

            obj.content{end+1} = [obj.ITALIC_MARKER text obj.ITALIC_MARKER];
            obj.content{end+1} = '';
        end

        function obj = addCodeBlock(obj, code, language)
            % addCodeBlock - Add a code block with syntax highlighting
            %
            % Parameters:
            %   code - Code content (string or cell array)
            %   language - Language identifier (default: 'matlab')
            %
            % Returns:
            %   obj - The report object for method chaining

            if nargin < 3
                language = 'matlab';
            end

            % Add code block opening with language identifier
            obj.content{end+1} = ['```' language];

            % Add code lines
            if iscell(code)
                for i = 1:length(code)
                    obj.content{end+1} = code{i};
                end
            else
                obj.content{end+1} = code;
            end

            % Add code block closing
            obj.content{end+1} = '```';
            obj.content{end+1} = '';
        end

        function obj = addInlineCode(obj, text)
            % addInlineCode - Add inline code to the report
            %
            % Parameters:
            %   text - Text to format as inline code
            %
            % Returns:
            %   obj - The report object for method chaining

            obj.content{end+1} = [obj.CODE_MARKER text obj.CODE_MARKER];
        end

        function obj = addQuote(obj, text)
            % addQuote - Add a blockquote to the report
            %
            % Parameters:
            %   text - Text to quote
            %
            % Returns:
            %   obj - The report object for method chaining

            if iscell(text)
                for i = 1:length(text)
                    obj.content{end+1} = ['> ' text{i}];
                end
            else
                obj.content{end+1} = ['> ' text];
            end
            obj.content{end+1} = '';
        end
    end

    % Table methods
    methods
        function obj = addTable(obj, matlabTable, caption)
            % addTable - Add a MATLAB table to the report
            %
            % Parameters:
            %   matlabTable - MATLAB table object
            %   caption - Table caption (optional)
            %
            % Returns:
            %   obj - The report object for method chaining

            if nargin < 3
                caption = '';
            end

            % Get table properties
            varNames = matlabTable.Properties.VariableNames;
            nRows = height(matlabTable);
            nCols = width(matlabTable);

            % Create header row
            header = '| ';
            for i = 1:nCols
                header = [header varNames{i} ' | '];
            end
            obj.content{end+1} = header;

            % Create alignment row (default left alignment)
            align = '| ';
            for i = 1:nCols
                align = [align obj.ALIGN_LEFT ' | '];
            end
            obj.content{end+1} = align;

            % Create data rows
            for i = 1:nRows
                row = '| ';
                for j = 1:nCols
                    value = matlabTable{i, j};
                    if isnumeric(value)
                        % Format numeric values
                        if isscalar(value)
                            rowStr = sprintf('%.4g', value);
                        else
                            rowStr = mat2str(value, obj.tableFormat.precision);
                        end
                    else
                        rowStr = char(value);
                    end
                    row = [row rowStr ' | '];
                end
                obj.content{end+1} = row;
            end

            % Add caption if provided
            if ~isempty(caption)
                obj.content{end+1} = ['**Table:** ' caption];
            end

            obj.content{end+1} = '';
        end

        function obj = addTableFromStruct(obj, structData, keyLabel, valueLabel)
            % addTableFromStruct - Add a table from struct key-value pairs
            %
            % Parameters:
            %   structData - Structure with data
            %   keyLabel - Label for key column (default: 'Parameter')
            %   valueLabel - Label for value column (default: 'Value')
            %
            % Returns:
            %   obj - The report object for method chaining

            if nargin < 3
                keyLabel = 'Parameter';
            end
            if nargin < 4
                valueLabel = 'Value';
            end

            % Get struct fields
            fields = fieldnames(structData);
            nFields = length(fields);

            % Create header row
            obj.content{end+1} = ['| ' keyLabel ' | ' valueLabel ' |'];
            obj.content{end+1} = ['| ' obj.ALIGN_LEFT ' | ' obj.ALIGN_LEFT ' |'];

            % Create data rows
            for i = 1:nFields
                key = fields{i};
                value = structData.(key);

                if isnumeric(value)
                    if isscalar(value)
                        valueStr = sprintf('%.4g', value);
                    else
                        valueStr = mat2str(value, obj.tableFormat.precision);
                    end
                else
                    valueStr = char(value);
                end

                obj.content{end+1} = ['| ' key ' | ' valueStr ' |'];
            end

            obj.content{end+1} = '';
        end

        function obj = addCustomTable(obj, headers, data, alignments, caption)
            % addCustomTable - Add a custom table to the report
            %
            % Parameters:
            %   headers - Cell array of column headers
            %   data - Cell array or matrix of data (rows x cols)
            %   alignments - Cell array of alignment markers (optional, default: all left)
            %   caption - Table caption (optional)
            %
            % Returns:
            %   obj - The report object for method chaining

            if nargin < 4
                alignments = {};
            end
            if nargin < 5
                caption = '';
            end

            % Ensure data is a cell array
            if isnumeric(data)
                data = num2cell(data);
            end

            nCols = length(headers);
            nRows = size(data, 1);

            % Set default alignments if not provided
            if isempty(alignments)
                alignments = repmat({obj.ALIGN_LEFT}, 1, nCols);
            end

            % Create header row
            header = '| ';
            for i = 1:nCols
                header = [header headers{i} ' | '];
            end
            obj.content{end+1} = header;

            % Create alignment row
            align = '| ';
            for i = 1:nCols
                if i <= length(alignments)
                    align = [align alignments{i} ' | '];
                else
                    align = [align obj.ALIGN_LEFT ' | '];
                end
            end
            obj.content{end+1} = align;

            % Create data rows
            for i = 1:nRows
                row = '| ';
                for j = 1:nCols
                    value = data{i, j};
                    if isnumeric(value)
                        if isscalar(value)
                            rowStr = sprintf('%.4g', value);
                        else
                            rowStr = mat2str(value, obj.tableFormat.precision);
                        end
                    else
                        rowStr = char(value);
                    end
                    row = [row rowStr ' | '];
                end
                obj.content{end+1} = row;
            end

            % Add caption if provided
            if ~isempty(caption)
                obj.content{end+1} = ['**Table:** ' caption];
            end

            obj.content{end+1} = '';
        end
    end

    % Image methods
    methods
        function [obj, imagePath] = addImage(obj, imagePath, caption, altText)
            % addImage - Add an image link to the report
            %
            % Parameters:
            %   imagePath - Path to the image file (relative or absolute)
            %   caption - Image caption (optional)
            %   altText - Alt text for the image (optional)
            %
            % Returns:
            %   obj - The report object for method chaining
            %   imagePath - The image path used in the markdown

            if nargin < 3
                caption = '';
            end
            if nargin < 4
                altText = '';
            end

            % Set default alt text
            if isempty(altText)
                altText = 'Image';
            end

            % Auto-number image if enabled
            if obj.autoNumberImages
                obj.imageCounter = obj.imageCounter + 1;
                figureCaption = sprintf('**Figure %d:** %s', obj.imageCounter, caption);
            else
                figureCaption = caption;
            end

            % Add image to content
            obj.content{end+1} = ['![' altText '](' imagePath ')'];

            % Add caption if provided
            if ~isempty(caption)
                obj.content{end+1} = figureCaption;
            end

            obj.content{end+1} = '';
        end

        function [obj, imagePath] = addImageFromRplot(obj, rplotObj, caption, varargin)
            % addImageFromRplot - Save Rplot figure and add to report
            %
            % Parameters:
            %   rplotObj - Rplot object
            %   caption - Image caption
            %   varargin - Additional options:
            %       'filename' - Custom filename (without extension)
            %       'format' - Image format (default: 'png')
            %       'resolution' - Image resolution (default: 'screen')
            %
            % Returns:
            %   obj - The report object for method chaining
            %   imagePath - The image path used in the markdown

            % Parse options
            p = inputParser;
            addParameter(p, 'filename', '', @ischar);
            addParameter(p, 'format', 'png', @ischar);
            addParameter(p, 'resolution', 'screen', @ischar);
            parse(p, varargin{:});
            opt = p.Results;

            % Create image directory if it doesn't exist
            if ~isempty(obj.imageDir)
                try
                    mkdir(obj.imageDir);
                catch
                    % Directory may already exist, ignore error
                end
            end

            % Generate filename if not provided
            if isempty(opt.filename)
                if obj.autoNumberImages
                    % Pre-calculate the next counter value for filename
                    nextCounter = obj.imageCounter + 1;
                    opt.filename = ['figure_' num2str(nextCounter)];
                else
                    opt.filename = ['figure_' datestr(now, 'yyyymmdd_HHMMSS')];
                end
            end

            % Build full image path (using forward slashes for Markdown compatibility)
            imagePath = strrep(fullfile(obj.imageDir, [opt.filename '.' opt.format]), '\', '/');

            % Save Rplot image
            rplotObj.save_image('filename', imagePath, 'format', opt.format, ...
                                'resolution', opt.resolution);

            % Add image to report
            obj = obj.addImage(imagePath, caption);
        end

        function [obj, imagePath] = addImageFromFigure(obj, figHandle, caption, varargin)
            % addImageFromFigure - Save MATLAB figure and add to report
            %
            % Parameters:
            %   figHandle - Figure handle (default: current figure)
            %   caption - Image caption
            %   varargin - Additional options:
            %       'filename' - Custom filename (without extension)
            %       'format' - Image format (default: 'png')
            %       'resolution' - Image resolution in DPI (default: 300)
            %
            % Returns:
            %   obj - The report object for method chaining
            %   imagePath - The image path used in the markdown

            if nargin < 3
                caption = '';
            end
            if nargin < 2 || isempty(figHandle)
                figHandle = gcf;
            end

            % Parse options
            p = inputParser;
            addParameter(p, 'filename', '', @ischar);
            addParameter(p, 'format', 'png', @ischar);
            addParameter(p, 'resolution', 300, @isnumeric);
            parse(p, varargin{:});
            opt = p.Results;

            % Create image directory if it doesn't exist
            if ~isempty(obj.imageDir)
                try
                    mkdir(obj.imageDir);
                catch
                    % Directory may already exist, ignore error
                end
            end

            % Generate filename if not provided
            if isempty(opt.filename)
                if obj.autoNumberImages
                    % Pre-calculate the next counter value for filename
                    nextCounter = obj.imageCounter + 1;
                    opt.filename = ['figure_' num2str(nextCounter)];
                else
                    opt.filename = ['figure_' datestr(now, 'yyyymmdd_HHMMSS')];
                end
            end

            % Build full image path (using forward slashes for Markdown compatibility)
            imagePath = strrep(fullfile(obj.imageDir, [opt.filename '.' opt.format]), '\', '/');

            % Save figure
            dpiStr = ['-r' num2str(opt.resolution)];
            print(figHandle, imagePath, ['-d' opt.format], dpiStr);

            % Add image to report
            obj = obj.addImage(imagePath, caption);
        end
    end

    % Report generation methods
    methods
        function contentStr = getContent(obj)
            % getContent - Get the report content as a string
            %
            % Returns:
            %   contentStr - The full report content as a string

            contentStr = '';
            for i = 1:length(obj.content)
                if i == 1
                    contentStr = obj.content{i};
                else
                    contentStr = [contentStr newline obj.content{i}];
                end
            end
        end

        function preview(obj, numLines)
            % preview - Preview the report in the command window
            %
            % Parameters:
            %   numLines - Number of lines to preview (default: all lines)

            if nargin < 2
                numLines = length(obj.content);
            end

            fprintf('=== Report Preview ===\n');
            nLines = min(numLines, length(obj.content));
            for i = 1:nLines
                fprintf('%s\n', obj.content{i});
            end
            fprintf('=====================\n');
        end

        function export(obj, filepath)
            % export - Export the report to a Markdown file
            %
            % Parameters:
            %   filepath - Output file path (optional, uses obj.filename if not provided)

            % Determine output file path
            if nargin >= 2 && ~isempty(filepath)
                outputFilename = filepath;
            else
                if ~isempty(obj.filepath)
                    outputFilename = fullfile(obj.filepath, obj.filename);
                else
                    outputFilename = obj.filename;
                end
            end

            % Get content string
            contentStr = obj.getContent();

            % Write to file
            fid = fopen(outputFilename, 'w', 'n', 'UTF-8');
            if fid == -1
                error('Failed to open file for writing: %s', outputFilename);
            end
            fprintf(fid, '%s', contentStr);
            fclose(fid);

            fprintf('Report exported successfully: %s\n', outputFilename);
        end

        function obj = clear(obj)
            % clear - Clear all content from the report
            %
            % Returns:
            %   obj - The cleared report object

            obj.content = {};
            obj.imageCounter = 0;

            % Re-add header if title exists
            if ~isempty(obj.title)
                obj = obj.addTitle(obj.title, 1);
                if ~isempty(obj.author)
                    obj = obj.addParagraph(['**Author:** ' obj.author]);
                end
                obj = obj.addParagraph(['**Date:** ' obj.date]);
                obj = obj.addHorizontalRule();
            end
        end
    end

    % Utility methods
    methods
        function len = getLength(obj)
            % getLength - Get the number of content lines in the report
            %
            % Returns:
            %   len - Number of content lines

            len = length(obj.content);
        end

        function obj = merge(obj, otherReport)
            % merge - Merge another report's content into this report
            %
            % Parameters:
            %   otherReport - Another MarkdownReport object to merge
            %
            % Returns:
            %   obj - The merged report object

            % Add a horizontal rule separator
            obj = obj.addHorizontalRule();

            % Append other report's content (skip header lines)
            % Skip first few lines which are typically header
            contentToMerge = otherReport.content;
            startIndex = 1;

            % Try to skip header lines
            for i = 1:min(10, length(contentToMerge))
                if ~isempty(contentToMerge{i}) && startsWith(contentToMerge{i}, '#')
                    startIndex = i;
                end
            end

            % Append content
            for i = startIndex:length(contentToMerge)
                obj.content{end+1} = contentToMerge{i};
            end
        end
    end

    % Static methods
    methods (Static)
        function report = createFromTemplate(title, templatePath)
            % createFromTemplate - Create a report from a template file
            %
            % Parameters:
            %   title - Report title
            %   templatePath - Path to the template file
            %
            % Returns:
            %   report - A new MarkdownReport object with template content

            % Create new report
            report = MarkdownReport('title', title);

            % Read template file
            if ~exist(templatePath, 'file')
                error('Template file not found: %s', templatePath);
            end

            fid = fopen(templatePath, 'r', 'n', 'UTF-8');
            if fid == -1
                error('Failed to open template file: %s', templatePath);
            end

            % Read template content
            contentLines = textscan(fid, '%s', 'Delimiter', '\n');
            fclose(fid);

            % Append template content (skip existing header from constructor)
            for i = 1:length(contentLines{1})
                report.content{end+1} = contentLines{1}{i};
            end
        end

        function markdownTable = structToMarkdown(structData, title)
            % structToMarkdown - Convert a structure to a Markdown table string
            %
            % Parameters:
            %   structData - Structure with data
            %   title - Table title (optional)
            %
            % Returns:
            %   markdownTable - Markdown table as a string

            if nargin < 2
                title = '';
            end

            % Get struct fields
            fields = fieldnames(structData);
            nFields = length(fields);

            % Build markdown table
            markdownTable = '| Parameter | Value |\n';
            markdownTable = [markdownTable '| :--- | :--- |\n'];

            for i = 1:nFields
                key = fields{i};
                value = structData.(key);

                if isnumeric(value)
                    if isscalar(value)
                        valueStr = sprintf('%.4g', value);
                    else
                        valueStr = mat2str(value, 4);
                    end
                else
                    valueStr = char(value);
                end

                markdownTable = [markdownTable '| ' key ' | ' valueStr ' |\n'];
            end

            % Add title if provided
            if ~isempty(title)
                markdownTable = ['**Table:** ' title '\n\n' markdownTable];
            end
        end
    end
end
