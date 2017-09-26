function TAC = extractTACFromVoxel(image4D, coordinates, numberOfFrames)
%  Summary of this function goes here
%   Detailed explanation goes here

TAC = zeros(1,size(image4D.img,4));

for j = 1:size(image4D.img,4)
    TAC(j) = image4D.img(coordinates(1),coordinates(2),coordinates(3),j);
    %disp(TAC(i));
end



TAC = sumFrames(TAC,numberOfFrames);

end