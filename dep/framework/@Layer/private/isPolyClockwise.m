function [L]=isPolyClockwise(V)

A=polyarea_signed(V); %Calculate signed area
L=A<0; %If negative curve is clockwise
end