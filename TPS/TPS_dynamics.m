function resultObject=TPS_dynamics(rings,sulphurIdx,coordData,graph)
    
    %For simplicity, now I'm only accepting 3 rings
    if ~(iscell(rings) && length(rings)==3)
        return
    end
    ring1idx = rings{1};
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
    sB1_BV = squeeze(coordData(2,:,:)-coordData(1,:,:));
    sB1_BV_n = sB1_BV./sum(sB1_BV.*sB1_BV,1);
    sB1_BV_l = diag(sB1_BV'*sB1_BV);
    sB2_BV = squeeze(coordData(13,:,:)-coordData(1,:,:));
    sB2_BV_n = sB2_BV./sum(sB2_BV.*sB2_BV,1);
    sB2_BV_l = diag(sB2_BV'*sB2_BV);
    sB3_BV = squeeze(coordData(24,:,:)-coordData(1,:,:));
    sB3_BV_n = sB3_BV./sum(sB3_BV.*sB3_BV,1);
    sB3_BV_l = diag(sB3_BV'*sB3_BV);

    % Get the anlges
    proj_SB1 = diag(b1_n*sB1_BV_n);
    proj_SB2 = diag(b2_n*sB2_BV_n);
    proj_SB3 = diag(b3_n*sB3_BV_n);
    figure(graph+1)
    subplot(3,1,1)
    plot(abs([proj_SB1, proj_SB2, proj_SB3]))
    subplot(3,1,2)
    plot(abs([sB1_BV_l, sB2_BV_l, sB3_BV_l]))
    
    % plot the distortiong in the benzene ring
    figure(graph+1)
    subplot(3,1,3)
    plot([b1_r, b2_r b3_r])
    
end