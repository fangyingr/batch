function BN = BlockBySubj_CMC(sbj,task)

switch task
    case 'CMC'
        switch sbj
            case 'S01_HHL'
                BN = {'S01_HHL'};
            case 'S02_PJC'
                BN = {'S02_PJC'};
            case 'S03_FSM'
                BN = {'S03_FSM'};
            case 'S04_CWG'
                BN = {'S04_CWG'};
            case 'S05_PZY'
                BN = {'S05_PZY'};
            case 'S06_LXY'
                BN = {'S06_LXY'};
            case 'S07_YHY'
                BN ={'S07_YHY'};
            case 'S08_LWP'
                BN ={'S08_LWP'};
            case 'S09_XKW'
                BN ={'S09_XKW'};
            case 'S10_LZJ'
                BN ={'S10_LZJ'};
        end
end
end
