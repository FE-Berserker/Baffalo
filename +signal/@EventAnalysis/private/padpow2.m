function trout=padpow2(trin,flag);
% PADPOW2: pad a trace with zeros to the next power of 2 in legth.
%
% trout=padpow2(trin,flag);
% trout=padpow2(trin)
%
% PADPOW2 pads the input trace to the next power of two. 
%
% flag= 1 --> If the trace is already an exact power of two, then
%             its length will be doubled.
%     = 0 --> If the trace is already an exact power of two, then
%             its length will be unchanged
%    ********* default = 0 ************
%

 if (nargin<2), flag=0; end
%
 n=2.^(nextpow2(length(trin)));
 if (n==length(trin))&(flag==1)
   n=2.^(nextpow2(length(trin)+1));
 end
 [nr,nc]=size(trin);
 if(nr==1)
		 trout=[trin zeros(1,n-nc)]; %row vectors
 else
		 trout=[trin;zeros(n-nr,nc)]; %column vectors
 end