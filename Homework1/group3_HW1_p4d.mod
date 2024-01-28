reset;

set PROD; # products
set STAGE; # stages

param rate {PROD,STAGE} > 0; # tons per hour in each stage
param avail {STAGE} >= 0; # hours available/week in each stage
param profit {PROD}; # profit per ton
param commit {PROD} >= 0; # lower limit on tons sold in week
param market {PROD} >= 0; # upper limit on tons sold in week
param percent {PROD}; # percentage lower limit on tons

var Make {p in PROD} <= market[p]; # tons produced


maximize Total_Profit: sum {p in PROD} profit[p] * Make[p];
# Objective: total profits from all products
subject to Time {s in STAGE}: sum {p in PROD} (1/rate[p,s]) * Make[p] <= avail[s];
subject to percentage {p in PROD}: Make[p] >= percent[p]*(sum {r in PROD} Make[r]);
#subject to Time2 {s in STAGE}: sum {p in PROD} (1/rate[p,s]) * Make[p] >= avail[s];
# In each stage: total of hours used by all
# products may not exceed hours available

data group3_HW1_p4.dat;



solve;

printf "Number of Each Type of Part to Make: \n";
display Make;

printf "Number of Hours Used by Each Product \n";
display Time;
