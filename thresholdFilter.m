function [filtered] = thresholdFilter(I, threshold, name)

Itemp=I>threshold;
filtered = uint8(int16(I).*int16(Itemp));
figure
imshow(filtered)

title(join(['Filtered ' name]))