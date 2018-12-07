
clear all;clc;
computer = 'Ying_iMAC';
%AddPaths(computer)
project_name ='MMR' %'Memoria';
center = 'Stanford';
regions = {'PMC';'mPFC';'Hippocampus';};
numbercrew ={'S12_33_DA';'S12_38_LK';'S12_42_NC'};
%sbj_names ={'S14_69_RTb'};%'S16_99_CJ';'S18_131';'S17_110_SC';'S17_112_EA';'S17_118_TW';'S18_119_AG';'S18_124_JR2';'S17_116';'S18_127';'S18_128_CG';'S17_105_TA';'S18_126';'S14_69_RTb';'S16_100_AF';'S18_130_RH'};

%%mmrcrew
%sbj_names={'S18_119_AG'};
sbj_names = {'S18_131';'S17_118_TW';'S18_119_AG';'S18_124_JR2';'S18_126';'S18_130_RH';'S14_69_RTb';'S16_99_CJ';'S16_100_AF';'S17_105_TA';'S17_110_SC';'S17_112_EA';'S17_116';};%;'S12_38_LK';'S12_42_NC';'S16_99_CJ';'S17_110_SC';'S17_112_EA';'S17_118_TW';'S18_119_AG';'S18_124_JR2';'S18_125'};%};%};%;%;'S13_47_JT2';

%;'S12_33_DA';'S12_38_LK';'S12_42_NC';

datatype1='Band';
datatype2='HFB';%;
locktype='stimlock';%'stimlock';%
conditions='autobio_math';%_other';
%datatype3='ITPC';%'PAC';%'ITPC';

fpath='/Volumes/Ying_SEEG/Data_lbcn/Results/MMR';
tpath='/Volumes/Ying_SEEG/Data_lbcn/Results/Group_by_regions/';


for subi=1:length(sbj_names)
    
    sbj_name = sbj_names{subi};
     
    for ri=1:length(regions)
        elec_names=[];elecs=[];
        [elec_names,elecs] = ElectrodeBySubj_selected(sbj_name,regions{ri});
        % elecs=104
        if ~isempty(elecs)
            % wavelet
            
            %frompath=fullfile(fpath,sbj_name,'Figures',[datatype1,'Data'],datatype2,'stimlock','autobio_math');
            frompath=fullfile(fpath,sbj_name,'Figures',[datatype1,'Data'],datatype2,locktype,conditions);
            %frompath=fullfile(fpath,sbj_name,'Figures',[datatype1,'Data'],datatype2,datatype3,'autobio_math');
            
            fromfile = dir(frompath);
            tofile =fullfile(tpath,'All_figs',regions{ri});
            if ~exist(tofile)
                mkdir(tofile)
            end
            
            for j=1:length(elec_names)
                for i=1:length(fromfile)
                    match=0;
                    if ismember (sbj_name, numbercrew)
                        for ii=1:length(elecs)
                        elec_names{ii}=num2str(elecs(ii));
                        end
                    end
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