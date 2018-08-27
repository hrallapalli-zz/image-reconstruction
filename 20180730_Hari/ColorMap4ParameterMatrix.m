function [ ColorMatrix ] = ColorMap4ParameterMatrix( ParaMatrix, LB, UB )
%COLORMAP4PARAMETERMATRIX Summary of this function goes here
%   Detailed explanation goes here

ind1=find((ParaMatrix-LB)<0);
ParaMatrix(ind1)=LB;

ind2=find((ParaMatrix-UB)>0);
ParaMatrix(ind2)=UB;

ColorMatrix=round((64-1)/(UB-LB).*ParaMatrix+(64*LB+UB)/(UB-LB));

end

