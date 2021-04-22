function drawMolecule(elements,coordinates,varargin)

	%Defaults
	scale = 1;
	n = 100;
	opts_atoms={};
	opts_bonds={};
	opts={};
	thres = 0.2;
	
	holdState = ishold;
	
	ii=1;
	while ii <= numel(varargin)
		switch varargin{ii}
			case 'scale'
				scale = double(varargin{ii+1});
				ii = ii +2;
			case 'n'
				n = double(varargin{ii+1});
				ii = ii +2;
			case 'thres'
				thres = double(varargin{ii+1});
				ii = ii +2;
			otherwise
				if (ischar(varargin{ii}) || isstring(varargin{ii}))
					prop = strsplit(varargin{ii},'.');
				end
				if numel(prop)< 2
					opts{end+1} = varargin{ii};
					ii = ii+1;
				elseif regexp(prop{1},'atom')
					opts_atoms{end+1} = prop{2};
					opts_atoms{end+1} = varargin{ii+1};
					ii = ii+2;
				elseif regexp(prop{1},'bond')
					opts_bonds{end+1} = prop{2};
					opts_bonds{end+1} = varargin{ii+1};
					ii = ii+2;
				end
		end
	end
	
	opts_atoms = [opts opts_atoms];

	for ii = 1:size(elements,1)
		[xx,yy,zz] = sphere(n);
		
		ele_str = elements(ii,:);
		ele_str(ele_str == 0)=13;
		
		switch(strip(char(ele_str)))
			case 'H'
				atom_color = [0.9 0.9 0.9];
				r = 0.25;
			case 'O'
				atom_color = [1 0 0];
				r = 0.5;
			case 'Sn'
				atom_color = [0.5 0.5 0.5];
				r = 0.75;
			case 'C'
				atom_color = [0.1 0.1 0.1];
				r = 0.4;
			case 'S'
				atom_color = [0.65 0.65 0];
				r = 0.45;
			case 'N'
				atom_color = [0 0 1];
				r = 0.475;
			otherwise
				atom_color = [0 0 0.25];
				r = 0.25;
		end
		
		xx = xx*r*scale + coordinates(ii,1);
		yy = yy*r*scale + coordinates(ii,2);
		zz = zz*r*scale + coordinates(ii,3);

		surf(xx,yy,zz,'EdgeColor','none','FaceColor',atom_color,opts_atoms{:})
		
		hold on

	end
	daspect([1 1 1])
	
	% Now try to deal with bonds

	
	coord_1 = permute(coordinates,[1,3,2]);
	coord_2 = permute(coordinates,[3,1,2]);
	
	delta = sqrt(sum((coord_2 - coord_1).^2,3));

	
	
	bond = delta;
	
	for ii = 1:size(elements,1)
		temp = delta(ii,:);
		temp(temp==0) = nan;
	
		
		
		bond(ii,:) = abs(min(temp)-temp)<thres*min(temp);
	end
	
	%imagesc(bond)
	bond = bond | bond';
	
	opts_bonds = [opts,opts_bonds];
	
	for ii = 1:size(elements,1)
		for jj = 1:ii-1
			if bond(ii,jj)
				hold on
				v = [coordinates(jj,:); coordinates(ii,:)];
				if ~ isempty(opts_bonds)
					plot3(v(:,1),v(:,2),v(:,3),'color',[0.5 0.5 0.5],...
						'linewidth',10*scale,opts_bonds{:})
				else
					plot3(v(:,1),v(:,2),v(:,3),'color',[0.5 0.5 0.5],...
						'linewidth',10*scale)
			end
		end
	end
	
	grid off
	
	daspect([1 1 1])
	
	if isempty(findall(gca,'Type','light'))
		curr_camlight = camlight;
		lighting flat
	end
	
	if holdState
		hold on
	else
		hold off
	end

end