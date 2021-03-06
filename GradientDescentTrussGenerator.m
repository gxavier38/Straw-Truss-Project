clear;
loadfilename = 'trusses/Eli2.mat';
savefilename = 'trusses/GeneticDesign0.mat';
check = false;
gens = 10000000;
maxLocChange = 0.01;

load(loadfilename);

[numJoints, numMembers] = size(C);

bestX = X;
bestY = Y;
bestFitness = getFit(C, X, Y, L, Sx, Sy);

figure;
l = animatedline();
fprintf("Initial fitness is %f\n", bestFitness);
addpoints(l,0,bestFitness);
drawnow;

%% Algorithm
for i = 1:gens
    
    randMatrix = randn(numJoints,1) * maxLocChange;
    randMatrix(1) = 0;
    tempX = bestX + randMatrix.';
    randMatrix = randn(numJoints,1) * maxLocChange;
    randMatrix(1) = 0;
    tempY = bestY + randMatrix.';

    fitness = getFit(C, tempX, tempY, L, Sx, Sy);
    if (fitness >= bestFitness)
        bestX = tempX;
        bestY = tempY;
        bestFitness = fitness;
    end
    
    if (mod(i,100000) == 0)
        fprintf("Fitness at generation %d is %f\n", i, bestFitness);
        addpoints(l,i,bestFitness);
        drawnow;
    end
end

if (bestFitness == -1)
    return 
end

%% Draw trusses
figure;
drawTruss(C, X, Y, 'black');
hold on;
drawTruss(C, bestX, bestY, 'blue');

%% Save generated truss
X = bestX;
Y = bestY;
save(savefilename,'C','Sx','Sy','X','Y','L');