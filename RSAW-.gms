Sets
    i /1*315/
    j /1*5/
    k /1*10/
    o /1*315/;
Parameter r(i,j);

$call GDXXRW input.xlsx par=r rdim=1 cdim=1
$GDXIN input.gdx
$load r
$GDXIN

Table A(k,j)
         1   2   3   4   5
1        1   0   0   0   0
2       -1   0   0   0   0
3        0   1   0   0   0
4        0  -1   0   0   0
5        0   0   1   0   0
6        0   0  -1   0   0
7        0   0   0   1   0
8        0   0   0  -1   0
9        0   0   0   0   1
10       0   0   0   0  -1;

Parameter b(k) /
    1   0.15,
    2  -0.30,
    3   0.20,
    4  -0.35,
    5   0.15,
    6  -0.30,
    7   0.05,
    8  -0.15,
    9   0.10,
    10 -0.20 /;


Parameter ro(o,j);
ro(o,j) = sum(i$(ord(i) = ord(o)), r(i,j));

parameter rrr(j);
parameter rr(j);
Variables
z
v(j)
alfa;

Positive Variable v, alfa;

Equations
objectiveFunction
eq1
eq2(k);
objectiveFunction.. z =e= sum(j, v(j)*rrr(j));
eq1..             sum(j, v(j)*rr(j)) =e= 1;
eq2(k).. sum(j, A(k,j)*v(j)) - alfa*b(k) =g= 0;

Model test /all/;

Parameter results1(o);
Parameter results2(i);

loop(o,

    rrr(j)=ro(o,j);
    loop(i,
        rr(j)=r(i,j);
        solve test using LP min z;
        results2(i) = z.l;);
    results1(o) = smin(i, results2(i));
);

display results1;

execute_unload 'output1.gdx', results1;

$call gdxxrw output1.gdx results1.xlsx par=results rng=Sheet1!A1
