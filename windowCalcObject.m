function [iwLength,meanParticleSize,numParticles] = windowCalcObject(I,print)

objects = bwconncomp(I,8);
labeled = labelmatrix(objects);
numParticles = objects.NumObjects;
meanParticleSize = nnz(labeled)/numParticles;
[sx,sy] = size(I);
particleDensity = numParticles/(sx*sy);
iwArea = 10/particleDensity;
iwLength = round(sqrt(iwArea));

if print == 1
    figure
    RGB = label2rgb(labeled,'spring','c','shuffle');   %,'spring','c','shuffle'
    imshow(RGB)
    title('Particles shown in multiple colors.')
end