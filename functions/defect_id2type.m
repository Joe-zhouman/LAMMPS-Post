function [ defect_type ] = defect_id2type( defect_type_id )
%% defect_id2type transform defect type id to defect type
%  only useful for hBN antisite and substitution
switch defect_type_id
    case 1
        defect_type = 'rand_as';
    case 2
        defect_type = 'neib_as';
    case 3 
        defect_type = 'Bn';
    case 4
        defect_type = 'Nb';
    case 5
        defect_type = 'test';
    otherwise
        error('wrong defect type')
end
end

