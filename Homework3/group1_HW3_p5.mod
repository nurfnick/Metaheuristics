# AMPL model for the Minimum Cost Network Flow Problem
#
# By default, this model assumes that b[i] = 0, c[i,j] = 0,
# l[i,j] = 0 and u[i,j] = Infinity.
#
# Parameters not specified in the data file will get their default values.
reset; 

options solver cplex;
option cplex_options 'sensitivity';

set NODES;                        # nodes in the network
set ARCS within {NODES, NODES};   # arcs in the network 

param b {NODES} default 0;        # supply/demand for node i
param c {ARCS}  default 0;        # cost of one of flow on arc(i,j)
param l {ARCS}  default 0;        # lower bound on flow on arc(i,j)
param u {ARCS}  default Infinity; # upper bound on flow on arc(i,j)
param mu {ARCS} default 1;       # multiplier on arc(i,j) -- if one unit leaves i, mu[i,j] units arrive

var x {ARCS};                     # flow on arc (i,j)
 
minimize cost: sum{(i,j) in ARCS} c[i,j] * x[i,j];  #objective: minimize arc flow cost

# Flow Out(i) - Flow In(i) = b(i)

subject to flow_balance {i in NODES}:
sum{j in NODES: (i,j) in ARCS} x[i,j] - sum{j in NODES: (j,i) in ARCS} mu[j,i] * x[j,i] = b[i];

subject to upcapacity {(i,j) in ARCS}: x[i,j] <= u[i,j];

subject to lowcapacity {(i,j) in ARCS}: l[i,j] <= x[i,j]; 

data group1_HW3_p5.dat;

solve;

display x;

display upcapacity,upcapacity.up, upcapacity.down;

display x.current, x.up, x.down;
