%% write lammps in file
clc,clear,close all

%% define some variables
os = 'ubuntu';
if strcmp(os, 'windows')
        roma_num = {'1','2','3','4','5','6','7','8','9','10'};
else
        roma_num = {'i','ii','iii','iv','v','vi','vii','viii','ix','x','xi','xii','xiii','xiv','xv','xvi'};
end
defect_type = 'size';
za = 'a';
for file_id = 1
rand_vel = 56148646;
potential_type = 'BN.extep';
lmp_mpi_path = 'D:\zm_documents\LAMMPS\hBN_defects\paper';
lmp_mpi_name = 'lmp_mpi.exe';
mpich_name = 'mpiexec.exe';
for model_size = [2,3,4,5,8,16]
        %% define in file path
        %save_path = ['D:\zm_documents\LAMMPS\hBN_defects\paper\',...
        %        defect_type,za,roma_num{file_id},'\',char(roma_num{cvg})];
        save_path = ['D:\zm_documents\LAMMPS\hBN_defects\paper\',...
                defect_type,za,'\',char(roma_num{model_size})];
        mkdir(save_path);
        save_name = 'hBN_dnh_p_as.in';
        save_file = [save_path,'\',save_name];
        
        %% define data file 
        if za == 'z'
                temp = 'zigzag';
        elseif za == 'a'
                temp = 'armchair';
        else
                error("z for zigzag and a for armchair, please");
        end
        %data_file_path = ['D:\zm_documents\LAMMPS\hBN_defects\paper\'...
        %      ,temp,' data\data_file',defect_type,'\',num2str(cvg)];
        data_file_path = 'D:\zm_documents\mathworks\car2data\hbn_armchair';
        %data_file_name = ['hBN',za,'_',defect_type,'_cv',num2str(cvg),'_',num2str(file_id),'.data'];
        data_file_name =['hBN',num2str(model_size),za,'.data'];
        data_file = [data_file_path,'\',data_file_name];
        %% copy data file
        copyfile(data_file,save_path);
        
        
        %% copy lmp.exe and mpi.exe
        if strcmp(os, 'windows')
                copyfile([lmp_mpi_path,'\',lmp_mpi_name],save_path);
                copyfile([lmp_mpi_path,'\',mpich_name],save_path);
        end
        %% copy potential file 
        potential_file_path = 'E:\softwares\LAMMPS\Potentials';
        potential_file = [potential_file_path,'\',potential_type];
        copyfile(potential_file,save_path);
        
        %% print data file
        fid = fopen(save_file,'w');

        fprintf(fid,'##Initialization\r\n');
        fprintf(fid,'units           metal\r\n');
        fprintf(fid,'dimension       3\r\n');
        fprintf(fid,'boundary	p p p\r\n');
        fprintf(fid,'\r\n\r\n');

        fprintf(fid,'#define some variables\r\n');
        fprintf(fid,'variable    T0              equal   300\r\n');                                                    
        fprintf(fid,'variable    TS    	        equal   0.00025     \r\n');
        fprintf(fid,'variable    delta_T	        equal   20              \r\n'); 
        fprintf(fid,'variable    T_left_hb   	equal   ${T0}-${delta_T}     \r\n');                            
        fprintf(fid,'variable    T_right_hb      equal   ${T0}+${delta_T}    \r\n');      
        fprintf(fid,'\r\n\r\n');

        fprintf(fid,'#read data\r\n');
        fprintf(fid,'read_data 	%s\r\n',data_file_name);
        fprintf(fid,'change_box all	z	final	-30.0	30.0\r\n');
        fprintf(fid,'mass 	1	10.8\r\n');
        fprintf(fid,'mass	2	14\r\n');
        fprintf(fid,'\r\n\r\n');

        fprintf(fid,'#define potential\r\n');
        fprintf(fid,'pair_style	extep\r\n');
        fprintf(fid,'pair_coeff	* *	BN.extep	B N\r\n');
        fprintf(fid,'\r\n\r\n');	

        fprintf(fid,'neighbor	2.0	bin\r\n');
        fprintf(fid,'\r\n\r\n');

        fprintf(fid,'#initialize velocity according to temperature\r\n');
        fprintf(fid,'velocity	all	create	${T0}	%d\r\n',rand_vel);
        fprintf(fid,'timestep	${TS}\r\n');
        fprintf(fid,'thermo_style	custom	step	press	temp\r\n');
        fprintf(fid,'thermo_modify	lost	warn\r\n');
        fprintf(fid,'thermo		4000\r\n');
        fprintf(fid,'\r\n\r\n');

        fprintf(fid,'#dump atoms\r\n');
        fprintf(fid,'dump	mydump	all	custom	5000	dump.position	id type x y z\r\n');
        fprintf(fid,'dump_modify	mydump	sort id\r\n');
        fprintf(fid,'\r\n\r\n');

        fprintf(fid,'#energy minimization\r\n');
        fprintf(fid,'min_style 	cg\r\n');
        fprintf(fid,'minimize	1.0e-6 1e-6 1000000 1000000\r\n');
        fprintf(fid,'write_dump	all     custom	minimization.position	id type x y z\r\n');
        fprintf(fid,'\r\n\r\n');

        fprintf(fid,'#equilibrium in NVT ensemble in 300K\r\n');
        fprintf(fid,'fix	NVT 	all	nvt	temp	${T0}	${T0}	$(100*dt)\r\n');
        fprintf(fid,'\r\n\r\n');

        fprintf(fid,'run		1000000\r\n');
        fprintf(fid,'unfix           NVT\r\n');
        fprintf(fid,'\r\n\r\n');

        fprintf(fid,'#equilibrium in NPT ensemble in 300K, 0Pa\r\n');
        fprintf(fid,'fix    NPT    all    npt    temp    ${T0}    ${T0}    $(100*dt)    &\r\n');
        fprintf(fid,'	iso	0	0	$(1000*dt)   \r\n');
        fprintf(fid,'run        1000000\r\n');
        fprintf(fid,'unfix NPT\r\n');
        fprintf(fid,'\r\n\r\n');

        fprintf(fid,'#non_equilibrium	\r\n');
        fprintf(fid,'fix	    NVE		all	nve\r\n');
        fprintf(fid,'dump	VALL1	all	custom 10	dump10.vel	id 	type 	vx	vy	vz	\r\n');
        fprintf(fid,'dump_modify VALL1 sort id\r\n');
        fprintf(fid,'run 60000\r\n');
        fprintf(fid,'undump VALL1\r\n');
        fprintf(fid,'\r\n\r\n');

        fprintf(fid,'dump	VALL2	all	custom 20	dump20.vel	id 	type 	vx	vy	vz	\r\n');
        fprintf(fid,'dump_modify VALL2 sort id\r\n');
        fprintf(fid,'run 120000\r\n');
        fprintf(fid,'\r\n\r\n');

        fprintf(fid,'undump VALL2\r\n');
        fprintf(fid,'unfix   NVE\r\n');
        fprintf(fid,'\r\n\r\n');

        fprintf(fid,'#define hot and cold region\r\n');
        fprintf(fid,'variable	DELTAL	        equal	lx/41\r\n');
        fprintf(fid,'variable	COLDMIN	        equal	xlo\r\n');
        fprintf(fid,'variable	COLDMAX	        equal	xlo+2*${DELTAL}\r\n');
        fprintf(fid,'variable	HOTMIN	        equal	xhi-3*${DELTAL}\r\n');
        fprintf(fid,'variable	HOTMAX	        equal	xhi-${DELTAL}\r\n');
        fprintf(fid,'variable        fixedmin        equal   xhi-${DELTAL}\r\n');
        fprintf(fid,'variable        fixedmax        equal   xhi\r\n');
        fprintf(fid,'region	COLD	block	        ${COLDMIN}	${COLDMAX}	INF	INF	INF	INF\r\n');
        fprintf(fid,'region	HOT	block	        ${HOTMIN}	${HOTMAX}	INF	INF	INF	INF\r\n');
        fprintf(fid,'region  fixed   block           ${fixedmin}     ${fixedmax}     INF     INF     INF     INF\r\n');
        fprintf(fid,'group   fixed   region          fixed\r\n');
        fprintf(fid,'group   COLD    region          COLD\r\n');
        fprintf(fid,'group   HOT     region          HOT\r\n');
        fprintf(fid,'group   unfixed         subtract        all     fixed\r\n');
        fprintf(fid,'group   unheated        subtract        unfixed     COLD    HOT\r\n');
        fprintf(fid,'\r\n\r\n');

        fprintf(fid,'#freeze atoms in fixed area\r\n');
        fprintf(fid,'velocity        fixed   set             0.0 0.0 0.0\r\n');
        fprintf(fid,'fix freeze      fixed   setforce        0.0 0.0 0.0\r\n');
        fprintf(fid,'compute         Tleft   all temp/region COLD\r\n');
        fprintf(fid,'compute         Tright  all temp/region HOT\r\n');
        fprintf(fid,'\r\n\r\n');

        fprintf(fid,'#1st equilibrated\r\n');
        fprintf(fid,'fix		COLD            COLD		nvt	temp	${T_left_hb}	${T_left_hb} 	0.25 \r\n');
        fprintf(fid,'fix	        HOT	        HOT	        nvt	temp	${T_right_hb}	${T_right_hb}	0.25\r\n');
        fprintf(fid,'fix             NVE_unheated    unheated        nve\r\n');
        fprintf(fid,'fix             NVE_fixed       fixed           nve\r\n');
        fprintf(fid,'fix_modify	COLD            temp            Tleft		\r\n');			
        fprintf(fid,'fix_modify	HOT             temp            Tright\r\n');
        fprintf(fid,'compute		Tunfixed 	unfixed		temp\r\n');
        fprintf(fid,'variable	Tdiff		equal	c_Tright-c_Tleft\r\n');
        fprintf(fid,'thermo_style	custom	        step	c_Tleft	c_Tunfixed c_Tright v_Tdiff	press   f_COLD   f_HOT lx\r\n');
        fprintf(fid,'run		4000000\r\n');
        fprintf(fid,'\r\n\r\n');

        fprintf(fid,'#2nd equilibrated\r\n');
        fprintf(fid,'reset_timestep 0	\r\n');
        fprintf(fid,'\r\n\r\n');

        fprintf(fid,'fix		COLD            COLD		nvt	temp	${T_left_hb}	${T_left_hb}	0.25   \r\n');
        fprintf(fid,'fix	        HOT	        HOT	        nvt	temp	${T_right_hb}	${T_right_hb}	0.25\r\n');
        fprintf(fid,'fix_modify	COLD            temp            Tleft	\r\n');				
        fprintf(fid,'fix_modify	HOT             temp            Tright\r\n');
        fprintf(fid,'\r\n\r\n');

        fprintf(fid,'#thermal conductivity calculation\r\n');
        fprintf(fid,'#compute the tempetature of a single atom\r\n');
        fprintf(fid,'compute	        KE	all	ke/atom\r\n');
        fprintf(fid,'variable	KB	equal	8.62e-5\r\n');
        fprintf(fid,'variable	TEMP	atom	c_KE/1.5/${KB}\r\n');
        fprintf(fid,'\r\n\r\n');

        fprintf(fid,'#compute the temperature of 40 blocks\r\n');
        fprintf(fid,'compute BLOCKS40 all chunk/atom bin/1d x lower 0.025 units reduced\r\n');
        fprintf(fid,'fix     T_PROFILE40 all ave/chunk 100 20000 2000000 BLOCKS40 v_TEMP file 40.temp\r\n');
        fprintf(fid,'\r\n\r\n');

        fprintf(fid,'#compute the temperature of 80 blocks\r\n');
        fprintf(fid,'compute BLOCKS80 all chunk/atom bin/1d x lower 0.0125 units reduced\r\n');
        fprintf(fid,'fix     T_PROFILE80 all ave/chunk 100 20000 2000000 BLOCKS80 v_TEMP file 80.temp\r\n');
        fprintf(fid,'\r\n\r\n');

        fprintf(fid,'#compute the temperature of 160 blocks\r\n');
        fprintf(fid,'compute BLOCKS160 all chunk/atom bin/1d x lower 0.00625 units reduced\r\n');
        fprintf(fid,'fix     T_PROFILE160 all ave/chunk 100 20000 2000000 BLOCKS160 v_TEMP file 160.temp\r\n');
        fprintf(fid,'\r\n\r\n');

        fprintf(fid,'run     6000000\r\n');
        fprintf(fid,'write_dump	all     custom	final.position	id type x y z\r\n');
        
        
        fclose(fid);
end
end
