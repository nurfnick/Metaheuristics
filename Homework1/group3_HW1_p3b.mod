reset;
option solver cplex;

set media;

 

param cost{media};


param customers{media};

param creative{media};



var time{media} >=0;

maximize eyeBalls: sum {m in media} time[m]*customers[m]; #define the objective function

subject to totalFunds: sum {m in media} time[m]*cost[m] <= 1000000; #constraint that the total advertising budget is one million dollars
subject to someTV: time['TV']>=10; #constraint that at least ten minutes of TV time must be utilized
subject to creativeManHours: sum {m in media} time[m]*creative[m]<= 100; #constraint that the total person-weeks may not exceed 100

data; #define the sets and parameters

set media := TV mag; #define the two types of media

param cost := #define the cost of each type of media
TV 		20000
mag 	10000;

param customers := #define how many customers each type of media will reach
TV 		1.8
mag		1;

param creative := #define the number of person-weeks to create each type of advertising
TV		1
mag		3;

solve;

printf "Solution: \n"; #print the total audience and amount of pages/minutes purchased in each type of media
printf "Total Audience in Millions of Viewers: %g\n", eyeBalls;
printf "Amount of Advertising Purchased per Type of Media: \n" ;
display time;

/*
display time;
display eyeBalls;
*/
