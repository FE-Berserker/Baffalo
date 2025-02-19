function obj=AddEndRelease(obj,Numpart,No,varargin)
% Define endrelease node set
% Author : Xie Yu
% k=inputParser;
% addParameter(k,'No',[]);
% parse(k,varargin{:});
% opt=k.Results;


% Define Endrelease elements
acc_elements=obj.Part{Numpart,1}.acc_el;
acc_nodes=obj.Part{Numpart,1}.acc_node;
elements=obj.Part{Numpart, 1}.mesh.elements(:,1:2);
EndReleaseList=acc_nodes+unique(elements);
num=GetNEndRelease(obj)+1;

%% Parse
obj.EndRelease{num,1}.elements=acc_elements+No;
obj.EndReleaseList=[obj.EndReleaseList;EndReleaseList];
obj.Summary.Total_EndRelease=GetNEndRelease(obj);

%% Print
if obj.Echo
    fprintf('Successfully add endrelease . \n');
end
end