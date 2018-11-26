*****************************************;
** SAS Scoring Code for PROC Logistic;
*****************************************;

length I_Ins $ 12;
label I_Ins = 'Into: Ins' ;
label U_Ins = 'Unnormalized Into: Ins' ;
format U_Ins BEST12.0;

label P_Ins1 = 'Predicted: Ins=1' ;
label P_Ins0 = 'Predicted: Ins=0' ;

drop _LMR_BAD;
_LMR_BAD=0;

*** Check interval variables for missing values;
if nmiss(DDA,DDABal,Sav,SavBal,CD,MMBal) then do;
   _LMR_BAD=1;
   goto _SKIP_000;
end;

*** Compute Linear Predictors;
drop _LP0;
_LP0 = 0;

*** Effect: DDA;
_LP0 = _LP0 + (-0.92553800918385) * DDA;
*** Effect: DDABal;
_LP0 = _LP0 + (0.00007090112372) * DDABal;
*** Effect: Sav;
_LP0 = _LP0 + (0.52504901205107) * Sav;
*** Effect: SavBal;
_LP0 = _LP0 + (0.00004929798836) * SavBal;
*** Effect: CD;
_LP0 = _LP0 + (1.02995657680612) * CD;
*** Effect: MMBal;
_LP0 = _LP0 + (0.00004949627759) * MMBal;

*** Predicted values;
drop _MAXP _IY _P0 _P1;
_TEMP = -0.6784404087426  + _LP0;
if (_TEMP < 0) then do;
   _TEMP = exp(_TEMP);
   _P0 = _TEMP / (1 + _TEMP);
end;
else _P0 = 1 / (1 + exp(-_TEMP));
_P1 = 1.0 - _P0;
P_Ins1 = _P0;
_MAXP = _P0;
_IY = 1;
P_Ins0 = _P1;
if (_P1 >  _MAXP + 1E-8) then do;
   _MAXP = _P1;
   _IY = 2;
end;
select( _IY );
   when (1) do;
      I_Ins = '1' ;
      U_Ins = 1;
   end;
   when (2) do;
      I_Ins = '0' ;
      U_Ins = 0;
   end;
   otherwise do;
      I_Ins = '';
      U_Ins = .;
   end;
end;
_SKIP_000:
if _LMR_BAD = 1 then do;
I_Ins = '';
U_Ins = .;
P_Ins1 = .;
P_Ins0 = .;
end;
drop _TEMP;
