function [foreground] = backgroundFilter(I, name)

background = imopen(I,strel('square',7));
figure
imshow(background)
title(join(['Foreground ' name]))
foreground=I-background;
figure
imshow(foreground)
title(join(['Background ' name]))