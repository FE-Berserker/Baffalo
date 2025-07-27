function Dx4=D_ij(x,aj,yi,yj,h)
Dx4=(1-(x./aj).^2).^0.5.*log((abs(yi-yj)+h+(x.^2+(abs(yi-yj)+h).^2).^0.5)/(abs(yi-yj)-h+(x.^2+(abs(yi-yj)-h).^2).^0.5));
%  Dx4=(1-(x./aj).^2).^0.5.*log((abs(yi-yj)+h+(x.^2+(yi-yj+h).^2).^0.5)/(abs(yi-yj)-h+(x.^2+(yi-yj-h).^2).^0.5));
end