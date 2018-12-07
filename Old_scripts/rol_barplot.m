clear;clc;

load ('/Users/yingfang/Documents/data/pairdata')

%% loop between regions
pair_regions={'PMC','mPFC';'Hippocampus','PMC';'Hippocampus','mPFC'};%
C = [
    0.90    0.55    0.55
    0.62    0.76    0.84
    0.89    0.10    0.11
    0.12    0.47    0.70
    ];

for i= 1:length(pair_regions)
    
    Y=[];rol=[];sot=[];
    rol=data.([pair_regions{i,1},'_',pair_regions{i,2}]).rol;
    sot=data.([pair_regions{i,1},'_',pair_regions{i,2}]).sig_onset;
    Y(1,:)=nanmean(rol);
    Y(2,:)=nanmean(sot);
    
    E=[];
    E(1,:)=nanstd(rol)/sqrt(size(rol,1));
    E(2,:)=nanstd(sot)/sqrt(size(sot,1));
    
    [p, observeddifference, effectsize] = permutationTest(rol(:,1),rol(:,2),10000)
    
    [p, observeddifference, effectsize] = permutationTest(sot(:,1),sot(:,2),10000)
    
C = reshape(C, [2 2 3]);
    
%% plot

hf = figure('Position', [100 100 550 400]);



P = nan(numel(Y), numel(Y));
P(1,2) = 0.04;
P(1,3) = 0.004;
P(2,4) = 0.10;
P(3,4) = 0.10;
% Make P symmetric, by copying the upper triangle onto the lower triangle
PT = P';
lidx = tril(true(size(P)), -1);
P(lidx) = PT(lidx);

% superbar(Y, 'E', E, 'P', P, 'BarFaceColor', C, 'Orientation', 'v', ...
%     'ErrorbarStyle', 'T', 'PLineOffset', 3);

end