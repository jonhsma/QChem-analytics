% For the sake of speed it only works for 10^-10 to 10^10
function y = strFP2double(input)
    % The exponent array. Now it's only using 1% of the time
    exponentDigit = [10000000000 1000000000 100000000 10000000 1000000 100000 10000 1000 100 10 1];
    exponentDecim = [0.1 0.01 0.001 0.0001 0.00001 0.000001 0.0000001 0.00000001 0.000000001 0.0000000001 0.00000000001];
    %Strip off the spaces
    target=input(input~=32);
    dot=find(target==46);
    nDigit = dot(1)-1;
    nDecimal = numel(target)-dot;
    y=sum((target(1:dot-1)-48).*exponentDigit(12-nDigit:end))+...
        sum((target(dot+1:end)-48).*exponentDecim(1:nDecimal));
end