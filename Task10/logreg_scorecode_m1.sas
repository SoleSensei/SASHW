*****************************************;
** SAS Scoring Code for PROC ;
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
if nmiss(DDA,DDABal,Sav,SavBal,CD,MM) then do;
   _LMR_BAD=1;
   goto _SKIP_000;
end;

*** Compute Linear Predictors;
drop _LP0;
_LP0 = 0;

*** Effect: DDA;
_LP0 = _LP0 + (-0.90353883548392) * DDA;
*** Effect: DDABal;
_LP0 = _LP0 + (0.0000739150574) * DDABal;
*** Effect: Sav;
_LP0 = _LP0 + (0.52770807545151) * Sav;
*** Effect: SavBal;
_LP0 = _LP0 + (0.00004904855028) * SavBal;
*** Effect: CD;
_LP0 = _LP0 + (1.02903142621538) * CD;
*** Effect: MM;
_LP0 = _LP0 + (0.83449794644494) * MM;

*** Predicted values;
drop _MAXP _IY _P0 _P1;
_TEMP = -0.70805707489346  + _LP0;
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
