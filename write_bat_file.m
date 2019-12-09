%% write bash file
clc,clear,close all

%% define some variables
os = 'windows';  
roma_num = {'1','2','3','4','5','6','7','8','9','10'};
processor = 56;
defect_types = {'Nb','Bn'};
za = 'z';



in_file_name = 'hBN_dnh_p_as.in';

lammps_str = ['mpiexec -np ',num2str(processor),' -localonly lmp_mpi.exe -in ',in_file_name];

bat_file = ['D:\zm_documents\mathworks\NEMD\','zigzag','.bat'];


fid = fopen(bat_file,'w');
for file_id = 2:3
for defect_type = 1:2
        for cvg = 2:2:8
                filename = ['F:\ZM\',defect_types{defect_type},za,num2str(file_id),'\',num2str(cvg)];
                fprintf(fid,'cd\t%s\r\n\r\n',filename);
                fprintf(fid,'TIMEOUT /T 5\r\n\r\n');
                fprintf(fid,'%s\r\n\r\n',lammps_str);
                fprintf(fid,'TIMEOUT /T 5\r\n\r\n');         
        end
end

for defect_type = 1:2
        for cvg = 1:2:9
                filename = ['F:\ZM\',defect_types{defect_type},za,num2str(file_id),'\',num2str(cvg)];
                fprintf(fid,'cd\t%s\r\n\r\n',filename);
                fprintf(fid,'TIMEOUT /T 5\r\n\r\n');
                fprintf(fid,'%s\r\n\r\n',lammps_str);
                fprintf(fid,'TIMEOUT /T 5\r\n\r\n');
        end
end  
end
fclose(fid);
