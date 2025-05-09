function [Vout, Dout] = get_positive_entries(Vin,Din)
% Extracts only the positive enries of V and D
%
%    :param Vin: Eigenvectormatrix raw
%    :type Vin: matrix
%    :param Din: Eigenvaluematrix (diagonal) raw
%    :type Din: matrix
%    :return: V and D with only positive entries


Dout = Din(imag(Din)>0);
Vout = Vin(:,imag(Din)>0);
end

