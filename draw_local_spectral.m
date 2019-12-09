clc,clear,close all
za = 'armchair';
defect_type = 'Bn';
file_id = 1;
ii = 0;
for coverage = [1,4]
	ii = ii + 1;
    for times  = 2
        dump = times * 10; 
        load_path = ['D:\zm_documents\LAMMPS\hBN_defects\paper\',defect_type,...
                        '\',za,'\',num2str(file_id),'\',num2str(coverage),...
                        '\dump',num2str(dump)];
        load_name = 'local_ratio.mat';
		load_name2 = 'local_ratio2.mat';
        save_path = load_path;

        load_file_name = [load_path,'\',load_name];
		load_file_name2 = [load_path,'\',load_name2];
        load_cord=['D:\zm_documents\LAMMPS\hBN_defects\paper\',za,' data\data_file'...
                ,defect_type,'\2\test.mat'];

        load(load_file_name)
		load(load_file_name2)
        load(load_cord)

        load([load_path,'\','defect_idx.mat'])
        if strcmp(defect_type,'Bn')
			defect_color = 'm';
		else
			defect_color = 'b';
        end
        xq = linspace(min(test(:,3)),max(test(:,3)),100);
        yq = linspace(min(test(:,4)),max(test(:,4)),100);
        %zq = griddata(test(:,3),test(:,4),test(:,5),xq,yq','natural');
        Vq = griddata(test(:,3),test(:,4),localization_ratio,xq,yq','natural');
        
%         contourf(xq,yq,Vq)
%         axis equal
%         colormap jet
%         colorbar('northoutside');
%         
        figure(ii+5)
        Vq = Vq.*10000;
       % surf(xq,yq,Vq,'EdgeColor','none','FaceColor','interp')
        surf(xq,yq,Vq,'EdgeColor','none','FaceColor','interp','facelighting','none')
        axis equal
        colormap jet;
        c = colorbar('northoutside');
        c.Label.String = 'localization intensity / 1\times10^{-4}';
        caxis([1,10]);
        %view([0,0,90])
        hold on
        for idx = defect_idx
            plot3([test(idx,3),test(idx,3)],[test(idx,4),test(idx,4)],[6,max(max(Vq))],'Color',[0 0 0],'linestyle','-.')
            plot3(test(idx,3),test(idx,4),max(max(Vq)),'Color',defect_color,...
                'marker','v','markersize',10,'markerfacecolor',defect_color,'linestyle','none')
        end
        hold off
    end
end
