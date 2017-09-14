function ds = fitMRTM(coeffs)

%data = calcMRTM(
data = [[2.5649    3.6008    4.1752    4.7622    7.0560    7.5670   10.0853]
    [1.1620    1.0619    0.9211    0.7958    0.9339    0.8436    0.9473]
    [2.5438    3.4702    4.0694    4.8019    7.2700    7.8799   10.5822]];

signal = coeffs(1) * data(1,:) + coeffs(2) * data(2,:) + coeffs(3);

ds = (data(3,:)-signal(:)).^2;
ds = sum(ds);

end