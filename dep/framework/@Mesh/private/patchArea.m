function [A]=patchArea(F,V)

% function [A]=patchArea(F,V)
% ------------------------------------------------------------------------
% This simple function calculates the areas of the faces specified by F and
% V. The output is a vector A containing size(F,1) elements. The face areas
% are calculated via triangulation of the faces. If faces are already
% triangular triangulation is skipped are area calculation is direction
% performed. 
%
%
%
% Kevin Mattheus Moerman
%
% 2011/04/12
% 2021/09/13 Updated to use more efficient patchEdgeCrossProduct method
% 2021/09/14 Renamed to patchArea
%------------------------------------------------------------------------

%%

C=patchEdgeCrossProduct(F,V);
A=sqrt(sum(C.^2,2));
 
%% 
% _*GIBBON footer text*_ 
% 
% License: <https://github.com/gibbonCode/GIBBON/blob/master/LICENSE>
% 
% GIBBON: The Geometry and Image-based Bioengineering add-On. A toolbox for
% image segmentation, image-based modeling, meshing, and finite element
% analysis.
% 
% Copyright (C) 2006-2022 Kevin Mattheus Moerman and the GIBBON contributors
% 
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.
