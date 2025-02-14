function h=init(m,n,p,gap,marg_h,marg_w,radar,varargin)
%function h=init(m,n,p,gap,marg_h,marg_w,varargin)


[subplot_col,subplot_row]=ind2sub([n,m],p);  


% single subplot dimensions:
%height=(1-(m+1)*gap_vert)/m;
%axh = (1-sum(marg_h)-(Nh-1)*gap(1))/Nh; 
height=(1-(marg_h(2)+marg_h(1))-(m-1)*gap(1))/m;
%width =(1-(n+1)*gap_horz)/n;
%axw = (1-sum(marg_w)-(Nw-1)*gap(2))/Nw;
width =(1-(marg_w(1)+marg_w(2))-(n-1)*gap(2))/n;

% merged subplot position:
bottom=(m-subplot_row)*(height+gap(1)) +marg_h(1);
left=(subplot_col-1)*(width+gap(2)) +marg_w(1);
pos_vec=abs([left bottom width height]);

if radar==0
h=axes('Position',pos_vec,varargin{:});
elseif radar==1
h=polaraxes('Position',pos_vec,varargin{:});
end

end