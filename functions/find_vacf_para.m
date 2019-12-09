function [vacf]=find_vacf_para(v_all,time_origins,net_time_points)
% v_all(:,:,:): all the velocity data
% time_origins: number of "time origins" used in "time average"
% net_time_points: number of correlation time points
% vacf(:): VACF data
N_atoms = length(v_all(:,1,1));
vacf=zeros(N_atoms,net_time_points);
for nt=0:net_time_points-1
    for m=1:time_origins
        vacf(:,nt+1)=vacf(:,nt+1)+sum(v_all(:,:,m).*v_all(:,:,m+nt),2);
    end
end
vacf=vacf./vacf(:,1);
