/*------------------------------------------------------------------*
| MACRO NAME  : compare_all
| SHORT DESC  : Creates summary comparison report of two libraries 
|               of data in Excel.
*------------------------------------------------------------------*
| CREATED BY  : Meyers, Jeffrey                 (01/20/2013 3:00)
*------------------------------------------------------------------*
| VERSION UPDATES:
| 1.5 - 09/27/2021
|    Added parameter PRINT_VARIABLE_SUMMARY to allow the user to
        suppress the individual variable worksheets from printing
| 1.4 - 03/02/2020
|    Corrected issue with grabbing number of changed values in dataset
        summary table.
| 1.3 - 02/25/2020
|    Changed how IDSUMTABLE works.  Will now work on any number >=0.
        Will produce a summary of data changes including up to
        IDSUMTABLE number of ID variables.
|    Documentation updated.
| 1.2 - 02/24/2020
|    Fixed an issue where labels were being mismatched in variable
        summary sheets.
| 1.1 - 02/18/2020
|    Made updates for when a dataset does not share any non-ID variables
        between base and compare libraries
|    Added DEBUG option
| 1.0 - 03/15/2019
|    Initial Release
*------------------------------------------------------------------*
| PURPOSE
|
| This macro compares the datasets of two libraries together to check
| for changes in variables, datasets, and values in datasets the two
| libraries share.  The macro outputs a report of three levels into
| an Excel file.
| The first report lists all the datasets of both libraries side by side
| to compare the number of variables, observations, last updated date,
| and a count of potential new observations, lost observations, changed
| variable values, and variable attribute changes.
|
| The second level of the report is a worksheet for each datasets that is
| shared between the two libraries.  The report lists every variable contained
| by either library's dataset and compares some of the basic attributes
| (label, format, length, and type), and has a count of how many data changes
| exist from the base data to the new data.
|
| The third level of the report summarizes the changes across all variables
| potentially within levels of the ID variables.  The summary allows the user
| to quickly see what the values of the variable changed to.
|
| The fourth level of the report is for any variable that has changed values
| between the libraries.  Each changed value is listed with the base value
| and the compare value along with the ID variables.  For numeric values
| a percent and absolute change are provided. 
|
| 1.0: REQUIRED PARAMETERS
| BASE = The LIBNAME of the library containing the base data to compare with the updated data.
|        NOTE: This is the libname and not a file path.  A library must be
|              pre-specified.
| COMPARE = The LIBNAME of the library containing the updated data to compare with the base data.
|        NOTE: This is the libname and not a file path.  A library must be
|              pre-specified.
| OUTDOC = The full file path and file name of an Microsoft Excel file to output the report to.
|          Filename should include the .xlsx tag.
| 2.0: Optional PARAMETERS
| CROSSTAB_THRESHOLD = Determines how many unique combinations can exist when doing a
|                      comparison of changed values and still display them all in a 
|                      cross tab summary in the level 3 summary table.  Default is 15.
|                      minimum is 1.
| SELECT = A space delimited list of dataset names to focus the macro on comparing. The
|          case of the names does not matter, and no quotations should be included.  All
|          other datasets within the libraries will be ignored.
| ID = One or more variables can be designated ID variables that will be used to compare
|      between the same datasets (example: patient ID).  Due to different datasets having
|      different structures this parameter is flexible.  Any number of ID variables can be
|      specified, but only those that are contained in a specific dataset will be used in the
|      comparison for that dataset.  ID variables are listed in the order of the list from left
|      to right.
|      Example: ID = ARM DCNTR_ID CYCLE
|        Dataset BASELINE contains ARM and DCNTR_ID, so those are used as ID variables to compare BASELINE
|            in the order of ARM -> DCNTR_ID
|        Dataset TREATMENT contains ARM, DCNTR_ID, and CYCLE, so all three are used as ID variables to compare
|            TREATMENT in the order of ARM -> DCNTR_ID -> CYCLE
|        Dataset PROTOCOL contains none of the three ID variables, so none are used to compare PROTOCOL
| IDSUMTABLE = Determines how many ID variables are used to summarize the data changes for each dataset.
|              Example: if IDSUMTABLE=2 and a dataset has two ID variables then the data changes will be
|              summarized by both ID variables.  If IDSUMTABLE=2 and a dataset only has 1 ID variable then
|              it will use that one ID variable to summarize.  If IDSUMTABLE=2 and a dataset has 3 ID variables
|              then it will only use the first two ID variables in the ID list.
|              Example 2: If IDSUMTABLE=0 then it will not use any ID variables to summarize and will summarize
|              instead across all observations.
|              Default is 0.
| PRINT_VARIABLE_SUMMARY = Determines if the individual observation variable summaries are printed.  Turning this
|                          off can save memory and runtime.  Options is 1 (yes) and 0 (No).  Default is 1.
| OUTDOC = Specifies a file path and file name to save the Excel report to.
| DEBUG = Determines if NOTES are left on and if temporary datasets are deleted.  1 is (yes) and 0 is (no).
|         Default is 0.
*------------------------------------------------------------------*
| OPERATING SYSTEM COMPATIBILITY
| UNIX SAS v9.4   :   YES
| PC SAS v9.4     :   YES
*------------------------------------------------------------------*
| MACRO CALL
|
| %compare_all (
|            BASE=,
|            COMPARE=,
|            ID=,
|            SELECT=,
|            OUTDOC=
|          );
*------------------------------------------------------------------*
| REQUIRED PARAMETERS
|
| Name      : BASE
| Default   : 
| Type      : LIBNAME
| Purpose   : REFER TO REFERENCE SECTION
|
| Name      : COMPARE
| Default   :
| Type      : LIBNAME
| Purpose   : REFER TO REFERENCE SECTION
|
| Name      : OUTDOC
| Default   :
| Type      : File path and file name
| Purpose   : REFER TO REFERENCE SECTION
*------------------------------------------------------------------*
| EXAMPLES
|
| Example 1: Basic Example Call:
  libname basedata '/some/file/path';
  libname compdata '/another/file/path';
  %compare_all(base=basedata, compare=compdata, outdoc=/filepath/filename.xlsx);
|
| Example 2: Select Specific Datasets:
  libname basedata '/some/file/path';
  libname compdata '/another/file/path';
  %compare_all(base=basedata, compare=compdata, select=Data1 Data2 Data3, outdoc=/filepath/filename.xlsx);
|
| Example 3: Add ID Variables:
  libname basedata '/some/file/path';
  libname compdata '/another/file/path';
  %compare_all(base=basedata, compare=compdata, select=Data1 Data2 Data3, id=ARM PATID CYCLE EVAL_DT,
               outdoc=/filepath/filename.xlsx);
*------------------------------------------------------------------*
| This program is free software; you can redistribute it and/or
| modify it under the terms of the GNU General Public License as
| published by the Free Software Foundation; either version 2 of
| the License, or (at your option) any later version.
|
| This program is distributed in the hope that it will be useful,
| but WITHOUT ANY WARRANTY; without even the implied warranty of
| MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
| General Public License for more details.
*------------------------------------------------------------------*/

%macro compare_all(
    /*REQUIRED PARAMETERS*/
    base=,compare=,outdoc=,
    /*OPTIONAL PARAMETERS*/
    crosstab_threshold=15,select=,id=,idsumtable=0, print_variable_summary=1, debug=0);
    
    
    /**Save current options to reset after macro runs**/
    %local _mergenoby _notes _qlm _odspath _starttime _listing;
    %let _starttime=%sysfunc(time());
    %let _notes=%sysfunc(getoption(notes));
    %let _mergenoby=%sysfunc(getoption(mergenoby));
    %let _qlm=%sysfunc(getoption(quotelenmax)); 
    %let _odspath=&sysodspath;
    %if %sysevalf(%superq(_odspath)=,boolean) %then %let _odspath=WORK.TEMPLAT(UPDATE) SASHELP.TMPLMST (READ);
    /**Turn off warnings for merging without a by and long quote lengths**/
    /**Turn off notes**/
    options mergenoby=NOWARN nonotes noquotelenmax;
    %if &debug=1 %then %do; options notes; %end;
    ods path WORK.TEMPLAT(UPDATE) SASHELP.TMPLMST (READ);
    /**See if the listing output is turned on**/
    proc sql noprint;
        select 1 into :_listing separated by '' from sashelp.vdest where upcase(destination)='LISTING';
    quit;
    
    /**Process Error Handling**/
    %if &sysver < 9.4 %then %do;
        %put ERROR: SAS must be version 9.4 or later;
        %goto errhandl;
    %end;     
    %local i z nerror;
    %let nerror=0;
    

    /*Don't send anything to output window, results window, and set escape character*/
    ods select none;
    ods noresults escapechar='^';

    proc sql noprint;
        %local basepath comppath;
        select distinct path into :basepath separated by '' from sashelp.vlibnam where upcase(libname)=upcase("&base");
        select distinct path into :comppath separated by '' from sashelp.vlibnam where upcase(libname)=upcase("&compare");
    quit;
    
    %if %sysevalf(%superq(basepath)=,boolean) %then %do;
        /**Throw Error**/
        %put ERROR: (Global: BASE) Library does not exist;
        %let nerror=%eval(&nerror+1);
    %end; 
    %if %sysevalf(%superq(comppath)=,boolean) %then %do;
        /**Throw Error**/
        %put ERROR: (Global: COMPARE) Library does not exist;
        %let nerror=%eval(&nerror+1);
    %end; 

    /**Check for OUTDOC**/
    %if %sysevalf(%superq(outdoc)=,boolean) %then %do;
        /**Throw Error**/
        %put ERROR: (Global: OUTDOC) No output document specified;
        %let nerror=%eval(&nerror+1);
    %end;
    /*Global Parameters*/
    %macro _gparmcheck(parm, parmlist);          
        %local _test _z;
        /**Check if values are in approved list**/
        %do _z=1 %to %sysfunc(countw(&parmlist,|,m));
           %if %qupcase(%superq(&parm))=%qupcase(%scan(&parmlist,&_z,|,m)) %then %let _test=1;
        %end;
        %if &_test ^= 1 %then %do;
           /**If not then throw error**/
           %put ERROR: (Global: %qupcase(&parm)): %superq(&parm) is not a valid value;
           %put ERROR: (Global: %qupcase(&parm)): Possible values are &parmlist;
           %let nerror=%eval(&nerror+1);
        %end;
    %mend; 
    %_gparmcheck(print_variable_summary,0|1)
    /*Global Model Numeric Variables*/
    %macro _gnumcheck(parm, min,require);
        /**Check if missing**/
        %if %sysevalf(%superq(&parm)^=,boolean) %then %do;
            %if %sysfunc(notdigit(%sysfunc(compress(%superq(&parm),-.)))) > 0 %then %do;
                /**Check if character value**/
                %put ERROR: (Global: %qupcase(&parm)) Must be numeric.  %qupcase(%superq(&parm)) is not valid.;
                %let nerror=%eval(&nerror+1);
            %end;
            %else %if %sysevalf(&min^=,boolean) %then %do;
                %if %superq(&parm) < &min %then %do;
                    /**Makes sure number is not less than the minimum**/
                    %put ERROR: (Global: %qupcase(&parm)) Must be greater than or equal to %superq(min). %qupcase(%superq(&parm)) is not valid.;
                    %let nerror=%eval(&nerror+1);
                %end;
            %end;
        %end;
        %else %if &require=1 %then %do;
            /**Throw Error**/
            %put ERROR: (Global: %qupcase(&parm)) Cannot be missing;
            %put ERROR: (Global: %qupcase(&parm)) Possible values are numeric values greater than or equal to %superq(min);
            %let nerror=%eval(&nerror+1);           
        %end;       
    %mend;  
    %_gnumcheck(crosstab_threshold,1,1)
    %_gnumcheck(idsumtable,0,1)
    /*** If any errors exist, stop macro and send to end ***/
    %if &nerror > 0 %then %do;
        %put ERROR: &nerror pre-run errors listed;
        %put ERROR: Macro COMPARE_ALL will cease;
        %goto errhandl;
    %end;    
    %local i;
    proc contents data=&base.._all_
        out=_basedict %if %sysevalf(%superq(select)^=,boolean) %then %do;
           (where=(upcase(memname) in(%do i = 1 %to %sysfunc(countw(%superq(select),%str( )));
                                          "%qupcase(%sysfunc(dequote(%qscan(%superq(select),&i,%str( )))))"
                                      %end;) ))                                            
        %end;
        noprint order=collate;
    proc contents data=&compare.._all_
        out=_compdict %if %sysevalf(%superq(select)^=,boolean) %then %do;
           (where=(upcase(memname) in(%do i = 1 %to %sysfunc(countw(%superq(select),%str( )));
                                          "%qupcase(%sysfunc(dequote(%qscan(%superq(select),&i,%str( )))))"
                                      %end;) ))
        %end;
        noprint order=collate;
    run;

    proc transpose data=_basedict (drop=libname) out=_basedict_ct prefix=base;
        by memname name;
        var label format length;
    proc transpose data=_basedict (drop=libname) out=_basedict_nt (rename=(base1=base2)) prefix=base;
        by memname name;
        var type length formatl formatd;
    proc transpose data=_compdict (drop=libname) out=_compdict_ct prefix=comp;
        by memname name;
        var label format length;
    proc transpose data=_compdict (drop=libname) out=_compdict_nt (rename=(comp1=comp2)) prefix=comp;
        by memname name;
        var type length formatl formatd;
    run;
    
    data _basedict_t;
        set _basedict_ct _basedict_nt;
    data _compdict_t;
        set _compdict_ct _compdict_nt;
    proc sort data=_basedict_t;
        by memname name _name_;
    proc sort data=_compdict_t;
        by memname name _name_;
    run;

    data _attr_compare;
        merge _basedict_t (in=a) _compdict_t (in=b);
        by memname name _name_;
        if a and b and (base1^=comp1 or base2^=comp2) then mismatch=1;
        else mismatch=0;
        
        if mismatch=1 then output;
    run;
    
    proc sql noprint;
        create table _var_obs_compare as
            select a.*, max(0,b.natt_diff) as natt_diff 'Variable~Attributes',
            . as lost_observations 'Lost~Observations', . as new_observations 'New~Observations', . as data_changes 'Data~Changes',
            '' as id_variables length=300 'ID Variables Used','' as null from 
            (select coalescec(a.memname,b.memname) as memname 'Dataset Name',
            base_nvars 'Number of~Variables',base_nobs 'Number of~Observations', base_updated format=mmddyy10. 'Last Updated',
            comp_nvars 'Number of~Variables',comp_nobs 'Number of~Observations', comp_updated format=mmddyy10. 'Last Updated'
            from (select memname,count(name) as base_nvars,max(nobs) as base_nobs, max(datepart(modate)) as base_updated
                    from _basedict group by memname) a full outer join
                 (select memname,count(name) as comp_nvars,max(nobs) as comp_nobs, max(datepart(modate)) as comp_updated
                    from _compdict group by memname) b
            on a.memname=b.memname
            group by calculated memname) as a left join
               (select memname, count(distinct name) as natt_diff from _attr_compare group by memname) b
               on a.memname=b.memname;
        create table _var_attr_compare as
            select Upcase(coalescec(a.memname,b.memname)) as memname 'Dataset Name',
            upcase(coalescec(a.name,b.name)) as name 'Variable Name',
            ifc(a.type=1,'Numeric','Character') as base_type 'Type', a.length as base_length 'Length', a.format as base_fmt 'Format',a.label as base_label 'Label',
            ifc(b.type=1,'Numeric','Character') as comp_type 'Type', b.length as comp_length 'Length', b.format as comp_fmt 'Format',b.label as comp_label 'Label',
            ifc(^missing(a.name) and missing(b.name),'Yes','No') as lost_variable 'Lost~Variable',
            ifc(missing(a.name) and ^missing(b.name),'Yes','No') as new_variable 'New~Variable',
            . as data_changes 'No. Data~Changes',
            '' as id_variables length=3 'ID Variables?','' as null
            from _basedict a full outer join _compdict b
            on a.memname=b.memname and upcase(a.name)=upcase(b.name)
            order by coalesce(a.varnum,b.varnum);
            
        %local dlist ndata;
        select distinct memname into :dlist separated by '|' from
            (select distinct coalescec(a.memname,b.memname) as memname from 
            _basedict a inner join _compdict as b
            on a.memname=b.memname);
        %let ndata=1;
        %let ndata=%sysfunc(countw(&dlist,|));
        quit;

    ods select none;
    ods noresults;
    %do i = 1 %to &ndata;
        %local datid datidc;
        /**Open up dataset to check for variables**/
         /*base dataset*/
         %let datid&i = %sysfunc(open(&base..%scan(&dlist,&i,|)));
         %let any_id&i=0;
         %do j = 1 %to %sysfunc(countw(&id,%str( )));
             %local id&i.&j;
             %let id&i.&j=%sysfunc(varnum(&&datid&i,%scan(%superq(id),&j,%str( ))));
         %end;
         /**Close dataset**/
         %local closedatid;
         %let closedatid=%sysfunc(close(&&datid&i));
         /*Compare data*/
         %let datidc&i = %sysfunc(open(&compare..%scan(&dlist,&i,|)));
         %do j = 1 %to %sysfunc(countw(&id,%str( )));
             %local idc&i.&j;
             %let idc&i.&j=%sysfunc(varnum(&&datidc&i,%scan(%superq(id),&j,%str( ))));
         %end;
         /**Close dataset**/
         %let closedatid=%sysfunc(close(&&datidc&i));
         /*Check if ID is in both datasets*/
         %do j = 1 %to %sysfunc(countw(&id,%str( )));
             %if &&id&i.&j > 0 and &&idc&i.&j > 0 %then %let any_id&i=1; 
         %end;
         proc sql noprint;
             %local vlist&i llist&i nvar&i;
             select name,label into :vlist&i separated by '|',:llist&i separated by '|'
                 from _basedict where upcase(name) in(select upcase(name) from _compdict where upcase(memname)=upcase("%scan(&dlist,&i,|)"))
                 and upcase(memname)=upcase("%scan(&dlist,&i,|)")
                 %if &&any_id&i=1 %then %do;
                     and upcase(name) ^in(
                        %do j = 1 %to %sysfunc(countw(&id,%str( )));
                            %if &&id&i.&j > 0 and &&idc&i.&j > 0 %then %do; "%qupcase(%scan(&id,&j,%str( )))" %end; 
                        %end;)
                 %end;;
             %let nvar&i=%sysfunc(countw(&&vlist&i,|));
         quit;
     
         %local idlist&i;
         %if &&any_id&i=1 %then %do;
            %let idlist&i=;
            %do j = 1 %to %sysfunc(countw(&id,%str( )));
                %if %sysevalf(%superq(id&i.&j)>0,boolean) and %sysevalf(%superq(idc&i.&j)>0,boolean) and %sysevalf(%superq(idlist&i)^=,boolean) %then %let idlist&i=&&idlist&i %scan(&id,&j,%str( ));
                %else %if %sysevalf(%superq(id&i.&j)>0,boolean) and %sysevalf(%superq(idc&i.&j)>0,boolean) %then %let idlist&i=%scan(&id,&j,%str( ));
            %end;
            proc sort data=&base..%scan(&dlist,&i,|) out=_base&i;
               by &&idlist&i;
            proc sort data=&compare..%scan(&dlist,&i,|) out=_compare&i;
               by &&idlist&i;
            run;
         %end;
         %else %do;
             data _base&i;
                 set &base..%scan(&dlist,&i,|);
             run;
             data _compare&i;
                 set &compare..%scan(&dlist,&i,|);
             run;
         %end;
         %local any_diff&i same_type&i removed&i added&i;
         %let any_diff&i=0;
         %let same_type&i=0;
         %let removed&i=0;
         %let added&i=0;
         %do j = 1 %to &&nvar&i;
             %local any_diff&i._&j same_type&i._&j removed&i._&j added&i._&j;
             %let any_diff&i._&j=0;
             %let same_type&i._&j=0;
             %let removed&i._&j=0;
             %let added&i._&j=0;
         %end;
         %if &&nvar&i>0 %then %do;     
         data _comparison&i;
             merge _base&i (in=b keep=%if &&any_id&i=1 %then %do; &&idlist&i %end;
                                      %do j = 1 %to &&nvar&i; %scan(&&vlist&i,&j,|) %end;
                                 rename=(%do j = 1 %to &&nvar&i; %scan(&&vlist&i,&j,|)=_bvar&j %end;))
                   _compare&i (in=c keep=%if &&any_id&i=1 %then %do; &&idlist&i %end;
                                         %do j = 1 %to &&nvar&i; %scan(&&vlist&i,&j,|) %end;
                                    rename=(%do j = 1 %to &&nvar&i; %scan(&&vlist&i,&j,|)=_cvar&j %end;)) end=last;
             %if &&any_id&i=1 %then %do;
                 by &&idlist&i;
             %end;
             array any_diff {&&nvar&i};
             array _any_diff {&&nvar&i} _temporary_;
             array same_type {&&nvar&i};
             retain same_type removed added;
             if _n_=1 then do;
                 removed=0;added=0;
             end;
             observation=_n_;
             if b and ^c then do;
                 _removed=1;
                 removed+1;
             end;
             else _removed=0;
             if c and ^b then do;
                 added+1;
                 _added=1;
             end;
             else _added=0;
             %do j = 1 %to &&nvar&i;
                 if _n_=1 then do;
                     if (vtype(_bvar&j) = vtype(_cvar&j)) then same_type(&j)=ifn((vtype(_bvar&j)='N'),1,2);
                     else same_type(&j)=0;
                 end;
                 if same_type(&j) and (b and c) then do;
                     any_diff(&j)=(_bvar&j^=_cvar&j);
                     _any_diff(&j)+(_bvar&j^=_cvar&j);
                 end;
             %end;

             if last then do;
                 do i = 1 to dim(any_diff);
                     call symputx("any_diff&i._"||strip(put(i,12.0)),_any_diff(i),'l');
                     call symputx("same_type&i._"||strip(put(i,12.0)),same_type(i),'l');
                     end;
                 call symputx("any_diff&i",sum(of _any_diff(*)),'l');
                 call symputx("same_type&i",dim(same_type)-sum(of same_type(*)),'l');
                 call symputx("removed&i",removed,'l');
                 call symputx("added&i",added,'l');
             end;
             drop i;
             null='';
         run;
             data _comparison&i._t;
                 set _comparison&i;
             
                 array any_diff {&&nvar&i};
                 array same_type {&&nvar&i};
                 length nvar 8. variable $60. _base _compare $300.;
                 %do j = 1 %to &&nvar&i;
                     nvar=&j;
                     variable="%scan(&&vlist&i,&j,|)";
                     if any_diff(&j)=1 then do;
                         _base=vvalue(_bvar&j);
                         _compare=vvalue(_cvar&j);
                         %if &&same_type&i._&j=1 %then %do;
                             if same_type(&j)=1 and ^missing(_cvar&j) and ^missing(_bvar&j) then do;
                                 _diff=_cvar&j-_bvar&j;
                             end;
                             else call missing(_diff);
                         %end;
                         %else %do;
                             call missing(_diff);
                         %end;
                         output;
                     end;
                 %end;
                 keep &&idlist&i nvar variable _base _compare _diff;
             run;
         
             proc sql;
                 create table _id_lvl_sum_&i as
                     select
                     %if %sysevalf(%superq(idlist&i)^=,boolean) %then %do j = 1 %to %sysfunc(min(&idsumtable,%sysfunc(countw(%superq(idlist&i),%str( )))));
                         %scan(%superq(idlist&i),&j,%str( )),
                     %end;
                     sum(_added) as nadded,sum(_removed) as nremoved,
                     sum(nchanges) as nchanges
                     from (select *,sum(%do j=1 %to &&nvar&i;
                                            %if &j>1 %then %do; , %end; any_diff&j
                                        %end;) as nchanges from _comparison&i)
                     %if %sysfunc(min(&idsumtable,%sysfunc(countw(%superq(idlist&i),%str( )))))>0  %then %do; 
                         group by %do j = 1 %to %sysfunc(min(&idsumtable,%sysfunc(countw(%superq(idlist&i),%str( )))));
                                       %if &j>1 %then %do; , %end;
                                       %scan(%superq(idlist&i),&j,%str( ))
                                  %end;
                     %end;;
                 create table _comparison&i._t_sum as
                     select 
                     %if %sysevalf(%superq(idlist&i)^=,boolean) %then %do j = 1 %to %sysfunc(min(&idsumtable,%sysfunc(countw(%superq(idlist&i),%str( )))));
                         %scan(%superq(idlist&i),&j,%str( )),
                     %end;
                     nvar, variable, _base, _compare, count(*) as n, min(_diff) as min, max(_diff) as max
                     from _comparison&i._t
                     group by %if %sysevalf(%superq(idlist&i)^=,boolean) %then %do j = 1 %to %sysfunc(min(&idsumtable,%sysfunc(countw(%superq(idlist&i),%str( )))));
                                  %scan(%superq(idlist&i),&j,%str( )),
                              %end;
                              nvar, variable, _base, _compare;
                 create table _comparison&i._t_sum_final as
                     select * from _comparison&i._t_sum
                     group by %if %sysevalf(%superq(idlist&i)^=,boolean) %then %do j = 1 %to %sysfunc(min(&idsumtable,%sysfunc(countw(%superq(idlist&i),%str( )))));
                                  %scan(%superq(idlist&i),&j,%str( )),
                              %end;
                              nvar, variable having count(*) <= &crosstab_threshold
                     outer union corr
                     select 
                     %if %sysevalf(%superq(idlist&i)^=,boolean) %then %do j = 1 %to %sysfunc(min(&idsumtable,%sysfunc(countw(%superq(idlist&i),%str( )))));
                         %scan(%superq(idlist&i),&j,%str( )),
                     %end;
                     nvar, variable, ifc(^missing(_base),'Non-Missing','Missing') as _base,
                     ifc(^missing(_compare),'Non-Missing','Missing') as _compare, sum(n) as n, min(min) as min, max(max) as max
                     from (select * from _comparison&i._t_sum
                     group by %if %sysevalf(%superq(idlist&i)^=,boolean) %then %do j = 1 %to %sysfunc(min(&idsumtable,%sysfunc(countw(%superq(idlist&i),%str( )))));
                                    %scan(%superq(idlist&i),&j,%str( )),
                              %end;
                              nvar, variable having count(*) >&crosstab_threshold)
                              group by %if %sysevalf(%superq(idlist&i)^=,boolean) %then %do j = 1 %to %sysfunc(min(&idsumtable,%sysfunc(countw(%superq(idlist&i),%str( )))));
                                           %scan(%superq(idlist&i),&j,%str( )),
                                       %end;
                                       nvar, variable, calculated _base, calculated _compare
                     order by %if %sysevalf(%superq(idlist&i)^=,boolean) %then %do j = 1 %to %sysfunc(min(&idsumtable,%sysfunc(countw(%superq(idlist&i),%str( )))));
                                  %scan(%superq(idlist&i),&j,%str( )),
                              %end;
                              nvar, variable, _base, _compare;
             quit;
             data _id_lvl_sum_&i;
                 merge _id_lvl_sum_&i _comparison&i._t_sum_final;
                 %if %sysfunc(min(&idsumtable,%sysfunc(countw(%superq(idlist&i),%str( )))))>0 %then %do;
                    by %do  j = 1 %to %sysfunc(min(&idsumtable,%sysfunc(countw(%superq(idlist&i),%str( )))));
                          %scan(%superq(idlist&i),&j,%str( ))
                       %end;;
                 %end;
                 %else %do;
                     retain _nadded _nremoved _nchanges;
                     if _n_=1 then do;
                         _nadded=nadded;_nremoved=nremoved;_nchanges=nchanges;
                     end;
                     else do;
                         nadded=_nadded;nremoved=_nremoved;nchanges=_nchanges;
                     end;
                     drop _nadded _nremoved _nchanges;   
                 %end;
             run;
         %end;
   %end;

   proc sql;
       %do i = 1 %to &ndata;
           %if %sysevalf(%superq(removed&i)=,boolean) %then %let removed&i=.;
           %if %sysevalf(%superq(added&i)=,boolean) %then %let added&i=.;
           %if %sysevalf(%superq(any_diff&i)=,boolean) %then %let any_diff&i=.;
           %do j = 1 %to &&nvar&i;
               %if %sysevalf(%superq(any_diff&i._&j)=,boolean) %then %let any_diff&i._&j=0;
           %end;
       %end;
       update _var_obs_compare
           set lost_observations=case(memname)
             %do i = 1 %to &ndata;
                 when "%scan(&dlist,&i,|)" then &&removed&i
             %end;
             else . end,
             new_observations=case(memname)
             %do i = 1 %to &ndata;
                 when "%scan(&dlist,&i,|)" then &&added&i
             %end;
             else . end,  
             data_changes=case(memname)
             %do i = 1 %to &ndata;
                 when "%scan(&dlist,&i,|)" then &&any_diff&i
             %end;
             else . end,  
             id_variables=case(memname)
             %do i = 1 %to &ndata;
                 when "%scan(&dlist,&i,|)" then tranwrd("&&idlist&i",' ',', ')
             %end;
             else '' end;
       update _var_attr_compare
           set data_changes=case(memname)
                   %do i = 1 %to &ndata;
                       when "%scan(&dlist,&i,|)" then case (upcase(name))
                           %if &&nvar&i>0 %then %do j = 1 %to &&nvar&i;
                               %if %sysevalf(%superq(any_diff&i._&j)^=,boolean) %then %do;
                                    when upcase("%scan(&&vlist&i,&j,|)") then %superq(any_diff&i._&j)
                               %end;
                           %end;
                           %else %do;
                              when "" then .
                           %end;
                           else . end
                   %end;
                   else . end,
               id_variables=case 
                       when upcase(name) in("" %do j = 1 %to %sysfunc(countw(&id,%str( ))); "%qupcase(%scan(&id,&j,%str( )))" %end;) then 'Yes'
                       else 'No' end;           
   quit;
   
   %put COMPARE_ALL: Comparisons completed, runtime: %sysfunc(putn(%sysevalf(%sysfunc(TIME())-&_starttime.),mmss.));
     
   %if %sysevalf(%superq(outdoc)^=,boolean) %then
       %put COMPARE_ALL: Printing to &outdoc;
   %else %put COMPARE_ALL: Printing to &base._&compare._comparison.xlsx;
   
   %local nbsp;
   data _null_;
       call symput('nbsp','A0'x);
   run;
   ods select all;
   ods listing close;
   ods escapechar='^';
   ods excel
       %if %sysevalf(%superq(outdoc)^=,boolean) %then %do;
           file="&outdoc"
       %end;
       %else %do;
           file="&base._&compare._comparison.xlsx"
       %end;;
   %local topref;
   %let topref=%str(=HYPERLINK("#'Top Summary'!A4","Return to Top Summary"));
   ods excel options(sheet_name="Top Summary" frozen_Headers='5' frozen_rowheaders='1' flow='tables'
        absolute_column_width='36,13,10,12,13,10,12,9,12,12,9,25');
   %put COMPARE_ALL: Printing top summary, runtime: %sysfunc(putn(%sysevalf(%sysfunc(TIME())-&_starttime.),mmss.));
   proc report data=_var_obs_compare nowd split='~' missing 
       style(header)={just=l fontweight=bold bordertopwidth=3pt bordertopcolor=black fontfamily='Arial'
          borderleftwidth=3pt borderleftcolor=black borderrightwidth=3pt borderrightcolor=black borderbottomwidth=3pt borderbottomcolor=black
          fontsize=10pt background=white color=black}
       style(column)={bordercolor=black fontsize=10pt just=c fontfamily='Arial'}
       style(lines)={color=black fontweight=bold fontsize=10pt bordertopwidth=3pt bordertopcolor=black
          borderleftwidth=3pt borderleftcolor=black borderrightwidth=3pt borderrightcolor=black borderbottomwidth=3pt borderbottomcolor=black}
       style(report)={bordertopwidth=3pt bordertopcolor=black
          borderleftwidth=3pt borderleftcolor=black borderrightwidth=3pt borderrightcolor=black borderbottomwidth=3pt borderbottomcolor=black};
       
       columns ("Base Library (%qupcase(&base)): &basepath"
                 ("Compare Library (%qupcase(&compare)): &comppath"
                   (%if %sysevalf(%superq(select)^=,boolean) %then %do;
                        "Summary of Selected Datasets Compared (Option SELECT is in Effect: Other Datasets Could Exist in Library)"
                    %end;
                    %else %do;
                        "Summary of Datasets Compared"
                    %end;
             memname
             null=n6, (memname=mem2 memname=mem3)
             null=n2, (base_updated base_nvars base_nobs)
             null=n3, (comp_updated comp_nvars comp_nobs)
             null=n4, (natt_diff lost_observations new_observations data_changes)
             null=n5, (id_variables id_variables=n1))))
             _null_;
       define n1 / display noprint;
       define n2 / across "Base" style={background=lightblue};
       define n3 / across "Compare" style={background=lightgray};
       define n4 / across "Any Differences" style={background=lightred};
       define n6 / across "A0"x style={borderbottomstyle=none borderbottomcolor=white};
       define n5 / across "A0"x style={borderbottomstyle=none borderbottomcolor=white background=lightgreen};
       define memname / display noprint;
       define mem3 / display noprint;
       define mem2 / display 
           style(column)={borderleftwidth=3pt borderleftcolor=black borderrightwidth=3pt borderrightcolor=black just=l}
           style={width=100% just=l} 
           style(header)={just=c bordertopstyle=none bordertopcolor=white};
       define base_updated / display style={borderleftwidth=3pt borderleftcolor=black width=100%} center style(header)={background=lightblue};
       define base_nvars / display style(header)={background=lightblue};
       define base_nobs / display style(header)={background=lightblue};
       define comp_nvars / display style(header)={background=lightgray};
       define comp_nobs / display style(header)={background=lightgray};
       define comp_updated / display style={borderleftwidth=3pt borderleftcolor=black width=100%} center style(header)={background=lightgray};
       
       define natt_diff / display style={borderleftwidth=3pt borderleftcolor=black width=100%} center style(header)={background=lightred};
       define lost_observations / display style(header)={background=lightred};
       define new_observations / display style(header)={background=lightred};
       define data_changes / display style(header)={background=lightred};
       define id_variables / display style={borderleftwidth=3pt borderleftcolor=black width=100% bordertopstyle=none bordertopcolor=white} left
           style(header)={background=lightgreen} style(column)={just=l};
       define _null_ / computed noprint;
       
       compute _null_;
            if _c5_^=_c8_ then do;
                call define('_c5_','style/merge','style={background=lightorange}');
                call define('_c8_','style/merge','style={background=lightorange}');
            end;
            if _c6_^=_c9_ then do;
                call define('_c6_','style/merge','style={background=lightorange}');
                call define('_c9_','style/merge','style={background=lightorange}');
            end;
            if _c10_>0 then call define('_c10_','style/merge','style={background=lightorange}');
            if _c11_>0 then call define('_c11_','style/merge','style={background=lightorange}');
            if _c12_>0 then call define('_c12_','style/merge','style={background=lightorange}');
            if _c13_>0 then call define('_c13_','style/merge','style={background=lightorange}');
            urlstring="#'"||substr('Summary-'||strip(memname),1,28)||"'!A4";
            if ^missing(_c4_) and ^missing(_c7_) then call define('_c2_','url',urlstring);
       endcomp;
   run;

   %do i = 1 %to &ndata;
       %put COMPARE_ALL: Printing dataset (%scan(&dlist,&i,|)) summary, runtime: %sysfunc(putn(%sysevalf(%sysfunc(TIME())-&_starttime.),mmss.));
       ods excel options(sheet_name="Summary-%scan(&dlist,&i,|)" frozen_Headers='5' frozen_rowheaders='1' 
           absolute_column_width='29,13,12,55,17,10,12,55,17,10,9,12,12');
       %local datref&i;
       %if %length(Summary-%scan(&dlist,&i,|))>28 %then 
           %let datref&i==HYPERLINK("#'%substr(Summary-%scan(&dlist,&i,|),1,28)'!A4","Dataset Name: %scan(&dlist,&i,|)");
       %else %let datref&i==HYPERLINK("#'Summary-%scan(&dlist,&i,|)'!A4","Dataset Name: %scan(&dlist,&i,|)");
       proc report data=_var_attr_compare nowd split='~' missing 
           style(header)={just=l fontweight=bold bordertopwidth=3pt bordertopcolor=black fontfamily='Arial'
               borderleftwidth=3pt borderleftcolor=black borderrightwidth=3pt borderrightcolor=black borderbottomwidth=3pt borderbottomcolor=black
               fontsize=10pt background=white color=black}
           style(column)={bordercolor=black fontsize=10pt just=c fontfamily='Arial' width=100%}
           style(lines)={color=black fontweight=bold fontsize=10pt bordertopwidth=3pt bordertopcolor=black
               borderleftwidth=3pt borderleftcolor=black borderrightwidth=3pt borderrightcolor=black borderbottomwidth=3pt borderbottomcolor=black}
           style(report)={bordertopwidth=3pt bordertopcolor=black
                borderleftwidth=3pt borderleftcolor=black borderrightwidth=3pt borderrightcolor=black borderbottomwidth=3pt borderbottomcolor=black};
       
           columns 
                 ("Dataset Name: %scan(&dlist,&i,|)"
                   ("ID Variables: &&idlist&i"
                       ("%superq(topref)"
               name=nm
               null=n1, (name id_variables)
               null=n2, (base_type base_label base_fmt base_length)
               null=n3, (comp_type comp_label comp_fmt comp_length)
               null=n4, (lost_variable new_variable data_changes)
               )));

           define n1 / across "A0"x;
           define n2 / across "Base" style={background=lightblue};
           define n3 / across "Compare" style={background=lightgray};
           define n4 / across "Any Differences" style={background=lightred};

           define nm / display noprint;
           define name / display style(header)={just=c bordertopstyle=none bordertopcolor=white} style={width=100%}
               style(column)={borderleftwidth=3pt borderleftcolor=black borderrightwidth=3pt borderrightcolor=black just=l}
                left;
           define base_type / display style={borderleftwidth=3pt borderleftcolor=black width=100%} center style(header)={background=lightblue};
           define base_label / display left style={just=l} style(header)={background=lightblue};
           define base_length / display left style={just=l} style(header)={background=lightblue};
           define comp_length / display left style={just=l} style(header)={background=lightgray};
           define comp_label / display left style={just=l} style(header)={background=lightgray};
           define base_fmt / display left style={just=l} style(header)={background=lightblue};
           define comp_fmt / display left style={just=l} style(header)={background=lightgray};
           define lost_variable / display style(header)={background=lightred};
           define new_variable / display style(header)={background=lightred};
           define data_changes / display style(header)={background=lightred};
           define comp_type / display style={borderleftwidth=3pt borderleftcolor=black width=100%} center style(header)={background=lightgray};
           define lost_variable / display style={borderleftwidth=3pt borderleftcolor=black width=100%} center style(header)={background=lightred};
           
           define id_variables / display style={borderleftwidth=3pt borderleftcolor=black width=100%} style(header)={background=lightgreen} center;

           compute data_changes;
               if _c13_='Yes' then do;
                   call define('_c2_','style/merge','style={background=lightorange}');
                   call define('_c13_','style/merge','style={background=lightorange}');
               end;
               if _c12_='Yes' then do;
                   call define('_c2_','style/merge','style={background=lightred}');
                   call define('_c12_','style/merge','style={background=lightred}');
               end;
               if _c14_>0 then do;
                   call define('_c2_','style/merge','style={background=lightred}');
                   call define('_c14_','style/merge','style={background=lightred}');
               end;
               if _c3_='Yes' then do;
                   call define('_c2_','style/merge','style={background=lightgreen}');
                   call define('_c3_','style/merge','style={background=lightgreen}');
               end;
               if _c4_^=_c8_ and _c13_='No' then do;
                   call define('_c4_','style/merge','style={background=lightorange}');
                   call define('_c8_','style/merge','style={background=lightorange}');
               end;
               if _c5_^=_c9_ and _c13_='No' then do;
                   call define('_c5_','style/merge','style={background=lightorange}');
                   call define('_c9_','style/merge','style={background=lightorange}');
               end;
               if _c6_^=_c10_ and _c13_='No' then do;
                   call define('_c6_','style/merge','style={background=lightorange}');
                   call define('_c10_','style/merge','style={background=lightorange}');
               end;
               if _c7_^=_c11_ and _c13_='No' then do;
                   call define('_c7_','style/merge','style={background=lightorange}');
                   call define('_c11_','style/merge','style={background=lightorange}');
               end;
               length tempname $32.;
               if _c14_>0 and &print_variable_summary=1 then do;
                   if substr("%scan(&dlist,&i,|)-"||strip(_c2_),1,28)=substr("%scan(&dlist,&i,|)-"||strip(tempname),1,28) then do;
                       if tempnamen=. then tempnamen=2;
                       else tempnamen+1;
                       urlstring="#'"||substr("%scan(&dlist,&i,|)-"||strip(_c2_),1,28)||' '||strip(put(tempnamen,12.0))||"'!A4";
                   end;
                   else do;
                       urlstring="#'"||substr("%scan(&dlist,&i,|)-"||strip(_c2_),1,28)||"'!A4";
                       tempnamen=.;
                   end;
                   call define('_c2_','url',urlstring);
               end;
               tempname=_c2_;
           endcomp;
           where memname="%scan(&dlist,&i,|)"/* and (id_variables='Yes' or lost_variable='Yes' or new_variable ='Yes' or data_changes>0)*/;
       run;
       
       %put COMPARE_ALL: Printing dataset (%scan(&dlist,&i,|)) data changes summary, runtime: %sysfunc(putn(%sysevalf(%sysfunc(TIME())-&_starttime.),mmss.));
       ods excel options(sheet_name="ID Summary-%scan(&dlist,&i,|)" frozen_Headers='5' frozen_rowheaders="%sysfunc(min(&idsumtable,%sysfunc(countw(%superq(idlist&i),%str( )))))"
           %if %sysfunc(min(&idsumtable,%sysfunc(countw(%superq(idlist&i),%str( )))))>0  %then %do;
               absolute_column_width="%sysfunc(repeat(%str(31,),%sysfunc(min(&idsumtable,%sysfunc(countw(%superq(idlist&i),%str( )))))-1))13,12,13,19,31,31,13,13,13"
           %end;
           %else %do;
               absolute_column_width='13,12,13,19,31,31,13,13,13'
           %end;);
       proc report data=_id_lvl_sum_&i nowd split='~' missing spanrows
           style(header)={just=l fontweight=bold bordertopwidth=3pt bordertopcolor=black fontfamily='Arial'
               borderleftwidth=3pt borderleftcolor=black borderrightwidth=3pt borderrightcolor=black borderbottomwidth=3pt borderbottomcolor=black
               fontsize=10pt background=white color=black}
           style(column)={bordercolor=black fontsize=10pt just=c fontfamily='Arial' width=100% vjust=top}
           style(lines)={color=black fontweight=bold fontsize=10pt bordertopwidth=3pt bordertopcolor=black
               borderleftwidth=3pt borderleftcolor=black borderrightwidth=3pt borderrightcolor=black borderbottomwidth=3pt borderbottomcolor=black}
           style(report)={bordertopwidth=3pt bordertopcolor=black
                borderleftwidth=3pt borderleftcolor=black borderrightwidth=3pt borderrightcolor=black borderbottomwidth=3pt borderbottomcolor=black};
           
           columns 
                 ("Summary of %scan(&dlist,&i,|) Summary of Data Changes"
                   ("All Available ID Variables: &&idlist&i"
                     %if %sysfunc(min(&idsumtable,%sysfunc(countw(%superq(idlist&i),%str( )))))=0 %then %do;
                         ("Note: No ID variables used in summary"
                     %end;
                     %else %if %sysfunc(min(&idsumtable,%sysfunc(countw(%superq(idlist&i),%str( )))))=%sysfunc(countw(%superq(idlist&i),%str( ))) %then %do;  
                         ("Note: All ID variable(s) are used in summary"
                     %end;
                     %else %do;
                         ("Note: Only first %sysfunc(min(&idsumtable,%sysfunc(countw(%superq(idlist&i),%str( ))))) ID variable(s) is used in summary"
                     %end;
                       ("%superq(topref)"
               %if %sysevalf(%superq(idlist&i)^=,boolean) %then %do j = 1 %to %sysfunc(min(&idsumtable,%sysfunc(countw(%superq(idlist&i),%str( )))));
                   %scan(%superq(idlist&i),&j,%str( ))
               %end;
               nremoved nadded nchanges nvar variable _base _compare n min max))));

           %if %sysevalf(%superq(idlist&i)^=,boolean) %then %do j = 1 %to %sysfunc(min(&idsumtable,%sysfunc(countw(%superq(idlist&i),%str( )))));
               define %scan(%superq(idlist&i),&j,%str( )) / order style(header)={background=lightgreen};
           %end;
           define nadded / order 'New~Observations' center style(header)={background=lightred};
           define nremoved / order 'Lost~Observations' center style(header)={background=lightred};
           define nchanges / order 'N~Data Changes' center style(header)={background=lightred};
           define nvar / order noprint;
           define variable / order 'Variable' left style(header)={background=lightred};
           define _base / display 'Base' left style(header)={background=lightblue};
           define _compare / display 'Compare' left style(header)={background=lightgray};
           define n / display 'N' center style(header)={background=lightred};
           define min / display 'Mininum' center style(header)={background=lightred};
           define max / display 'Maximum' center style(header)={background=lightred};

           compute max;
              %if %sysfunc(min(&idsumtable,%sysfunc(countw(%superq(idlist&i),%str( )))))>0 %then %do;
                  if ^missing(%scan(%superq(idlist&i),1,%str( ))) then call define(_row_,'style/merge','style={bordertopwidth=3pt bordertopstyle=solid bordertopcolor=black}');
              %end;
              if ^missing(variable) or nchanges=0 then shade+1;
              if mod(shade,2) then do;
                  call define('variable','style/merge','style={background=greyef}');
                  call define('n','style/merge','style={background=greyef}');
                  call define('_base','style/merge','style={background=greyef}');
                  call define('_compare','style/merge','style={background=greyef}');
                  call define('min','style/merge','style={background=greyef}');
                  call define('max','style/merge','style={background=greyef}');
              end;
           endcomp;
           where max(nremoved,nadded,nchanges,n)>0;           
       run;
       
       %if &&any_diff&i>0 and &print_variable_summary=1 %then %do j = 1 %to &&nvar&i;
           %if %superq(any_diff&i._&j) > 0 %then %do;
           %put COMPARE_ALL: Printing dataset (%scan(&dlist,&i,|)) variable (%scan(&&vlist&i,&j,|)) specific changes, runtime: %sysfunc(putn(%sysevalf(%sysfunc(TIME())-&_starttime.),mmss.));
               ods excel options(sheet_name="%scan(&dlist,&i,|)-%scan(&&vlist&i,&j,|)" frozen_Headers='5' frozen_rowheaders='1'
                   %if &&any_id&i=1 %then %do;
                       absolute_column_width="%sysfunc(repeat(%str(31,),%sysfunc(countw(%superq(idlist&i),%str( )))-1))15,31,31,15,15"
                   %end;
                   %else %do;
                       absolute_column_width="15,31,31,15,15"
                   %end;);
       proc report data=_comparison&i nowd split='~' missing
           style(header)={just=l fontweight=bold bordertopwidth=3pt bordertopcolor=black fontfamily='Arial'
               borderleftwidth=3pt borderleftcolor=black borderrightwidth=3pt borderrightcolor=black borderbottomwidth=3pt borderbottomcolor=black
               fontsize=10pt background=white color=black}
           style(column)={bordercolor=black fontsize=10pt just=c fontfamily='Arial' width=100%}
           style(lines)={color=black fontweight=bold fontsize=10pt bordertopwidth=3pt bordertopcolor=black
               borderleftwidth=3pt borderleftcolor=black borderrightwidth=3pt borderrightcolor=black borderbottomwidth=3pt borderbottomcolor=black}
           style(report)={bordertopwidth=3pt bordertopcolor=black
                borderleftwidth=3pt borderleftcolor=black borderrightwidth=3pt borderrightcolor=black borderbottomwidth=3pt borderbottomcolor=black};
       
           columns 
                 ("%superq(datref&i)"
                   ("Variable Name (label): %scan(&&vlist&i,&j,|,m) (%scan(%superq(llist&i),&j,|,m))"
                       ("%superq(topref)"
                  observation=obs
                  %if %sysfunc(countw(&&idlist&i,%str( ))) > 0 %then %do;
                      null=n1, (&&idlist&i)
                  %end;
                observation
               _bvar&j _cvar&j
               abs_change pct_change)));
           %do k = 1 %to %sysfunc(countw(&&idlist&i,%str( )));
               define %scan(&&idlist&i,&k,%str( )) / display 
                   style(column)={%if &k=i %then %do; borderleftwidth=3pt borderleftcolor=black %end; just=l}
                   style={width=100%} style(header)={just=c bordertopstyle=none bordertopcolor=white background=lightgreen} left; 
           %end;

           define obs / display noprint;
           %if %sysfunc(countw(&&idlist&i,%str( ))) > 0 %then %do;
               define n1 / across "ID Variables" style(header)={background=lightgreen};
           %end;
           define observation / display 'Observation' style={borderleftwidth=3pt borderleftcolor=black width=100%} center;
           define _bvar&j / display style={borderleftwidth=3pt borderleftcolor=black width=100%} center 'Base' style(header)={background=lightblue};
           define _cvar&j / display 'Compare' style(header)={background=lightgrey};
           define abs_change / computed 'Absolute~Change' style={borderleftwidth=3pt borderleftcolor=black width=100%} center style(header)={background=lightred};
           define pct_change / computed 'Percent~Change' format=12.1 style(header)={background=lightred};

           compute pct_Change;
               if vtype(_bvar&j)='N' and vtype(_cvar&j)='N' and ^missing(_bvar&j) and ^missing(_cvar&j) then do;
                   abs_change=_cvar&j-_bvar&j;
                   if _bvar&j>0 then pct_change=100*abs_change/_bvar&j;
               end;
           endcomp;
           where any_diff&j=1;
       run;

           %end;
       %end;
    %end;
    options notes;
    ods excel close;
  
    %errhandl:
    %if &_listing=1 %then %do;
        ods Listing;
    %end;
    %else %do;
        ods listing close;
    %end;
    ods select all;
    ods results;
    options nonotes;
    /**Delete temporary datasets**/
    proc datasets nolist nodetails;
        %if &debug=0 and &nerror=0 %then %do;
        delete %do i = 1 %to &ndata; _base&i _compare&i _comparison&i  _comparison&i._t _id_lvl_sum_&i _comparison&i._t_sum _comparison&i._t_sum_final %end;
            _var_attr_compare _var_obs_compare _compdict _compdict_ct _compdict_nt _compdict_t
            _basedict _basedict_ct _basedict_nt _basedict_t  _attr_compare  
            ;
        %end;
    quit; 
    /**Reload previous Options**/ 
    ods path &_odspath;
    options mergenoby=&_mergenoby &_notes &_qlm;
    %put COMPARE_ALL has finished processing, runtime: %sysfunc(putn(%sysevalf(%sysfunc(TIME())-&_starttime.),mmss.));    
%mend;


