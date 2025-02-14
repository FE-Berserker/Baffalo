function drawArrowhead( form, ad1, ad2, xh, yh, rot, varargin)
%DRAWARROWHEAD Draw various arrowheads
%
% Usage:
%   drawArrowhead( form, ad1, ad2, xh, yh, rot, varargin)
%
% Input:
%   form  --- arrowhead type number ([1])
%   ad1   --- arrowhead height
%   ad2   --- arrowhead width 
%   xh,yh --- arrowhead point coordinates
%   rot   --- arrowhead CCW rotation angle aroun arrowhead point in degrees
%
%Optional name-value pairs input:
%   LineSpec    --- plot options
%
%   Form Meaning
%      1 Wedge
%      2 Triangle
%      3 Filled Triangle
%      4 No Arrowhead
%      5 Circle
%      6 Filled Circle
%      7 Rectangle
%      8 Filled Rectangle
%      9 Slash
%     10 Integral Sign 
%     11 Open Triangle
%     12 Dimension Origin
%
%Literature:
%   [1] IGES 5.3, 4.62 Leader (arrow) entity, pp 259-251
            
p=inputParser;
addParameter(p,'LineWidth',1);
addParameter(p,'Color',[0 0 0]);
parse(p,varargin{:});
opt=p.Results;

        
    validateattributes(form, {'numeric'}, {'>',0,'<',13,'integer','scalar'});
    validateattributes(ad1,  {'numeric'}, {'>=',0,'real','scalar'});  
    validateattributes(ad2,  {'numeric'}, {'>=',0,'real','scalar'});      
    validateattributes(xh,   {'numeric'}, {'real','scalar'});    
    validateattributes(yh,   {'numeric'}, {'real','scalar'});  
    validateattributes(rot,  {'numeric'}, {'real','scalar'});     
    
    if form == 4 || (ad1 == 0 && ad2 == 0)
        return
    end
    
    % calculate arrowhead local coordinates    
    switch form
        case {1,2,3,11}     
            % wedge, triangle, filled triangle, open triangle
            x = zeros(3,1);
            y = zeros(3,1);
            x(1) = -ad1;
            y(1) = -ad2/2; 
            x(3) =  x(1);
            y(3) = -y(1);
        case 4         
            % empty
            return
        case {5,6}       
            % circle, filled circle
            if ad1 ~= ad2
                ad1 = ad2;
                %error('ad1 and ad2 sholud be equal.')
            end
            [x,y] = evalCircle(-ad1/2,0,ad1/2,0:10:360);
        case {7,8}          
            % rectangle, filled rectangle
            x = zeros(4,1);
            y = zeros(4,1);
            x(1) = -ad1;
            x(4) =  x(1);
            y(1) = -ad2/2;
            y(2) =  y(1);
            y(3) = -y(1);
            y(4) =  y(3);
        case (9)            
            % slash
            x(1) = ad1/2;
            y(1) = ad2/2;
            x(2) = -x(1);
            y(2) = -y(1);   
        case 10
            % integral sign
            x(1) = ad1/2;
            x(2) = -0*ad1/8; %  !!!
            x(3) = 0;
            x(4) = -x(2);
            x(5) = -x(1);
            y(1) =  ad2/2;
            y(2) =  ad2/2;
            y(3) =  0;
            y(4) =  -y(2);
            y(5) =  -y(1);
            [x,y] = evalBezier(x,y,0:0.1:1);
        case 12
            % dimension origin, circle
            if ad1 ~= ad2
                error('ad1 and ad2 sholud be equal.')
            end
            [x,y] = evalCircle(0,0,ad1/2,0:10:360);
        otherwise
            error('Invalid type number %g.',form)
    end
    
    % calculate arrowhead space coordinates
    [x,y] = trRot2d( x, y, xh, yh, rot);
    
    if form ~= 1 && form ~= 9 && form ~= 10
        % close arowhead
        x(end+1) = x(1);
        y(end+1) = y(1);
    end
   
    % draw arrowhead
    switch form
        case {1,2,9,10,12} % simple
            plot(x,y,...
                'LineWidth',opt.LineWidth,...
                'Color',opt.Color);
        case {3,8,6}  % filled
            plot(x,y,...
                'LineWidth',opt.LineWidth,...
                'Color',opt.Color);
            fill(x,y,opt.Color,'EdgeColor','none')
        case {5,7,11}  % hollow
            fill(x,y,'w','EdgeColor','none')
            plot(x,y,...
                'LineWidth',opt.LineWidth,...
                'Color',opt.Color);
    end
    
end
    