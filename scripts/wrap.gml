///wrap(num, min, max)
var a = argument0 - argument2, b = argument1 - argument2, c = argument2, d = 0;
if argument0 > argument2{d = -(argument2 - argument1 - 1); a -= 1;}
return a % b + c + d;
/*
if argument0 < argument1{return argument2 - (argument1 - argument0 - 1);}else{
    if argument0 > argument2{return argument1 + (argument0 - argument2 - 1);}else{
        return argument0;}}
        

