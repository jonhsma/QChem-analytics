function y = BatchImportWrapper(path)
    [names,positions,charges] = readPositionsAndCharges(path);
    y.names = names;
    y.positions = positions;
    y.charges = charges';
end