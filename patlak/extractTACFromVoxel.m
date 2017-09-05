function TAC = extractTACFromVoxel(image4D, coordinates)
%  Summary of this function goes here
%   Detailed explanation goes here

for i = 1:size(image4D.img,4);
    TAC(i) = image4D.img(coordinates(1),coordinates(2),coordinates(3),i);
    %disp(TAC(i));
end

end