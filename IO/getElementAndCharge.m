function [element, charge] = getElementAndCharge(line)
    a = (line<44);% Kill off the useless stuff but keep the negative sign which is 45
    toRetain= ~(a(2:end) & a(1:end-1));
    truncatedLine = line([(line(1)~=32 && line(1)~=9) toRetain]);
 
    breaks = find(truncatedLine==32);
    
    element = truncatedLine(breaks(1)+1:breaks(2)-1);
    if numel(breaks) >=3
        last = breaks(3);
    else
        last = numel(truncatedLine);
    end
    charge = strFP2double(truncatedLine(breaks(2)+1:last));
end