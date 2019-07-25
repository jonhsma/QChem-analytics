function y = BatchImportWrapperS(path,varargin)
    if nargin==2 && isa(varargin{1},'function_handle')
        reader = varargin{1};
    else
        reader = @readPositionsAndChargesX;
    end
    [names,positions,charges,surface] = reader(path);
    y.names = names;
    y.positions = positions;
    y.charges = charges;
    y.surface = surface;
end