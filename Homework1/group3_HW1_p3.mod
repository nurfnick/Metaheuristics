reset;
option solver cplex;

set media;

 

param cost{media};


param customers{media};



var time{media} >=0;

maximize eyeBalls: sum {m in media} time[m]*customers[m]; #define the objective function

subject to totalFunds: sum {m in media} time[m]*cost[m] <= 1000000; #constraint that the total advertising budget is one million dollars
subject to someTV: time['TV']>=10; #constraint that at least ten minutes of TV time must be utilized

data; #define the sets and parameters

set media := TV mag; #define the two types of media

param cost := #define the cost of each type of media
TV 		20000
mag 	10000;

param customers := #define how many customers each type of media will reach
TV 		1.8
mag		1;


solve;

printf "Solution: \n"; #print the total audience, total funds left over, and amount of pages/minutes purchased in each type of media
printf "Total Audience in Millions of Viewers: %g\n", eyeBalls;
printf "Advertising Budget Left Over in Dollars: %g\n", totalFunds;
printf "Amount of Advertising Purchased per Type of Media: \n" ;
display time;

/*
display time;
display totalFunds;
display eyeBalls;
*/
