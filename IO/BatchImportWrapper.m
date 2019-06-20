function y = BatchImportWrapper(path,varargin)
    if nargin==2 && isa(varargin{1},'function_handle')
        reader = varargin{1};
    else
        reader = @readPositionsAndCharges;
    end
    [names,positions,charges] = reader(path);
    y.names = names;
    y.positions = positions;
    y.charges = charges;
end