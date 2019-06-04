% Unit testing
%% Position and element
% Make sure these two gives no error
[elementArray05,coordinatesArray05]=readPositionsAndCharges('FSSH.X1.Iter05.out');
[elementArray12,coordinatesArray12]=readPositionsAndCharges('FSSH.X1.Iter12.out');

% Atomic element descrapency detection
disp('Warning on atomic element descrapency is expected')
[elementArray05st,coordinatesArray05st]=readPositionsAndCharges('FSSH.X1.Iter05.StringTest.out');
if (length(size(elementArray05st))~=3)
    disp('Unable to detect in-reaction atomic element descrapency')
end

%% Test for charges
[elementArray05,coordinatesArray05,chargeArray05]=readPositionsAndCharges('FSSH.X1.Iter05.out');
if ~isnan(chargeArray05)
    disp('Fail to signal user that there is no charge information')
end
[elementArray06,coordinatesArray06,chargeArray06]=readPositionsAndCharges('FSSH.X11.Iter06.out');
disp('Warning on atomic element descrapency between position and charge arrays is expected')
[elementArray06e,coordinatesArray06e,chargeArray06e]=readPositionsAndCharges('FSSH.X11.Iter06.error.out');