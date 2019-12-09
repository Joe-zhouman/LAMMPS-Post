%% write pdos and vacf file to excel
clc,clear,close all


%% define save path and file name
save_path = 'D:\zm_documents\LAMMPS\hBN_defects\paper\Nb';
save_name = [save_path,'\pdos_vacf.xlsx'];
filename = save_name;

Cvacf = {{'vacf'}, {'in-plane vacf'}, {'out-plane vacf'}};
Cpdos = {{'pdos'}, {'in-plane pdos'}, {'out-plane pdos'}};

B = 0 :1 : 400;
sheet = 'zigzag1';
column_idx = 1;
column_char = xlsx_column(column_idx);
%%
for times = 1 : 2
        dump = times * 10;        
%% write correlation time  
         xlRange = [column_char, '1'];
        xlswrite(filename,{['dump ',num2str(dump)]},sheet,xlRange)
        
        xlRange = [column_char, '2'];
        xlswrite(filename,{'corelation time'},sheet,xlRange)

        xlRange = [column_char, '3'];
        A = linspace(0,0.00025 * dump* 999, 1000);
        xlswrite(filename,A',sheet,xlRange)
                
        column_idx = column_idx + 1;
        column_char = xlsx_column(column_idx);
                
%% write omega                
        xlRange = [column_char, '2'];
        xlswrite(filename,{'omega'},sheet,xlRange)

        xlRange = [column_char, '3' ];
        xlswrite(filename,B',sheet,xlRange)  
                
        column_idx = column_idx + 1;
        column_char = xlsx_column(column_idx);     
        
        for cvg = 10 : 5 : 35
%% load pdos and vacf file
                load_path = ['D:\zm_documents\LAMMPS\hBN_defects\paper\Nb\zigzag\1\'...
                      ,num2str(cvg),'\dump',num2str(dump)];
                load_file = [load_path,'\vacf_pdos.mat'];

                load(load_file);

%% write vacf 
                xlRange = [column_char, '1'];
                xlswrite(filename,cvg,sheet,xlRange)
                for idx = 1 : 3
                        xlRange = [column_char, '2'];
                        xlswrite(filename,Cvacf{idx},sheet,xlRange)
                        
                        xlRange = [column_char, '3'];
                        xlswrite(filename,vacf(:,idx),sheet,xlRange)
                        
                        column_idx = column_idx + 1;
                        column_char = xlsx_column(column_idx);
                end

                column_idx = column_idx + 1;
                column_char = xlsx_column(column_idx);
                
%% write pdos
                for idx = 1 : 3
                        xlRange = [column_char, '2'];
                        xlswrite(filename,Cpdos{idx},sheet,xlRange)
                        
                        xlRange = [column_char, '3'];
                        xlswrite(filename,pdos(:,idx),sheet,xlRange)
                        
                        column_idx = column_idx + 1;
                        column_char = xlsx_column(column_idx);
                end

                column_idx = column_idx + 1;
                column_char = xlsx_column(column_idx);
         end
end
