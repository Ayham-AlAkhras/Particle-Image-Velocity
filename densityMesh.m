function [] = densityMesh(numParticlesMatrix)

[msx,msy] = size(numParticlesMatrix);
mmsx=max([msx,msy]);
[mx,my] = meshgrid(1:mmsx);
if msx > msy
    mx=mx(:,1:msy);
    my=my(:,1:msy);
elseif msx < msy
    mx=mx(1:msx,:);
    my=my(1:msx,:);
end
figure
particleCountMesh = mesh(mx,my,numParticlesMatrix);
particleCountMesh.FaceColor = 'flat';
title('Number of particles per interrogation window')
ylabel('columns');
xlabel('rows');
axis equal;
colorbar;
set(gca,'View',[90 90])