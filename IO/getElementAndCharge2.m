function [element, charge] = getElementAndCharge2(line)
    flag = 0;
    flag_reading = 0;
    element = '    ';
    jj = 1;
    kk = 1;
    num = zeros([128 0]);
    for ii=1:numel(line)
        if line(ii)< 46 % This is the quickest cut off I can think off
            flag_reading = 0;
            continue
        else
            if flag_reading ~= 1
                flag = flag+1;
                flag_reading = 1;
            end
            
            if flag == 1
                continue
            elseif flag == 2
                    element(jj)=line(ii);
                    jj = jj+1;
            elseif flag == 3
                num(kk) = line(ii);
                kk = kk+1;
            end
        end         
    end
    element = element(element~=33); %strip the spaces
    charge=strFP2double(num);
end