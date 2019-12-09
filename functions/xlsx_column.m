%% find the row character in excel
function column_char = xlsx_column( column_idx)
% column_idx :           the index of column
% column_char :         the index of column in excel
% idx -- char
%1 - 26 :       A - Z
%27 - 52 :     AA - AZ
%           ......
column_idx = column_idx -1;
char1 = fix(column_idx/26);
char2 = mod(column_idx,26);
if char1 == 0
        char1 = '';
else
        char1 = char(char1 + 64);
end
char2 = char(char2 + 65);
column_char = [char1 , char2 ];
end

