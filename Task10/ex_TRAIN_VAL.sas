/* Sort the data by the target   */
/* in preparation for stratified */
/* sampling.                     */
proc sort data=develop; 
   by ins; 
run;

/* The SURVEYSELECT procedure will  */
/* perform stratified sampling on   */
/* any variable in the STRATA       */
/* statement.  The OUTALL option    */
/* specifies that you want a flag   */
/* appended to the file to indicate */
/* selected records, not simply a   */
/* file comprised of the selected   */
/* records.                         */
proc surveyselect noprint ranuni
                  data = develop 
                  samprate=.6667 /*train ~66%, test ~33%*/
                  out=develop
                  seed=44444
                  outall;
   strata ins;
run;


