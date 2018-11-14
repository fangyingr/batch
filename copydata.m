clear all;clc;
computer = 'Ying_iMAC';
AddPaths(computer)
project_name = 'MMR';
center = 'Stanford';
regions = {'mPFC';'Hippocampus';'PMC'};
sbj_names ={'S12_33_DA'};%;'S12_38_LK';'S12_42_NC';'S16_99_CJ';'S17_110_SC';'S17_112_EA';'S17_118_TW';'S18_119_AG';'S18_124_JR2';'S18_125'};%};%};%;%;'S13_47_JT2';
locktype ='stim';

datatype1='Spec';
datatype2='SpecDense';%;
datatype3='ITPC';%'PAC';%'ITPC';

fpath='/Users/yingfang/Documents/data/Results/MMR';
tpath='/Volumes/Elke/MMR';


for subi=1:length(sbj_names)
    
    sbj_name = sbj_names{subi};
    dirs = InitializeDirs('Ying_iMAC', project_name,sbj_name, false);
    block_names = BlockBySubj(sbj_name,project_name);
    
    for ri=1:length(regions)
        elec_names=[];elecs=[];
        [elec_names,elecs] = ElectrodeBySubj(sbj_name,regions{ri});
        % elecs=104
        if ~isempty(elecs)
            % wavelet
            
            %frompath=fullfile(fpath,sbj_name,'Figures',[datatype1,'Data'],datatype2,'stimlock','autobio_math');
            frompath=fullfile(fpath,sbj_name,'Figures',[datatype1,'Data'],datatype2,datatype3,'stimlock','autobio_math');
            %frompath=fullfile(fpath,sbj_name,'Figures',[datatype1,'Data'],datatype2,datatype3,'autobio_math');
            
            fromfile = dir(frompath);
            tofile =fullfile(tpath,datatype3,regions{ri});
            if ~exist(tofile)
                mkdir(tofile)
            end
            
            for j=1:length(elec_names)
                for i=1:length(fromfile)
                    match=0;
                    match(j,i)=numel(find(ismember(elec_names{j},fromfile(i).name))>0);
                     
                    if  ~isempty(strfind(fromfile(i).name,elec_names{j}))
                        
                        copyfile([frompath,filesep,fromfile(i).name],tofile)
                    end
                end
            end
            
        else
            
            disp('No electrodes in this regions')
            
        end
    end
end