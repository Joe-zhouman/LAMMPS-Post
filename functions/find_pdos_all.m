function [pdos]=find_pdos_all(vacf,omega,net_time_points,delta_t)
% vacf(:): VACF
% omega: phonon angular frequency in units of ps^{-1}
% net_time_points: number of correlation time points
% delta_t: time interval between two measurements, in units of ps
% pdos(:): PDOS
pdos=zeros(length(omega),3); % phonon density of states
for i = 1:2
        temp = vacf(:,i);
        temp=temp.'.*(cos(pi*(0:net_time_points-1)/net_time_points)+1)*0.5; % apply a window function
        temp=temp.*[1,2*ones(1,net_time_points-1)]/pi; % C(t)=C(-t) and there is only one C(0)
        
        for n=1:length(omega) % Discrete cosine transformation
                pdos(n,i)=delta_t*sum(temp.*cos(omega(n)*(0:net_time_points-1)*delta_t));
        end
end
pdos(:,3) = pdos(:,1) - pdos(:,2);


