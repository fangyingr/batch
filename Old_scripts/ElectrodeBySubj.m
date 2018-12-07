function [elec_names,elec_nums] = ElectrodeBySubj(sbj,region)

switch region
    case 'PMC'
        switch sbj
            case 'S14_69_RTb'
                elec_names = {'LP(LBB1)1';'LP(LBB1)2';'LP(LBB1)3';'LPI12(LCC2)';'LPI13(LCC3)';'LPS1(LGG1)';'LPS2(LGG2)';'LPS3(LGG3)';'LPS4(LGG4)'};
                elec_nums =[33:35 43 44 53:56];
            case 'S16_99_CJ'
                elec_names = {'LRS1';'LRS2';'LRS3';'LRS4';'LRS5'};
                elec_nums =[51:55];
            case 'S16_100_AF'
                elec_names = {''};
                elec_nums =[];
            case 'S17_105_TA'
                elec_names = {''};
                elec_nums =[];
            case 'S17_110_SC'
                elec_names = {'LPC1';'LPC2'};
                elec_nums =[51 52];
            case 'S17_112_EA'
                elec_names ={'LPCI2';'LPCI2';'LPCI3';'LPCI4'};
                elec_nums =[45 46 47 48];
            case 'S17_116'
                elec_names={'RTP1'};
                elec_nums =[113];
            case 'S17_118_TW'
                elec_names ={'LRSC1';'LRSC2';'LRSC3'};%;
                elec_nums =[51 52 53];
           case 'S18_119_AG'
                elec_names ={'LCINP1';'LCINP2';'LCINP3';'LCINP4';'LCINP5'}%;'RCINP1';'RCINP2';'RCINP3'};
                elec_nums = [71:75 ]%111:113];
            case 'S18_124_JR2'
                elec_names= {'LDP1';'LDP2';'LDP3';'RDP1'};
                elec_nums = [77 78 79 107];
            case 'S18_125'
                elec_names ={'RPC1';'RPC2'};
                elec_nums =[47 48];
            case 'S18_126'
                elec_names ={''};
                elec_nums =[];
            case 'S18_127'
                elec_names ={'LPC1';'LPC2';'LPC3'};
                elec_nums =[51 52 53];
            case 'S18_128_CG'
                elec_names ={'LPOC1';'LPOC2';'LPOC3';'LPOC4';'LPOC5';'LMLM1'};
                elec_nums =[41:45 11];
            case 'S19_129'
                elec_names = {''};
                elec_nums=[];
            case 'S18_130_RH'
                elec_names = {'LCIN10'};
                elec_nums=[40];
            case 'S18_131'
                elec_names = {'LPC1','LPC2','LPC3','LPC4','RPC1','RPC2','RPC3','RPC4','RPC5'};
                elec_nums=[54:57 44:48];
                
            case 'S13_47_JT2'
                elec_names ={'51','52','53','54','55','56','57','58','59','60','61','62'};
                elec_nums =[51:62 11 ];
            case 'S12_42_NC'
                elec_names ={'73','74','75','76','81','82','83','84','85'};
                elec_nums =[73:76 81:85];
            case 'S12_38_LK'
                elec_names ={'65','66','67','68','69','70','71','72','73','74','81','82','83','84','85','86','87','88','89'};
                elec_nums =[65:74 81:89];
            case 'S12_33_DA'
                elec_names ={'65','66','67','68','69','70','73','74','81','82','83','84','85','86','87'};
                elec_nums =[65:70 81:87];
                
  
        end
        
    case 'mPFC'
        
        switch sbj
            case 'S14_69_RTb'
                elec_names = {''};
                elec_nums =[];
            case 'S16_99_CJ'
                elec_names = {'LCN8';'LOF1';'LOF2'};
                elec_nums =[48 21 22];
            case 'S16_100_AF'
                elec_names = {''};
                elec_nums =[];
            case 'S17_105_TA'
                   elec_names = {'RIF3'};
                elec_nums =[91];
            case 'S17_110_SC'
                elec_names = {'LOF1';'LOF2'};
                elec_nums =[1 2];
            case 'S17_112_EA'
                elec_names ={'LACI1'};
                elec_nums =[35];
            case 'S17_116'
                elec_names={''};
                elec_nums =[];
            case 'S17_118_TW'
                elec_names ={'LOFCa1','LOFCa2','LOFP1'};
                elec_nums =[31 32 41];
          case 'S18_119_AG'
                elec_names ={'LOF1','LOF2'};
                elec_nums = [51 52];
            case 'S18_124_JR2'
                elec_names ={''};
                elec_nums = [];
            case 'S18_125'
                elec_names ={''};
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
                elec_names ={''};
                elec_nums =[];
                
            case 'S18_127'
                elec_names ={''};
                elec_nums =[];
            case 'S18_128_CG'
                elec_names ={''};
                elec_nums =[];
            case 'S19_129'
                elec_names = {''};
                elec_nums=[];
                
            case 'S18_130_RH'
                elec_names ={'LOF6','LOF7'};%,
                elec_nums =[6 7];
                
            case 'S18_131'
                elec_names = {'LAC1','LAC2','LAC3','LAC4','LAC5','LAC6','LAC7','LAC8','LAC9','LAC10','LAC11','LAC12','LAC13','RAC1','RAC2','RAC3','RAC13','RAC14'};
                elec_nums=[99:111 30:32 42 43];
                
        end
        
    case 'Hippocampus'
        switch sbj
            
            case 'S14_69_RTb'
                elec_names = {''};
                elec_nums =[];
            case 'S16_99_CJ'
                elec_names = {'LHH1','LHH2','LHH3','RAH1','RAH2','RAH3','RAH4',};
                elec_nums =[11 12 13 71:73];
            case 'S16_100_AF'
                elec_names = {'LAH1','LAH2','LAH3','RAH2','RAH3','RPH1'};
                elec_nums =[11:13 122 123 131];
            case 'S17_105_TA'
                elec_names = {''};
                elec_nums =[];
            case 'S17_110_SC'
                elec_names = {'RH1','RH2','LH1','LH2','LH3'};
                elec_nums =[71 72 21:23];
            case 'S17_112_EA'
                elec_names ={'RAH1','RAH2','RAH3','RAH4'};%
                elec_nums =[55 56 57 58];%55
            case 'S17_116'
                elec_names={''};
                elec_nums =[];
            case 'S17_118_TW'
                elec_names ={'LHIP1','LHIP2','RAH1','RAH2','RAH3'};
                elec_nums =[11 12 98 99 100];
            case 'S18_119_AG'
                elec_names ={'LHT21','LHT22','LHT23','LHT24'}%,'RHIP2','RHIP3'};
                elec_nums = [31 32 33 34 ]%92 93];
            case 'S18_124_JR2'
                elec_names ={'LHA1','LHA2','LHA3','LMH1','LMH2','LMH3','LPH2','LPH3'};
                elec_nums = [7 8 9 17 18 19 28 29];
            case 'S18_125'
                elec_names ={'RPH2','RPH3'};
                elec_nums =[2 3];
            case 'S13_47_JT2'
                elec_names ={''};
                elec_nums =[];
            case 'S12_42_NC'
                elec_names ={''};
                elec_nums =[];
            case 'S12_38_LK'
                elec_names ={''};
                elec_nums =[];
            case 'S12_33_DA'
                elec_names ={''};
                elec_nums =[];
            case 'S18_126'
                elec_names ={'LMH1','LMH2','LMH3','LMH4','LPH1','LPH2','LPH3','LPH4','RMH1','RMH2','RMH3','RMH4','RHP2'};
                elec_nums =[19:22 27:30 65:68 74];
                
            case 'S18_127'
                elec_names ={'LH1','LH2','LH3','RH1','RH2'};
                elec_nums =[11:13 81 82];
            case 'S18_128_CG'
                elec_names ={''};
                elec_nums =[];
            case 'S19_129'
                elec_names = {'RHI2','RHI3','RPHI3','RPHI4'};
                elec_nums=[];
                
            case 'S18_130_RH'
                elec_names ={'LAM2','LAM3','LAM4','RPMT2','RPMT3','RAMY2','RAMY3','RAMY4','RAMY5'};
                elec_nums =[22 23 24 93 94 83:86];
                
                
            case 'S18_131'
                elec_names = {'LAH1','RAHb1'};
                elec_nums=[1 65];
        end
end
end