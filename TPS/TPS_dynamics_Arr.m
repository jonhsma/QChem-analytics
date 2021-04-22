function [sB, proj, zRelRes, center] = TPS_dynamics_Arr(rings,sulphurIdx,carbonIdx,coordData,graph)
    
    %For simplicity, now I'm only accepting 3 rings
    if ~(iscell(rings) && length(rings)==3)
        return
    end
    ring1idx = rings{1};
    % n: normal; r: relative residue; c: center]
    [b1_n,b1_r,b1_c]=trackNormal(ring1idx,coordData);
    ring2idx = rings{2};
    [b2_n,b2_r,b2_c]=trackNormal(ring2idx,coordData);
    ring3idx = rings{3};
    [b3_n,b3_r,b3_c]=trackNormal(ring3idx,coordData);

    %{
    figure(graph)
    
    hold off
    plot3(b1_c(:,1),b1_c(:,2),b1_c(:,3))
    hold on
    plot3(b2_c(:,1),b2_c(:,2),b2_c(:,3))
    plot3(b3_c(:,1),b3_c(:,2),b3_c(:,3))
    legend('Ring 1','Ring 2','Ring 3')
    %}

    % Get the carbon sulphr bond pointing
    % sB : sulphur carbon bond
    % BV : bond vector
    sB(1).BV = squeeze(coordData(carbonIdx(1),:,:)-coordData(sulphurIdx,:,:))';
    sB(2).BV = squeeze(coordData(carbonIdx(2),:,:)-coordData(sulphurIdx,:,:))';
    sB(3).BV = squeeze(coordData(carbonIdx(3),:,:)-coordData(sulphurIdx,:,:))';
    if size(b1_n,1)==1
        % if there is only one step then squeeze would transpose BV
        sB(1).BV = sB(1).BV';
        sB(2).BV = sB(2).BV';
        sB(3).BV = sB(3).BV';
    end
    sB(1).BV_n = sB(1).BV./sqrt(sum(sB(1).BV.*sB(1).BV,2));
    sB(1).BV_l = sqrt(diag(sB(1).BV*sB(1).BV')); % This is not computationally efficient. Just so it's not the bottleneck yet
    sB(2).BV_n = sB(2).BV./sqrt(sum(sB(2).BV.*sB(2).BV,2));
    sB(2).BV_l = sqrt(diag(sB(2).BV*sB(2).BV'));
    sB(3).BV_n = sB(3).BV./sqrt(sum(sB(3).BV.*sB(3).BV,2));
    sB(3).BV_l = sqrt(diag(sB(3).BV*sB(3).BV'));

    % Get the anlges

    proj_SB1 = diag(b1_n*sB(1).BV_n');
    proj_SB2 = diag(b2_n*sB(2).BV_n');
    proj_SB3 = diag(b3_n*sB(3).BV_n');
    
    if graph ~=0
        figure(graph)
        subplot(3,1,1)
        plot(pi/2 - acos(abs([proj_SB1, proj_SB2, proj_SB3])))
        title('S-C bond benzene ring twisting angle')
        axis([0 inf 0 pi/2])
        subplot(3,1,2)
        %plot(abs([sB(1).BV_l, sB(2).BV_l, sB(3).BV_l]))
        plot(abs([sB.BV_l]))
        title('Sulphur-Carbon bond length')

        % plot the distortiong in the benzene ring
    
        figure(graph)
        subplot(3,1,3)
        plot([b1_r, b2_r b3_r])
        title('Distortion (off plane variance) of the rings')
	end
    
	%{
    % Bond data
    resultObject.sB = sB;
    % Projections between the benzene normals and the bonds
    resultObject.proj = [proj_SB1, proj_SB2, proj_SB3];
    % The relative varianve along the normal direction
    resultObject.zRelRes = [b1_r, b2_r b3_r];
    % Results.center
    resultObject.center = {b1_c b2_c b3_c};
	%}
	

    % Bond data
    resultObject.sB = sB;
    % Projections between the benzene normals and the bonds
    proj = [proj_SB1, proj_SB2, proj_SB3];
    % The relative varianve along the normal direction
    zRelRes = [b1_r, b2_r b3_r];
    % Results.center
    center = {b1_c b2_c b3_c};
    
    
end