function [iwLength,meanParticleSize,numParticles] = windowCalcCircle(I,r1,r2,print)


[centers,radii] = imfindcircles(I,[r1,r2],'ObjectPolarity','bright','Sensitivity',1);
meanParticleSize = (pi*(mean(radii))^2);
[sx,sy] = size(I);
[np1,np2] = size(centers);
numParticles = np1*np2;
particleDensity = numParticles/(sx*sy);
iwArea = 10/particleDensity;
iwLength = round(sqrt(iwArea));
if print == 1
    figure
    imshow(I)
    viscircles(centers,radii);
    title('Identified circles shown in red circles')
end