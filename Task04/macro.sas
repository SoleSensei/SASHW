
****************************************************;
* Create file1 input file;
****************************************************;
 data work.narrow_file1;
     infile cards;
     length pet_owner $10 pet $4 population 4;
     input pet_owner $1-10 pet $ population;
 cards;
 Mr. Black dog 2
 Mr. Black bird 1
 Mrs. Green fish 5
 Mr. White cat 3
 ; 
 run; 
/* определение макроса */
OPTIONS NOSYMBOLGEN;
OPTIONS NOMPRINT;
OPTIONS NOMLOGIC;
OPTIONS MCOMPILENOTE=none;
%macro transpose_dataset_vars(ds=, vars=);
    %local rc dcid real_vars var i;
    /*  Проверка на пустоту параметров  */
    %if &ds ne and &vars ne %then %do;

        /*  Существует ли dataset?  */
        %if %sysfunc(exist(&ds)) %then %do;
        
            /*  Открываетм файл ds  */
            %let dsid = %sysfunc(open(&ds));
            
            /*  Существующие переменные vars в ds  */
            %let real_vars=%str( );

            /*  Итеративно пробегаем по всем параметрам vars  */
            %let i = 1;
            %let var = %scan(&vars, &i, %str( ));
            %do %while(&var ne);
            
                /*  Существует ли var в ds  */
                %if %sysfunc(varnum(&dsid, &var)) > 0 %then %do;
                    /*  Добавим его к real_vars  */
                    %let real_vars = %sysfunc(catx(%str( ), &real_vars, &var));
                %end;

                %let i = %eval(&i + 1);
                %let var=%scan(&vars, &i, %str( ));
            %end;
            
            /*  Закрываем ds  */
            %let rc = %sysfunc(close(&dsid));

            /* Вывод транспонирования  */
            %if &real_vars ne %then %do;
                   proc transpose data=&ds 
                               out=out_table
                               ; 
                    var &real_vars;
                run;
                proc print data=out_table; run;
            %end;
            %else %put "No such variables in &ds";
        %end;
        %else %put "file &ds not existing";
    %end;
    %else %put "empty parametrs";
run;

%mend transpose_dataset_vars;

%transpose_dataset_vars(ds=narrow_file1, vars=pet population );