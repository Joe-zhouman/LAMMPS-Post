%% write bash file
clc,clear,close all

%% define some variables
os = 'ubuntu';  
processor = 20;
roma_num =  {'i','ii','iii','iv','v','vi','vii','viii','ix','x','xi','xii','xiii','xiv','xv','xvi'};
defect_types = {'Nb','Bn','size'};
za = 'a';
file_id = 3;


in_file_name = 'hBN_dnh_p_as.in';

lammps_str = ['mpirun  -np ',num2str(processor),' lmp_',os,' -in ',in_file_name];

bash_file = ['D:\zm_documents\mathworks\NEMD\',za,roma_num{file_id},'.sh'];


fid = fopen(bash_file,'w');


fprintf(fid,'startTime=`date +%%Y%%m%%d-%%H:%%M`\n');
fprintf(fid,'startTime_s=`date +%%s`\n\n');
% for defect_type = 2
%         fprintf(fid,'###\n\n');
%         fprintf(fid,'cd\t%s\n\n',[defect_types{defect_type},za,roma_num{file_id}]);
%         for cvg = 1:2:9
%                 fprintf(fid,'###\n\n');
%                 fprintf(fid,'cd\t%s\n\n',roma_num{cvg});
%                 fprintf(fid,'sleep\t5\n\n');
%                 fprintf(fid,'%s\n\n',lammps_str);
%                 fprintf(fid,'sleep\t5\n\n');
%                 fprintf(fid,'cd\t..\n\n');              
%         end
%         fprintf(fid,'cd\t..\n\n');
% end
% for defect_type = 1:2
%         fprintf(fid,'###\n\n');
%         fprintf(fid,'cd\t%s\n\n',[defect_types{defect_type},za,roma_num{file_id}]);
%         for cvg = 1:2:9
%                 fprintf(fid,'###\n\n');
%                 fprintf(fid,'cd\t%s\n\n',roma_num{cvg});
%                 fprintf(fid,'sleep\t5\n\n');
%                 fprintf(fid,'%s\n\n',lammps_str);
%                 fprintf(fid,'sleep\t5\n\n');
%                 fprintf(fid,'cd\t..\n\n');
%         end
%         fprintf(fid,'cd\t..\n\n');
% end    
for defect_type = 3
        fprintf(fid,'###\n\n');
        fprintf(fid,'cd\t%s\n\n',[defect_types{defect_type},za]);
        for model_size = [2,3,4,5,8,16]
                fprintf(fid,'###\n\n');
                fprintf(fid,'cd\t%s\n\n',roma_num{model_size});
                fprintf(fid,'sleep\t5\n\n');
                fprintf(fid,'%s\n\n',lammps_str);
                fprintf(fid,'sleep\t5\n\n');
                fprintf(fid,'cd\t..\n\n');
        end
        fprintf(fid,'cd\t..\n\n');
end    
fprintf(fid,'###########   clock\n\n');
fprintf(fid,'endTime=`date +%%Y%%m%%d-%%H:%%M`\n');
fprintf(fid,'endTime_s=`date +%%s`\n');
fprintf(fid,'sumTime=$[ $endTime_s - $startTime_s ]\n');
fprintf(fid,'Hour=$[sumTime/3600]\n');
fprintf(fid,'echo "$startTime ---> $endTime" "Total:$Hour  hours"');

fclose(fid);
