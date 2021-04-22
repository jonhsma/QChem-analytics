function delta = drawDifferenceVector(coords_src,coords_dist,varargin)
	mul =10;
	
	opts = {};
	ii = 1;
	while ii <= numel(varargin)
		if isstring(varargin{ii}) || ischar(varargin{ii})
			switch(varargin{ii})
				case 'mul'
					mul = varargin{ii+1};
					ii = ii +2;
				otherwise
					opts{end+1} = varargin{ii};
					ii = ii +1;
			end
		else
			opts{end+1} = varargin{ii};
			ii = ii +1;
		end
	end
	
	
	pos = coords_src;
	delta = (coords_dist - pos);
	pnt = delta*mul;
	
	quiver3(pos(:,1),pos(:,2),pos(:,3),pnt(:,1),pnt(:,2),pnt(:,3),0,opts{:})

end