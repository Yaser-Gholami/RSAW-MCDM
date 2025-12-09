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

Variables
z
v(j)
alfa;

Positive Variable v, alfa;

Equations
objectiveFunction
eq1(i)
eq2(k);
objectiveFunction.. z =e= sum(j, v(j)*rrr(j));
eq1(i)..             sum(j, v(j)*r(i,j)) =l= 1;
eq2(k).. sum(j, A(k,j)*v(j)) - alfa*b(k) =g= 0;

Model test /all/;

Parameter results(o);

loop(o,

    rrr(j)=ro(o,j);
    solve test using LP maximizing z;

    results(o) = z.l;

);

display results,r ;

execute_unload 'output.gdx', results;

$call gdxxrw output.gdx results.xlsx par=results rng=Sheet1!A1