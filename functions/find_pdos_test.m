function [pdos]=find_pdos_test(vacf,omega,net_time_points,delta_t)
% vacf(:): VACF
% omega: phonon angular frequency in units of ps^{-1}
% net_time_points: number of correlation time points
% delta_t: time interval between two measurements, in units of ps
% pdos(:): PDOS
vacf=vacf.*(cos(pi*(0:net_time_points-1)/net_time_points)+1)*0.5; % apply a window function
vacf=vacf.*[1,2*ones(1,net_time_points-1)]/pi; % C(t)=C(-t) and there is only one C(0)
pdos=zeros(length(omega),1); % phonon density of states
X = (0:net_time_points-1)*delta_t;
for n=1:length(omega) % Discrete cosine transformation
      Y = vacf.*cos(omega(n)*X);
      pdos(n)=trapz(X, Y);
end


