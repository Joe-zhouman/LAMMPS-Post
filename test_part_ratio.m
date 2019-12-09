for idx = 1 : N_atoms
      a = trapz(omega,mean(pdos(:,idx),2));
      if a < 0.97
            a
      end
end
