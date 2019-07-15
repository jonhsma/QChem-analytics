function [element, charge] = getElementAndCharge(line)
    a = (line<46);
    toRetain= ~(a(2:end) & a(1:end-1));
    truncatedLine = line([(line(1)~=32 && line(1)~=9) toRetain]);
 
    breaks = find(truncatedLine==32);
    
    element = truncatedLine(breaks(1)+1:breaks(2)-1);
    charge = strFP2double(truncatedLine(breaks(2)+1:end));
end