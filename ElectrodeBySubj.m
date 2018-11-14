function [elec_names,elec_nums] = ElectrodeBySubj(sbj,region)

switch region
    case 'PMC'
        switch sbj
            case 'S14_69_RTb'
                 elec_names = {''};
                elec_nums =[];
            case 'S16_99_CJ'
                elec_names = {'LRS3';'LRS4';'LRS5'};
                elec_nums =[53 54 55];
            case 'S17_110_SC'
                elec_names = {'LPC1';'LPC2'};
                elec_nums =[51 52];
            case 'S17_112_EA'
                elec_names ={'LPCI2';'LPCI3';'LPCI4'};
                elec_nums =[46 47 48];
            case 'S17_118_TW'
                elec_names ={'LRSC2'};%'LRSC1';
                elec_nums =[52];%51
            case 'S18_119_AG'
                elec_names ={'LRSC1(P1)';'LRSC2(P2)'};
                elec_nums = [71 72];
            case 'S18_124_JR2'
                elec_names= {'LDP1';'LDP2';'LDP3';'RDP1'};
                elec_nums = [77 78 79 107];
            case 'S18_125'
                elec_names ={'RPC1';'RPC2'};
                elec_nums =[47 48];
            case 'S13_47_JT2'
                elec_names ={'51','52','53','54','55','56','57','58','59','60','61','62'};
                elec_nums =[51:62];
            case 'S12_42_NC'
                elec_names ={'73','74','75','76','81','82','83','84','85'};
                elec_nums =[73:76 81:85];
            case 'S12_38_LK'
                elec_names ={'65','66','67','68','69','70','71','72','73','74','81','82','83','84','85','86','87','88','89'};
                elec_nums =[65:74 81:89];
            case 'S12_33_DA'
                elec_names ={'65','66','67','68','69','70','73','74','81','82','83','84','85','86','87'};
                elec_nums =[65:70 81:87];
            case 'S18_126'
                elec_names ={};
                elec_nums =[];
            case 'S18_130_RH'
                elec_names = {'LCIN10'};
                elec_nums=[40];
                
        end
        
    case 'mPFC'
        
        switch sbj
            case 'S16_99_CJ'
                elec_names = {};
                elec_nums =[];
            case 'S17_110_SC'
                elec_names = {'LOF1';'LOF2'};
                elec_nums =[1 2];
            case 'S17_112_EA'
                elec_names ={};
                elec_nums =[];
            case 'S17_118_TW'
                elec_names ={'LOFCa2','LOFP1'};
                elec_nums =[32 41];
            case 'S18_119_AG'
                elec_names ={'LaORB1(LOF1)','LaORB2(LOF2)'};
                elec_nums = [51 52];
            case 'S18_124_JR2'
                elec_names ={};
                elec_nums = [];
            case 'S18_125'
                elec_names ={};
                elec_nums =[];
            case 'S13_47_JT2'
                elec_names ={'16','17','18','19','20'};
                elec_nums =[16:20];
            case 'S12_42_NC'
                elec_names ={'65','66','67','68','69','70','71','72'};
                elec_nums =[65:72];
            case 'S12_38_LK'
                elec_names ={'97','98','99','100','101','102','103','104'};
                elec_nums =[97:104];
            case 'S12_33_DA'
                elec_names ={'97','98','99','100','101','102','103','104','105','106'};
                elec_nums =[97:106];
            case 'S18_126'
                elec_names ={};
                elec_nums =[];
            case 'S18_130_RH'
                elec_names ={'LOF6','LOF7'};%,
                elec_nums =[6 7];
        end
        
    case 'Hippocampus'
        switch sbj
            case 'S16_99_CJ'
                elec_names = {'LHH2','LHH3'};
                elec_nums =[12 13];
            case 'S17_110_SC'
                elec_names = {};
                elec_nums =[];
            case 'S17_112_EA'
                elec_names ={'RAH2','RAH3'};%'RAH1',
                elec_nums =[56 57];%55
            case 'S17_118_TW'
                elec_names ={'RAH1','RAH2','RAH3'};
                elec_nums =[98 99 100];
            case 'S18_119_AG'
                elec_names ={'LaHIP1(LHT2_1)','LaHIP2(LHT2_2)','LaHIP3(LHT2_3)'};
                elec_nums = [31 32 33];
            case 'S18_124_JR2'
                elec_names ={'LHA1','LHA2','LHA3','LMH2','LMH3','LPH3','LPH4'};
                elec_nums = [7 8 9 18 19 29 30];
            case 'S18_125'
                elec_names ={'RPH2','RPH3'};
                elec_nums =[2 3];
            case 'S13_47_JT2'
                elec_names ={};
                elec_nums =[];
            case 'S12_42_NC'
                elec_names ={};
                elec_nums =[];
            case 'S12_38_LK'
                elec_names ={};
                elec_nums =[];
            case 'S12_33_DA'
                elec_names ={};
                elec_nums =[];
            case 'S18_126'
                elec_names ={'LMH1','LMH2','LMH3','LMH4','LPH1','LPH2','LPH3','LPH4','RMH1','RMH2','RMH3','RMH4','RHP2'};
                elec_nums =[19:22 27:30 65:68 74];
                
            case 'S18_130_RH'
                elec_names ={'LAM3','LAM4'};
                elec_nums =[23 24];
        end
end
end