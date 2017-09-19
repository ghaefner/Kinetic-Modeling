function [ averageK2prime ] = averageK2 ( arrayK2Prime )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

averageK2prime = sum(arrayK2Prime(:))/nnz(arrayK2Prime(:));

end

