function out=parse_aes(varargin)
%Parse input to generate esthetics structure
p=inputParser;

% x and y are mandatory first two arguments
addParameter(p,'x',[]);
addParameter(p,'y',[]);
addParameter(p,'u',[]);
addParameter(p,'v',[]);
addParameter(p,'w',[]);
addParameter(p,'z',[]);
addParameter(p,'ymin',[]);
addParameter(p,'ymax',[]);
addParameter(p,'label',[]);
addParameter(p,'faces',[]);
addParameter(p,'vertices',[]);
addParameter(p,'init',[]);

% Other aesthetics are string-value pairs
addParameter(p,'pointdata',[]);
addParameter(p,'color',[]);
addParameter(p,'facecolor',[]);
addParameter(p,'lightness',[]);
addParameter(p,'group',[]);
addParameter(p,'linestyle',[]);
addParameter(p,'size',[]);
addParameter(p,'marker',[]);
addParameter(p,'subset',[]);
addParameter(p,'row',[]);
addParameter(p,'column',[]);
addParameter(p,'fig',[]);
parse(p,varargin{:});

%Make every column arrays
for pr=1:length(p.Parameters)
    %By doing the test with isrow, we prevent shifting things that could be
    %in 2D such as X and Y
    if isrow(p.Results.(p.Parameters{pr}))
        out.(p.Parameters{pr})=shiftdim(p.Results.(p.Parameters{pr}));
    else
        out.(p.Parameters{pr})=p.Results.(p.Parameters{pr});
    end
end

%transform 'vertices' to x y z
if ~isempty(p.Results.vertices)
    if iscell(p.Results.vertices)
        temp=p.Results.vertices;
        out.x=cellfun(@(x)x(:,1)',temp,'uniformOutput',false);
        out.y=cellfun(@(y)y(:,2)',temp,'uniformOutput',false);
        out.z=cellfun(@(z)z(:,3),temp,'uniformOutput',false);

    else
        out.x=p.Results.vertices(:,1)';
        out.y=p.Results.vertices(:,2)';
        if size(p.Results.vertices,2)==3
            out.z=p.Results.vertices(:,3)';
        end
    end

end


end