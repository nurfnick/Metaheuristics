reset;
option solver cplex;

set media;

 

param cost{media};


param customers{media};

param creative{media};



var time{media} >=0;

maximize eyeBalls: sum {m in media} time[m]*customers[m];

subject to totalFunds: sum {m in media} time[m]*cost[m] <= 1000000;
subject to someTV: time['TV']>=10;
subject to creativeManHours: sum {m in media} time[m]*creative[m]<= 100;


data;

set media := TV mag radio;

param cost :=
TV 		20000
mag 	10000
radio	2000;

param customers :=
TV 		1.8
mag		1
radio	0.25;

param creative :=
TV		1
mag		3
radio 	1;

solve;

display time;
display eyeBalls;
display creativeManHours;