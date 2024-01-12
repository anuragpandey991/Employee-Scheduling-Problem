Sets
    i no of days /1*7/ 
    j employee /1*5/
    l level /1,2/;
    
Variables
    var_M(i, j, l)
    var_E(i, j, l)
    var_O(i,j, l)
    Z;
    
Binary Variables
    var_M(i, j, l) 1 if an employee works on a morning shift of a particular day
    var_E(i, j, l)
    var_O(i,j, l);

Parameters    
    cost(l)    wages paid to employee working on a regular shift
    / 1 100, 2 50/
    cost_overtime(l) wages paid to employee working on a overtime shift
    / 1 120,2 75/;

Scalar beta1 /3/
beta2 /2/;

Equations
    ShiftRequirements1(i,l)
    ShiftRequirements2(i,l)
    ShiftRequirementsME1(i)
    ShiftRequirementsME2(i)
    OneShiftPerDay(i,j, l)
    MaxWorkingDays(j, l)
    SameShiftM(i, j, l)
    SameShiftE(i, j, l)
    ShiftRotationM(i, j, l)
    ShiftRotationE(i, j, l)
    OvertimeLimit(j, l)
    ObjectiveFunction;

ShiftRequirements1(i,l)$(l.val =1).. 
    sum(j, var_M(i, j, l)+var_E(i,j,l)+var_O(i,j,l)) =g= 2;

ShiftRequirements2(i,l)$(l.val =2).. 
    sum(j, var_M(i, j, l)+var_E(i,j,l)+var_O(i,j,l)) =g= 4;

ShiftRequirementsME1(i).. 
    sum((j,l), var_M(i, j, l)) - sum((j,l), var_E(i, j, l))=l= 1;

ShiftRequirementsME2(i).. 
    sum((j,l), var_E(i, j, l)) - sum((j,l), var_M(i, j, l))=l= 1;

OneShiftPerDay(i,j,l).. 
    var_M(i, j, l) + var_E(i, j, l)+var_O(i,j,l) =l= 1;

MaxWorkingDays(j, l)..
   sum((i), var_M(i, j, l) + var_E(i, j, l)) =e= 5;

SameShiftM(i, j, l)..
  var_M(i, j, l) + var_E(i+1, j, l) =l= 1;
SameShiftE(i, j, l)..
   var_M(i+1, j, l) + var_E(i, j, l) =l= 1;

ShiftRotationM(i, j, l)..
   var_M(i, j, l) + var_M(i+7, j, l) =l= 1;

ShiftRotationE(i, j, l)..
    var_E(i, j, l) + var_E(i+7, j, l) =l= 1;
    
OvertimeLimit(j, l)..
    sum(i, var_O(i,j,l)) =l= 2;

ObjectiveFunction..
   Z =e= beta1*sum((i,j,l), (var_M(i,j,l)+var_E(i,j,l))*cost(l)+var_O(i,j,l)*cost_overtime(l))+ beta2*sum((i,j,l), var_O(i,j,l));

Model EmployeeScheduling /all/;
EmployeeScheduling.OptFile = 1;
Solve EmployeeScheduling using MIP minimizing Z;