%% Particle Image Velocity
%%
clc
clear
close all

%% Import image data
I1=imread('00020359.bmp');
I2=imread('00020360.bmp');

%% Set image processing values
thresholdRatio=0.5; % Particles above this ratio*maximum intensity will remain
r1 = 1; % Circle recognition radii
r2 = 3;

%% Filtering for I1
imshow(I1)
title('Original I1')
foreground1 = backgroundFilter(I1,'I1');
maximumIntensity1 = max(max(foreground1));
threshold1 = maximumIntensity1*thresholdRatio;
filtered1 = thresholdFilter(foreground1, threshold1,'I1');
I1f = filtered1;

%% Filterring for I2
figure
imshow(I2)
title('Original I2')
foreground2 = backgroundFilter(I2,'I2');
maximumIntensity2 = max(max(foreground2));
threshold2 = maximumIntensity2*thresholdRatio;
filtered2 = thresholdFilter(foreground2, threshold2,'I2');
I2f = filtered2;

%% Interrogation window calculation
[iwLength1,meanParticleSize1,numParticles1] = windowCalcCircle(I1f,r1,r2,1);

%% Alternate interrogation window calculation
[iwLength,meanParticleSize,numParticles] = windowCalcObject(I1f,1);

%% Print values
maximumIntensity1
meanParticleSize
iwLength

%% Particle number calculation
ii=1;
jj=1;
[sx,sy] = size(I1f);
for i=0:iwLength:sx-iwLength
    for j=0:iwLength:sy-iwLength
        crop1=imcrop(I1f,[i,j,iwLength,iwLength]);
        %[empty,empty,numParticlesMatrix1(ii,jj)] = windowCalcCircle(crop1,r1,r2,0);
        [empty,empty,numParticlesMatrix1(ii,jj)] = windowCalcObject(crop1,0);
        jj = jj+1;
    end
    jj=1;
    ii = ii+1;
end
densityMesh(numParticlesMatrix1)

%% Velocity calculation
ii=1;
jj=1;
for i=0:iwLength:sx-iwLength
    for j=0:iwLength:sy-iwLength        
        y = j+1;
        Y = y+iwLength-1;
        x = i+1;
        X = x+iwLength-1;
        szy = y:Y;
        szx = x:X;

        nimg1 = I1-mean(mean(I1));
        nSec1 = nimg1(szx,szy);
        
        nimg2 = I2-mean(mean(I2));
        szx2 = x-iwLength*2:x+5*iwLength;
        szy2 = y-iwLength*2:y+5*iwLength;
        szx2 = szx2(szx2>0 & szx2<=size(I1,1));
        szy2 = szy2(szy2>0 & szy2<=size(I1,2));
        nSec2 = nimg2(szx2,szy2);
        
        if isequal(nSec1,zeros(size(nSec1,1),size(nSec1,2)))...
                || isequal(nSec2,zeros(size(nSec2,1),size(nSec2,2)))
            shifty(ii,jj)=0;
            shiftx(ii,jj)=0;
        else
            crr = normxcorr2(nSec1,nSec2);
            [ssr,snd] = max(crr(:));
            [ij,ji] = ind2sub(size(crr),snd);
            shifty(ii,jj)=ij-x-size(nSec1,1)+1+szx2(1)-1;
            shiftx(ii,jj)=ji-y-size(nSec1,2)+1+szy2(1)-1;
        end
        if ii==ceil((sx-iwLength)/iwLength)/2 && jj==ceil((sy-iwLength)/iwLength)/2
            figure
            mesh(crr)
            title('Center interrogation window correlation plane')
        end
        
        jj = jj+1;
    end
    jj=1;
    ii = ii+1;
end

%% Vector field graphing
figure
quiver(shiftx,shifty,'AutoScaleFactor',3)
set(gca,'View',[0 270])
ylabel('rows')
xlabel('columns')
title('Vector field')

vel = (shiftx.^2+shifty.^2).^0.5;
densityMesh(vel)
set(gca,'View',[0 270])
ylabel('rows')
xlabel('columns')
title('Velocity distribution')