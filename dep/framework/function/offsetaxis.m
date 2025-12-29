function varargout = offsetaxis(hax, varargin)
%OFFSETAXIS Add an x- or y-axis offset from the plotted axis area
%
% offsetaxis(ax);
% offsetaxis(ax, p1, v1, ...);
% [hy, hx] = offsetaxis(ax, ...);
%
% This function shifts the x- and/or y-axis to a position offset from the
% true plotting region of an axis.  It achieves this appearance by creating
% a second, mostly-hidden-except-for-the-axis-line axis that is linked to
% the original axis.
%
% Note for pre-HG2 graphics versions of Matlab (pre-R2014b): one cannot
% completely hide an axis line, so instead this function matches the
% original axis line colors to its parent object (the figure or a uipanel)
% color, mostly hiding it.  This color will need to be re-synced manually
% if you later change that color.
%
% Input variables:
%
%   ax:     axis handle(s), can be any dimensions
%
% Optional input variables, passed as parameter/value pairs [default]
%
%   y:      offset for the y-axis, expressed as a fraction of the
%           axis width.
%           [0.1 if no x-offset is specified, 0 otherwise]
%
%   x:      offset for the x-axis, expressed as a fraction of the axis
%           height.
%           [0]
%
%   yloc:   string, location for offset y-axis.
%           'l':    left
%           'r':    right
%           'lr':   both
%           ['l']
%
%   xloc:   string, location for offset x-axis.
%           't':    top
%           'b':    bottom
%           'tb':   both
%           ['b']
%
% Output variables:
%
%   hy:     handles to offset y-axes, same dimensions as ax input (only
%           returned if a y-offset is specified by input)
%
%   hx:     handles to offset x-axes, same dimensions as ax input (only
%           returned if an x-offset is specified by input)

% Copyright 2017 Kelly Kearney

% Parse input

p = inputParser;
p.addParameter('y', 0, @(x) validateattributes(x, {'numeric'}, {'scalar', 'nonnegative'}));
p.addParameter('x', 0, @(x) validateattributes(x, {'numeric'}, {'scalar', 'nonnegative'}));
p.addParameter('yloc', 'l', @(x) validateattributes(x, {'char'}, {}));
p.addParameter('xloc', 'b', @(x) validateattributes(x, {'char'}, {}));
p.parse(varargin{:});
Opt = p.Results;

if Opt.y == 0 && Opt.x == 0
    Opt.y = 0.1;
end

addy = Opt.y > 0;
addx = Opt.x > 0;

ishg2 = ~verLessThan('matlab', '8.4.0');

% Determine color to use for hidden axes lines

hparent = ancestor(hax(:), {'figure', 'uipanel'});
if numel(hax) == 1
    hparent = {hparent}; % just makes things simpler
end

col = cell(size(hax));
if ishg2
    [col{:}] = deal('none');
else
    ptype = cellfun(@(x) get(x, 'type'), hparent, 'uni', 0);
    pisfig = strcmp(ptype, 'figure');
    col(pisfig) = cellfun(@(x) get(x, 'color'), hparent(pisfig), 'uni', 0);
    col(~pisfig) = cellfun(@(x) get(x, 'backgroundcolor'), hparent(~pisfig), 'uni', 0);
end

% Preallocate axis handles

if addy
    if ishg2
        hy = gobjects(size(hax));
    else
        hy = zeros(size(hax));
    end
end
if addx
    if ishg2
        hx = gobjects(size(hax));
    else
        hx = zeros(size(hax));
    end
end

% Create offset axes

for iax = 1:numel(hax)

    pos = get(hax(iax), 'position');

    if Opt.y > 0

        newpos = [pos(1) - pos(3)*Opt.y pos(2) pos(3)+2*Opt.y*pos(3) pos(4)];
        hy(iax) = axes('parent', hparent{iax}, ...
            'position', newpos, ...
            'color', 'none', ...
            'xcolor', col{iax});
        if ishg2
            switch class(hax(iax).YAxis)
            case 'matlab.graphics.axis.decorator.DatetimeRuler'
                set(hy(iax), 'YAxis', matlab.graphics.axis.decorator.DatetimeRuler);
            case 'matlab.graphics.axis.decorator.DurationRuler'
                set(hy(iax), 'YAxis', matlab.graphics.axis.decorator.DurationRuler);
            case 'matlab.graphics.axis.decorator.CategoricalRuler'
                set(hy(iax), 'YAxis', matlab.graphics.axis.decorator.CategoricalRuler);
            end
        end

        set(hy(iax), ...
            'ylim', get(hax(iax), 'ylim'), ...
            'ydir', get(hax(iax), 'ydir'), ...
            'TickDir', get(hax(iax), 'TickDir'), ...
            'ytick', get(hax(iax), 'ytick'), ...
            'yticklabel', get(hax(iax), 'yticklabel'), ...
            'ylabel', get(hax(iax), 'ylabel') ...
        );
        set(hax(iax), 'ycolor', col{iax}, 'ytick', []);
        hlink = linkprop([hax(iax) hy(iax)], 'YLim');
        setappdata(hax(iax), 'yoffsetlink', hlink);

        switch Opt.yloc
            case {'lr', 'rl'}
                set(hy(iax), 'box', 'on');
            case 'l'
                set(hy(iax), 'box', 'off', 'yaxisloc', 'left');
            case 'r'
                set(hy(iax), 'box', 'off', 'yaxisloc', 'right');
        end
        uistack(hy(iax), 'bottom');
    end

    if Opt.x > 0
        newpos = [pos(1) pos(2)-pos(4)*Opt.x pos(3) pos(4)+2*pos(4)*Opt.x];
        hx(iax) = axes('parent', hparent{iax}, ...
                       'position', newpos, ...
                       'color', 'none', ...
                       'ycolor', col{iax});
        if ishg2
            switch class(hax(iax).XAxis)
                case 'matlab.graphics.axis.decorator.DatetimeRuler'
                    set(hx(iax), 'XAxis', matlab.graphics.axis.decorator.DatetimeRuler);
                case 'matlab.graphics.axis.decorator.DurationRuler'
                    set(hx(iax), 'XAxis', matlab.graphics.axis.decorator.DurationRuler);
                case 'matlab.graphics.axis.decorator.CategoricalRuler'
                    set(hx(iax), 'XAxis', matlab.graphics.axis.decorator.CategoricalRuler);
            end
        end

        set(hx(iax), ...
            'xlim', get(hax(iax), 'xlim'), ...
            'xdir', get(hax(iax), 'xdir'), ...
            'xdir', get(hax(iax), 'xdir'), ...
            'xtick', get(hax(iax), 'xtick'), ...
            'TickDir', get(hax(iax), 'TickDir'), ...
            'xticklabel', get(hax(iax), 'xticklabel'), ...
            'xlabel', get(hax(iax), 'xlabel') ...
        );
        set(hax(iax), 'xcolor', col{iax}, 'xtick', []);

        hlink = linkprop([hax(iax) hx(iax)], 'XLim');
        setappdata(hax(iax), 'xoffsetlink', hlink);

        switch Opt.xloc
            case {'tb', 'bt'}
                set(hx(iax), 'box', 'on');
            case 't'
                set(hx(iax), 'box', 'off', 'xaxisloc', 'top');
            case 'b'
                set(hx(iax), 'box', 'off', 'xaxisloc', 'bottom');
        end
        uistack(hx(iax), 'bottom');
    end

end

% Return handles

if addx && addy
    varargout = {hy hx};
elseif addx
    varargout = {hx};
elseif addy
    varargout = {hy};
end


