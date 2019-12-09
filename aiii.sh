startTime=`date +%Y%m%d-%H:%M`
startTime_s=`date +%s`

###

cd	sizea

###

cd	ii

sleep	5

mpirun  -np 20 lmp_ubuntu -in hBN_dnh_p_as.in

sleep	5

cd	..

###

cd	iii

sleep	5

mpirun  -np 20 lmp_ubuntu -in hBN_dnh_p_as.in

sleep	5

cd	..

###

cd	iv

sleep	5

mpirun  -np 20 lmp_ubuntu -in hBN_dnh_p_as.in

sleep	5

cd	..

###

cd	v

sleep	5

mpirun  -np 20 lmp_ubuntu -in hBN_dnh_p_as.in

sleep	5

cd	..

###

cd	viii

sleep	5

mpirun  -np 20 lmp_ubuntu -in hBN_dnh_p_as.in

sleep	5

cd	..

###

cd	xvi

sleep	5

mpirun  -np 20 lmp_ubuntu -in hBN_dnh_p_as.in

sleep	5

cd	..

cd	..

###########   clock

endTime=`date +%Y%m%d-%H:%M`
endTime_s=`date +%s`
sumTime=$[ $endTime_s - $startTime_s ]
Hour=$[sumTime/3600]
echo "$startTime ---> $endTime" "Total:$Hour  hours"