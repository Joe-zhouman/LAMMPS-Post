clc,clear,close all
za = 'armchair';
defect_type = 'Nb';
for file_id = 1:3
for coverage = 1:9

load_path = ['D:\zm_documents\LAMMPS\hBN_defects\paper\'...
	za,' data\data_file',defect_type,'\',num2str(coverage)];

load_name = ['hBN',za(1),'_',defect_type,'_cv',num2str(coverage),...
	'_',num2str(file_id),'_rand_antisite.data'];
try
	fid = fopen([load_path,'\',load_name]);
	formatSpec='%s';
	C=textscan(fid,formatSpec,'Delimiter','\t');
	defect_idx = zeros(1,length(C{1})-2);
	ii = 0;
	for idx = 1:length(C{1})
		if ~contains(C{1}(idx),'I')
			ii = ii + 1;
			defect_idx(ii) = str2double(C{1}(idx));
		end
	end
catch ME
    rethrow(ME)
end
fclose(fid);
save_path = ['D:\zm_documents\LAMMPS\hBN_defects\paper\',defect_type,...
             '\',za,'\',num2str(file_id),'\',num2str(coverage),'\dump20'];
save_name = 'defect_idx.mat';
save([save_path,'\',save_name],'defect_idx')
end
end
