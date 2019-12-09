function [ pdos_type ] = pdos_id2type( pdos_type_id )
%pdos_id2type  transform defect type id to defect type
%  only useful for hBN antisite and substitution
        switch pdos_type_id
            case 1
                pdos_type = '_in_plane';
            case 2 
                pdos_type = '_out_plane';
            case 3
                pdos_type = '';
            otherwise
                error_message = ['wrong pdos type id' ...
                    ,13,'    1.  in-plane pdos' ...
                    ,13,'    2.  out-plane pdos' ...
                    ,13,'    3.  normal pdos'];
                error(error_message)
        end
end

