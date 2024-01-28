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
subject to someMag: time['mag'] >= 2; #constraint that at least two pages of magazine ads must be utilized
subject to notTooMuchRadio: time['radio'] <= 120; #constraint that no more than 120 minutes of radio time may be utilized


data; #define the sets and parameters

set media := TV mag radio; #define the three types of media

param cost := #define the cost of each type of media
TV 		20000
mag 	10000
radio	2000;

param customers := #define how many customers each type of media will reach
TV 		1.8
mag		1
radio	0.25;

param creative := #define the number of person-weeks to create each type of advertising
TV		1
mag		3
radio 	0.1428;

solve;

printf "Solution: \n"; #print the total audience, creative person-weeks left over, and amount of pages/minutes purchased in each type of media
printf "Total Audience in Millions of Viewers: %g\n", eyeBalls;
printf "Creative Person-Weeks Left Over: %g\n", creativeManHours.slack;
printf "Amount of Advertising Purchased per Type of Media: \n" ;
display time;

/*
display time;
display eyeBalls;
display creativeManHours;
*/