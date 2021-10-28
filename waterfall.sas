/*------------------------------------------------------------------*
| MACRO NAME  : waterfall
| SHORT DESC  : Creates one or more waterfall plots 
*------------------------------------------------------------------*
| CREATED BY  : Meyers, Jeffrey                 (05/31/2019 3:00)
*------------------------------------------------------------------*
| VERSION UPDATES:
| 1.1: 07/24/2019
|    Added numerous options with patterns
      
| 1.0: Initial Release - 05/31/2019
*------------------------------------------------------------------*
| PURPOSE
|
| This macro runs creates a waterfall plot based on a numeric outcome
| variable.  Bars can be colored by a GROUP variable and multiple plots
| can be generated with a BY variable.  The waterfall can be sorted in
| ascending or descending order, can have reference lines added, and 
| can have an intercept other than 0 to draw the waterfall around.
|
| 1.0: Required Parameters
|     DATA = Input dataset containing the variables for VAR, BY and GROUP
|     VAR = Numeric variable for analysis.  Missing values will be ignored
|           within the dataset.
| 2.0: Optional Parameters
|     2.1: VAR Options
|         INTERCEPT = Numeric value to draw the base of the waterfall from.  
|                     Bars will be drawn from this value to the value of the
|                     VAR variable.  Default is 0.
|         VAR_ORDER = Determines if waterfall will be drawn in ascending or 
|                     descending order.  Options are DESCENDING or 
|                     ASCENDING.  Default is DESCENDING.
|         ID_ORDER = Determines if the waterfall bars will be sorted within groups.
|                    ID_ORDER=GROUP will sort VAR into sections by GROUP.
|                    ID_ORDER=ID will sort VAR across all values and still color by GROUP
|     2.2: GROUP Options
|         GROUP = Designates a variable for grouping the waterfall bars into 
|                 different colors.  Can be numeric or character.
|         GROUP_ORDER = GROUP variable is sorted by unformatted values by default.
|                       GROUP_ORDER can rearrange these by listing the preferred order.
|                       Example: Values of Male and Female.  Default order would be 
|                                Female (1), and Male (2).  Setting GROUP_ORDER=2 1
|                                would rearrange these to be Male (2) then Female (1).
|         PATTERNVAR = Designates a variable for highlighting bars with different patterns.
|                      Has no effect on coloring or grouping the bars.
|         PATTERNVAR_ORDER = PATTERNVAR variable is sorted by unformatted values by default.
|                            PATTERNVAR_ORDER can rearrange these by listing the preferred order.
|                            Example: Values of Male and Female.  Default order would be 
|                                     Female (1), and Male (2).  Setting PATTERNVAR_ORDER=2 1
|                                     would rearrange these to be Male (2) then Female (1).
|     2.3: BY Options
|         BY = Designates a variable for creating multiple plots within each level of BY.
|              Can be numeric or character.
|         BY_ORDER = BY variable is sorted by unformatted values by default.
|                    BY_ORDER can rearrange these by listing the preferred order.
|                    Example: Values of Male and Female.  Default order would be 
|                             Female (1), and Male (2).  Setting GROUP_ORDER=2 1
|                             would rearrange these to be Male (2) then Female (1).
|         ROWS = Determines how many rows to arrange the plots into.  Leaving this blank
|                results in having one row per level of the BY variable.
|         COLUMNS = Determines how many columns to arrange the plots into.  Leaving this blank
|                   results in having one row per level of the BY variable.
|     2.4: DATA Subset Options
|         WHERE = Subsets the inputted DATASET within the macro.  Use same syntax as the 
|                 where statement of a procedure.
|     2.5: Plot Options
|         2.5.1: Bar Color/Fill Options
|             COLORS = Assigns colors to the bars.  The order of colors will match
|                      the order of the groups.  SAS default colors will be used if not provided.
|                      Example: COLORS=Blue Red Green
|             PATTERNS = Assigns patterns to the bars.  The patterns are assigned differently 
|                        depending on whether PATTERNVAR is used.  PATTERNVAR assigns a variable
|                        to associate the patterns with.  If PATTERNVAR is not used then the patterns
|                        will be assigned according to the GROUP variable.  Options are:
|                        E - Empty pattern.  No extra lines are drawn
|                        S - Solid pattern.  No extra lines are drawn, but is more opaque than E
|                        L1/L2/L3/L4/L5 - Uses a \ as the pattern.  L1-L5 have different thicknesses and styles
|                        R1/R2/R3/R4/R5 - Uses a / as the pattern.  R1-R5 have different thicknesses and styles
|                        X1/X2/X3/X4/X5 - Uses a X as the pattern.  X1-X5 have different thicknesses and styles
|         2.5.2: Axis Options
|             AXISCOLOR = Determines the color of the axis, tick marks, and borders of the graph.
|                         Default is black.
|             YAXIS_TICKVALUES = Determines the tick values of the graph.  Can be listed in one of 
|                                three formats:
|                                   1) XX to XX by XX (by is optional)
|                                   2) Space delimited list (XX XX XX XX XX)
|                                   3) Comma delimited list (XX,XX,XX,XX,XX)
|                                       NOTE: when using comma delimited list must wrap within %str() function
|             YAXIS_TICKVALUE_SIZE = Determines the size of the y-axis tick values.  Default is 10pt.
|             YAXIS_TICKVALUE_WEIGHT = Determines the weight of the y-axis tick values.  Options are NORMAL and BOLD.
|                                      Default is NORMAL.
|             YAXIS_MIN = Determines the minimum for the y-axis.  Automatically chosen by program if none provided.
|             YAXIS_MAX = Determines the maximum for the y-axis.  Automatically chosen by program if none provided.
|             YAXIS_LABEL = Specifies the label for the y-axis.  Uses the VAR variable's label if none provided.
|             YAXIS_LABEL_SIZE = Determines the size of the y-axis label.  Default is 10pt.
|             YAXIS_LABEL_WEIGHT = Determines the weight of the y-axis label.  Options are BOLD and NORMAL.  Default is BOLD.
|         2.5.3: Legend Options
|             LEGEND_DISPLAY = Determines if the legend is displayed when a GROUP variable is specified.  
|                              Options are 1 (yes) and 0 (no). Default is 1.
|             LEGEND_ACROSS = Determines how many values can be displayed horizontally in the legend.
|             LEGEND_DOWN = Determines how many values can be displayed vertically in the legend
|             LEGEND_TITLE = Specifies a title for the legend.  Uses the GROUP variable's label if none provided.
|             LEGEND_TITLE_SIZE = Determines the size of the legend title.  Default is 10pt.
|             LEGEND_TITLE_WEIGHT = Determines the weight of the legend title.  Options are BOLD and NORMAL.  Default is BOLD.
|             LEGEND_VALUES_SIZE = Determines the size of the legend values.  Default is 10pt.
|             LEGEND_VALUES_WEIGHT = Determines the weight of the legend values.  Options are BOLD and NORMAL.  Default is NORMAL.
|         2.5.4: Cell Header Options
|             HEADER_ALIGN = Determines the alignment of the headers made from the BY variable for each plot.  Options are 
|                            LEFT, CENTER and RIGHT.  Default is CENTER.
|             HEADER_SIZE = Determines the size of the header.  Default is 12pt.
|             HEADER_WEIGHT = Determines the weight of the header.  Options are BOLD and NORMAL.  Default is BOLD.
|         2.5.5: Reference Line Options
|             REFLINES = Specifies points on the y-axis to draw reference lines.  List multiple points in a space delimited list.
|             REFLINE_COLOR = Determines the color of the reference lines.  Default is grey.
|             REFLINE_PATTERN = Determines the pattern of the reference lines.  Default is 2.  Options are to do numbers between
|                               1 and 46, or: SOLID, SHORTDASH, MEDIUMDASH, LONGDASH,
|                               MEDIUMDASHSHORTDASH, DASHDASHDOT, DASHDOTDOT, DASH, LONGDASHSHORTDASH,
|                               DOT, THINDOT, SHORTDASHDOT, and MEDIUMDASHDOTDOT. 
|             REFLINE_THICKNESS = Determines the line thickness for the reference lines.  Default is 1pt.
|             REFLINE_LABELS = Specifies labels for the reference lines.  These will be displayed at the right end of the reference
|                              lines outside of the graph.  Specify each label separated by | symbol to differentiate between
|                              reference lines.  Example: REFLINES=20 40 60.  REFLINE_LABELS=Line 1|Line 2|Line 3.  This will label
|                              the line at y=20 as Line 1, the line at 40 as Line 2, and the line at 60 as Line 3.
|             REFLINE_LABELS_SIZE = Determines the size of the reference line labels.  Default is 10pt.
|             REFLINE_LABELS_WEIGHT = Determines the weight of the reference line labels.  Options are BOLD and NORMAL.  Default is NORMAL.
|         2.5.6: Titles/Footnotes Options
|             TITLE = Determines the title for the plot.  Multiple lines can be made with the ` symbol acting as a line break.
|             TITLE_ALIGN = Determines the alignment of the title.  Options are LEFT, CENTER, and RIGHT.  Default is CENTER.
|             TITLE_SIZE = Determines the size of the title.  Default is 13pt.
|             TITLE_WEIGHT = Determines the weight of the title.  Options are BOLD and NORMAL.  Default is BOLD.
|             FOOTNOTE = Determines the footnote for the plot.  Multiple lines can be made with the ` symbol acting as a line break.
|             FOOTNOTE_ALIGN = Determines the alignment of the footnote.  Options are LEFT, CENTER and, RIGHT.  Default is LEFT.
|             FOOTNOTE_SIZE = Determines the size of the footnote.  Default is 10pt.
|             FOOTNOTE_WEIGHT = Determines the weight of the footnote.  Options are BOLD and NORMAL.  Default is NORMAL.
|     2.6: Output Controlling Options
|         2.6.1: Document Options
|             DESTINATION = Determines the ODS destionation the graph will be saved into when using OUTDOC.  Options are
|                           RTF, PDF, HTML, EXCEL, and POWERPOINT.  Default is RTF.
|             OUTDOC = Specifies a document to save the graph to.  Include full file path and file name with extension.
|         2.6.2: Image Options
|             ANTIALIASMAX = Specifies the maximum antialias for the images.  Higher values
|                            are needed for when the graph has many objects.  Default is 1000.
|             BACKGROUND = Determines the background color of the image.  Default is white.
|             BORDER = Determines if the border is drawn around the image.  Options are
|                      1 (yes) and 0 (no).  Default is 1.
|             DPI = Determines the resolution of the image.  Higher numbers have more resolution
|                   but take up more storage space.  Default is 200.
|             FONTCOLOR = Determines the color of the font for all text in the graph.  Default is black.
|             GPATH = Determines the location the graph image is saved to.  ODS LISTING must be turned on
|                     to save images.
|             HEIGHT = Determines the height of the image.  Default is 4in.
|             PLOTNAME =  Determines the name of the image file.  Default is _waterfall.
|             PLOTTYPE = Determines the type of image file.  Default is PNG.
|             SVG = Determines if scalable vector graphics is enabled for the image.  Options are 
|                   1 (yes) and 0 (no).  Default is 1.
|             TIFFDEVICE = Determines the GDEVICE to use when making TIFF plots.  Default is TIFFP.
|                          Options can be found with PROC GDEVICE catalogue=sashelp.devices;run;
|             TRANSPARENT = Determines if the plot background is transparent.  Options are 1 (yes) and 0 (no).
|                           Default is 1.
|             WIDTH = Determines the width of the graph image.  Default is 6in.
*------------------------------------------------------------------*
| OPERATING SYSTEM COMPATIBILITY
| UNIX SAS v9.4M3   :   YES
| PC SAS v9.4M3     :   YES
*------------------------------------------------------------------*
| MACRO CALL
|
| %waterfall (
|            DATA=,
|            VAR=
|          );
*------------------------------------------------------------------*
| EXAMPLES 
*Taken from SAS Online Example;
data TumorSize;
  length Cid $ 3;
  label Change='Change from Baseline (%)';
  do Id=1 to 25;
    cid=put(id, 2.0);
    change=30-120*ranuni(2);
    Group=ifc(int(ranuni(2)+0.5), 'Treatment 1', 'Treatment 2');
    Duration=floor(50+100*ranuni(2));
    Drop=ifn(ranuni(2) < 0.3, floor(duration-10), .);
    if mod(id, 5) = 1 then Label='C';
    if mod(id, 5) = 2 then label='R';
    if mod(id, 5) = 3 then label='S';
    if mod(id, 5) = 4 then label='P';
    if mod(id, 5) = 0 then label='N';
    output;
  end;
run;
*Example 1: Basic Example Call;
%waterfall(data=tumorsize, var = change)
*Example 2: Group plot by colors;
%waterfall(data=tumorsize, var = change, group=group)
*Example 3: Group plot by colors in order of response;
%waterfall(data=tumorsize, var = change, group=group, id_order=id)
*Example 4: Multiple graphs with a BY variable;
%waterfall(data=tumorsize, var = change, by=group,height=6in)
*Example 5: Reference Lines;
%waterfall(data=tumorsize, var = change, reflines=20 -30, refline_labels=Progression|Partial Response)
*Example 6: Change the axes;
%waterfall(data=tumorsize, var = change, reflines=20 -30 -100, refline_labels=Progression|Partial Response|Complete Response, yaxis_tickvalues=20 0 -30 -100,yaxis_max=50,yaxis_min=-105)
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


%macro waterfall(
    /*Required Options*/
    data=, var=, 
    /**Variable Options**/
    intercept=0, var_order=descending, id_order=group,
    /**Group Options**/
    group=, group_order=, 
    patternvar=, patternvar_order=, 
    /**By Options**/
    by=, by_order=, columns=, rows=,    
    /*Data Subset Options*/
    where=,    
    /*Plot Options*/
        /*Bar Fill/Color Options*/
        colors=blue, patterns=,
        /*Axis Options*/
        yaxis_tickvalues=, yaxis_label=, yaxis_min=, yaxis_max=,
        yaxis_label_size=10pt, yaxis_label_weight=bold,
        yaxis_tickvalue_size=10pt, yaxis_tickvalue_weight=normal,
        axiscolor=black,
        /*Group Legend Options*/
        legend_display=1,
        legend_across=, legend_down=, legend_title=, 
        legend_title_size=10pt, legend_title_weight=bold, 
        legend_values_size=10pt, legend_values_weight=normal,
        /*Pattern Legend Options*/
        legend2_display=1,
        legend2_across=, legend2_down=, legend2_title=, 
        legend2_title_size=10pt, legend2_title_weight=bold, 
        legend2_values_size=10pt, legend2_values_weight=normal,
        /*Cell Header Options*/
        header_size=12pt, header_weight=bold, header_align=center,
        /*Reference Line Options*/
        reflines=, refline_color=grey, refline_pattern=2, refline_thickness=1pt,
        refline_labels=, refline_labels_size=10pt, refline_labels_weight=normal,
        /*Title/Footnotes Options*/
        title=, title_weight=bold, title_size=13pt, title_align=center,
        footnote=, footnote_weight=normal, footnote_size=10pt, footnote_align=left,
    /*Output Controlling Options*/
        /*Document Options*/
        destination=rtf, outdoc=,
        /*Image Options*/
        antialiasmax=1000, background=white, border=1, dpi=200,
        fontcolor=black, gpath=, height=4in, plotname=_waterfall, plottype=png,
        svg=0,tiffdevice=TIFFP,transparent=0, width=6in,
        /*Output Graph Dataset*/
        out=
        );
        
    /**Save current options to reset after macro runs**/
    %local _mergenoby _notes _qlm _odspath _starttime _device _gsfname
        _xmax _ymax _xpixels _ypixels _imagestyle _iback _listing _linesize _center _gborder;
    %let _starttime=%sysfunc(time());
    %let _notes=%sysfunc(getoption(notes));
    %let _mergenoby=%sysfunc(getoption(mergenoby));
    %let _qlm=%sysfunc(getoption(quotelenmax)); 
    %let _device=%sysfunc(getoption(device));
    %let _gsfname=%sysfunc(getoption(gsfname));
    %let _xmax=%sysfunc(getoption(xmax));
    %let _ymax=%sysfunc(getoption(ymax));
    %let _xpixels=%sysfunc(getoption(xpixels));
    %let _ypixels=%sysfunc(getoption(ypixels));
    %let _imagestyle=%sysfunc(getoption(imagestyle));
    %let _gborder=%sysfunc(getoption(border));
    %let _iback=%sysfunc(getoption(iback));
    %let _linesize=%sysfunc(getoption(linesize));
    %let _center=%sysfunc(getoption(center));
    %let _odspath=&sysodspath;
    %if %sysevalf(%superq(_odspath)=,boolean) %then %let _odspath=WORK.TEMPLAT(UPDATE) SASHELP.TMPLMST (READ);
    /**Turn off warnings for merging without a by and long quote lengths**/
    /**Turn off notes**/
    options mergenoby=NOWARN nonotes noquotelenmax;
    ods path WORK.TEMPLAT(UPDATE) SASHELP.TMPLMST (READ);
    
    /**Process Error Handling**/
    %if &sysvlong < 9.04.01M3P062415 %then %do;
        %put ERROR: SAS must be version 9.4M3 or later;
        %goto errhandl;
    %end;       
    %else %if %sysfunc(exist(&data))=0 %then %do;
        %put ERROR: Dataset &data does not exist;
        %put ERROR: Please enter a valid dataset;
        %goto errhandl;
    %end;
    %else %if %sysevalf(%superq(data)=,boolean)=1 %then %do;
        %put ERROR: DATA parameter is required;
        %put ERROR: Please enter a valid dataset;
        %goto errhandl;
    %end;
    
    /**See if the listing output is turned on**/
    proc sql noprint;
        select 1 into :_listing separated by '' from sashelp.vdest where upcase(destination)='LISTING';
    quit;
    
    %local z nerror;
    %let nerror=0;
    /**Error Handling on Individual Model Variables**/
    %macro _varcheck(_var,require,numeric);
        %local _z _numcheck;
        /**Check if variable parameter is missing**/
        %if %sysevalf(%superq(&_var)=,boolean)=0 %then %do;
            %if %sysfunc(notdigit(%superq(&_var))) > 0 %then
                %do _z = 1 %to %sysfunc(countw(%superq(&_var),%str( )));
                /**Check to make sure variable names are not just numbers**/    
                %local datid;
                /**Open up dataset to check for variables**/
                %let datid = %sysfunc(open(&data));
                /**Check if variable exists in dataset**/
                %if %sysfunc(varnum(&datid,%scan(%superq(&_var),&_z,%str( )))) = 0 %then %do;
                    %put ERROR: (Global: %qupcase(&_var)) Variable %qupcase(%scan(%superq(&_var),&_z,%str( ))) does not exist in dataset &data;
                    %local closedatid;
                    /**Close dataset**/
                    %let closedatid=%sysfunc(close(&datid));
                    %let nerror=%eval(&nerror+1);
                %end;
                %else %do;
                    %local closedatid;
                    %let closedatid=%sysfunc(close(&datid));
                    %if &numeric=1 %then %do;
                        data _null_;
                            set &data (obs=1);
                            call symput('_numcheck',strip(vtype(%superq(&_var))));
                        run;
                        %if %sysevalf(%superq(_numcheck)^=N,boolean) %then %do;
                            %put ERROR: (Global: %qupcase(&_var)) Variable must be numeric;
                            %let nerror=%eval(&nerror+1);
                        %end;   
                    %end;                         
                %end;
            %end;
            %else %do;
                /**Give error message if variable name is number**/
                %put ERROR: (Global: %qupcase(&_var)) Variable is not a valid SAS variable name (%superq(&_var));
                %let nerror=%eval(&nerror+1);
            %end;
        %end;
        %else %if &require=1 %then %do;
            /**Give error if required variable is missing**/
            %put ERROR: (Global: %qupcase(&_var)) Variable is a required variable but has no value;
            %let nerror=%eval(&nerror+1);
        %end;
    %mend;
    /**Check time variables**/
    %_varcheck(var,1,1)
    %_varcheck(group,0)
    %_varcheck(patternvar,0)
    %_varcheck(by,0)
    
    /**Error Handling on Global Parameters**/
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
    /**Plot On/Off Options**/
    %_gparmcheck(id_order,GROUP|ID)
    %_gparmcheck(var_order,ASCENDING|DESCENDING)
    %_gparmcheck(yaxis_label_weight,BOLD|NORMAL)
    %_gparmcheck(yaxis_tickvalue_weight,BOLD|NORMAL)
    %_gparmcheck(legend_display,1|0)
    %_gparmcheck(legend_title_weight,BOLD|NORMAL)
    %_gparmcheck(legend_values_weight,BOLD|NORMAL)
    %_gparmcheck(legend2_display,1|0)
    %_gparmcheck(legend2_title_weight,BOLD|NORMAL)
    %_gparmcheck(legend2_values_weight,BOLD|NORMAL)
    %_gparmcheck(header_weight,BOLD|NORMAL)
    %_gparmcheck(header_align,LEFT|CENTER|RIGHT)
    %_gparmcheck(title_weight,BOLD|NORMAL)
    %_gparmcheck(footnote_weight,BOLD|NORMAL)
    %_gparmcheck(title_align,LEFT|CENTER|RIGHT)
    %_gparmcheck(footnote_align,LEFT|CENTER|RIGHT)
    %_gparmcheck(destination,RTF|PDF|HTML|EXCEL|POWERPOINT)
    %_gparmcheck(border,1|0)
    %_gparmcheck(transparent,1|0)
    %_gparmcheck(svg,1|0)
    %_gparmcheck(plottype,STATIC|BMP|DIB|EMF|EPSI|GIF|JFIF|JPEG|PBM|PCD|PCL|PDF|PICT|PNG|PS|SVG|TIFF|WMF|XBM|XPM)
    
    /*Tiff Device Check*/
    %if %sysevalf(%qupcase(&plottype)=TIFF,boolean) or  %sysevalf(%qupcase(&plottype)=TIF,boolean) %then %do;
        ods select none;
        ods noresults;
        ods output gdevice=_gdevice;
        proc gdevice catalog=sashelp.devices nofs;
            list _all_;
        run;
        quit;
        %global _tifflist _tiffcheck;
        proc sql noprint;
            select 1 into :_tiffcheck from _gdevice where upcase(name)=upcase("&tiffdevice");
            select distinct upcase(name) into :_tifflist separated by '|' from _gdevice
                where substr(upcase(name),1,3)='TIF';
            %if %sysevalf(%superq(_tiffcheck)^=1,boolean) %then %do;
                /**If not then throw error**/
                %put ERROR: (Global: TIFFDEVICE): %qupcase(%superq(tiffdevice)) is not on the installed list of devices;
                %put ERROR: (Global: TIFFDEVICE): Please select from the following list &_tifflist;
                %let nerror=%eval(&nerror+1);
            %end;
            drop table _gdevice;
        quit;
        ods select all;
        ods results;
    %end;
   
   
    /**Error Handling on Global Parameters Involving units**/
    %macro _gunitcheck(parm);
        %if %sysevalf(%superq(&parm)=,boolean)=1 %then %do;
            /**Check if missing**/
            %put ERROR: (Global: %qupcase(&parm)) Cannot be set to missing;
            %let nerror=%eval(&nerror+1);
        %end;
        %else %if %sysfunc(compress(%superq(&parm),ABCDEFGHIJKLMNOPQRSTUVWXYZ,i)) lt 0 %then %do;
            /**Throw error**/
            %put ERROR: (Global: %qupcase(&parm)) Cannot be less than zero (%qupcase(%superq(&parm)));
            %let nerror=%eval(&nerror+1);
        %end;
    %mend;
    %_gunitcheck(yaxis_label_size)
    %_gunitcheck(yaxis_tickvalue_size)
    %_gunitcheck(legend_title_size)
    %_gunitcheck(legend_values_size)
    %_gunitcheck(legend2_title_size)
    %_gunitcheck(legend2_values_size)
    %_gunitcheck(header_size)
    %_gunitcheck(refline_thickness)
    %_gunitcheck(title_size)
    %_gunitcheck(footnote_size)
    %_gunitcheck(height)
    %if %sysevalf(%qupcase(%superq(plottype))=TIFF,boolean) or
        %sysevalf(%qupcase(%superq(plottype))=TIF,boolean) %then %do;
        %if %sysfunc(find(%superq(height),px,i))>0 %then %do;
            /**Throw error**/
            %put ERROR: (Global: HEIGHT) Must use units of IN when PLOTTYPE=%qupcase(&plottype);
            %let nerror=%eval(&nerror+1);
        %end;
    %end;
    %_gunitcheck(width)
    /**Error Handling on Individual Model Numeric Variables**/
    %macro _gnumcheck(parm, min, require);
        /**Check if missing**/
        %if %sysevalf(%superq(&parm)^=,boolean) %then %do;
            %if %sysfunc(notdigit(%sysfunc(compress(%superq(&parm),-.)))) > 0 %then %do;
                /**Check if character value**/
                %put ERROR: (Global: %qupcase(&parm)) Must be numeric.  %qupcase(%superq(&parm)) is not valid.;
                %let nerror=%eval(&nerror+1);
            %end;
            %else %if %sysevalf(%superq(min)^=,boolean) %then %do;
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
    %_gnumcheck(intercept,%str( ),1)
    %_gnumcheck(yaxis_min)
    %_gnumcheck(yaxis_max)
    %_gnumcheck(rows,1)
    %_gnumcheck(columns,1)
    %_gnumcheck(legend_across,1)
    %_gnumcheck(legend_down,1)
    %_gnumcheck(legend2_across,1)
    %_gnumcheck(legend2_down,1)
    %_gnumcheck(dpi,100)
    %_gnumcheck(antialiasmax,100)
    
    /**Numerical list Check **/
    %macro _gnumcheck2(parm,loopmax);
        %local z z2;
        %do z2 = 1 %to %sysfunc(countw(%superq(&parm),%str( )));
            /**Check if missing**/
            %if %sysevalf(%scan(%superq(&parm),&z2,%str( ))=,boolean)=0 %then %do;
                %if %sysfunc(notdigit(%sysfunc(compress(%scan(%superq(&parm),&z2,%str( )),-.)))) > 0 %then %do;
                    /**Check if character values are present**/
                    %put ERROR: (Global: %qupcase(&parm)) Must be numeric.  %qupcase(%scan(%superq(&parm),&z2,%str( ))) is not valid.;
                    %let nerror=%eval(&nerror+1);
                %end;  
            %end;
        %end;    
    %mend; 
    %_gnumcheck2(reflines)
    /*Error Checking on Global Line Pattern Parameters*/     
    %macro _glinepattern(parm,_max);
        %local _patternlist z2 _test;
        %let _patternlist=%sysfunc(compress(SOLID|SHORTDASH|MEDIUMDASH|LONGDASH|MEDIUMDASHSHORTDASH|
        DASHDASHDOT|DASH|LONGDASHSHORTDASH|DOT|THINDOT|SHORTDASHDOT|MEDIUMDASHDOTDOT));
        /**Check for missing values**/
        %if %sysevalf(%superq(&parm)^=,boolean) %then %do;           
            %if %sysevalf(&_max^=,boolean) %then %do;
                %if %sysevalf(%sysfunc(countw(%superq(&parm),%str( )))>&_max,boolean) %then %do;
                    /**Throw error**/
                    %put ERROR: (Global: %qupcase(&parm)): Number of items in list (%sysfunc(countw(%superq(&parm),%str( )))) must be less than or equal to &_max;
                    %let nerror=%eval(&nerror+1);
                %end;
            %end;
            %do z2=1 %to %sysfunc(countw(%superq(&parm),%str( )));
                %let _test=;
                /**Check if values are either in the approved list, or are between 1 and 46**/
                %if %sysfunc(notdigit(%scan(%superq(&parm),&z2,%str( ))))>0 %then %do _z = 1 %to %sysfunc(countw(&_patternlist,|));
                    %if %qupcase(%scan(%superq(&parm),&z2,%str( )))=%scan(%qupcase(%sysfunc(compress(&_patternlist))),&_z,|,m) %then %let _test=1;
                %end;
                %else %if %scan(%superq(&parm),&z2,%str( )) ge 1 and %scan(%superq(&parm),&z2,%str( )) le 46 %then %let _test=1;
                %if &_test ^= 1 %then %do;
                    /**Throw error**/
                    %put ERROR: (Global: %qupcase(&parm)): %qupcase(%scan(%superq(&parm),&z2,%str( ))) is not in the list of valid values;
                    %put ERROR: (Global: %qupcase(&parm)): Possible values are %qupcase(&_patternlist) or Numbers Between 1 and 46;
                    %let nerror=%eval(&nerror+1);
                %end;
            %end;
        %end;
        %else %do;
            /**Throw error**/
            %put ERROR: (Global: %qupcase(&parm)): Cannot be missing;           
            %put ERROR: (Global: %qupcase(&parm)): Possible values are %qupcase(&_patternlist) or Numbers Between 1 and 46;
            %let nerror=%eval(&nerror+1);       
        %end;
    %mend; 
    %_glinepattern(refline_pattern,1)
    
    /**Line Pattern Variables**/
    %macro _listcheck(var=,_list=,lbl=,msg=);
        %local _z _z2 _test;
        %if %sysevalf(%superq(lbl)=,boolean) %then %let lbl=%qupcase(&var.);
        /**Check for missing values**/
        %if %sysevalf(%superq(&var.)=,boolean)=0 %then %do _z2=1 %to %sysfunc(countw(%superq(&var.),%str( )));
            %let _test=;
            /**Check if values are either in the approved list**/
            %do _z = 1 %to %sysfunc(countw(&_list,|));
                %if %qupcase(%scan(%superq(&var.),&_z2,%str( )))=%scan(%qupcase(%sysfunc(compress(&_list))),&_z,|,m) %then %let _test=1;
            %end;
            %if &_test ^= 1 %then %do;
                /**Throw error**/
                %put ERROR: (Global: &lbl): %qupcase(%scan(%superq(&var.),&_z2,%str( ))) is not in the list of valid values &msg;
                %put ERROR: (Global: &lbl): Possible values are %qupcase(&_list);
                %let nerror=%eval(&nerror+1);
            %end;
        %end;
        %else %do;
            /**Throw error**/
            %put ERROR: (Global: &lbl): %qupcase(%superq(&var.)) is not in the list of valid values &msg;         
            %put ERROR: (Global: &lbl): Possible values are %qupcase(&_list);
            %let nerror=%eval(&nerror+1);       
        %end;
    %mend;
    
    /**Check list parameters**/
    %if %sysevalf(%superq(patterns)^=,boolean) %then %_listcheck(var=patterns,_list=S|E|L1|L2|L3|L4|L5|R1|R2|R3|R4|R5|X1|X2|X3|X4|X5)
    /*** If any errors exist, stop macro and send to end ***/
    %if &nerror > 0 %then %do;
        %put ERROR: &nerror pre-run errors listed;
        %put ERROR: Macro WATERFALL will cease;
        %goto errhandl;
    %end;    
    /*Don't send anything to output window, results window, and set escape character*/
    ods select none;
    ods noresults escapechar='^';
    %if %sysevalf(%superq(group)=%superq(patternvar),boolean)  and %sysevalf(%superq(patterns)^=,boolean) %then %do;
        %let patternvar=;
        %let patternvar_order=;
    %end;
    data _temp;
        set &data;
        where ^missing(&var) 
            %if %sysevalf(%superq(where)^=,boolean) %then %do; and &where %end;;
        %local _var_label _group_label _by_label;
        if _n_=1 then do;
            call symput('_var_label',strip(vlabel(&var)));
            %if %sysevalf(%superq(by)^=,boolean) %then %do;
                call symput('_by_label',vlabel(&by));
            %end;
            %if %sysevalf(%superq(group)^=,boolean) %then %do;
                call symput('_group_label',vlabel(&group));
            %end;
            %if %sysevalf(%superq(patternvar)^=,boolean) %then %do;
                call symput('_patv_label',vlabel(&patternvar));
            %end;
        end;            
    run;
    %local datcheck;
    proc sql noprint;
        %if %sysfunc(exist(_temp))>0 %then %do;
            select count(*) into :datcheck from _temp;
        %end;
        %else %let datcheck=0;
    quit;
    %if &datcheck =0 %then %do;
        %put ERROR: (Model &z: WHERE): Issue parsing the WHERE clause;
        %let nerror_run=%eval(&nerror_run+1);
        %goto errhandl2; 
    %end;
    
    data _temp;
        merge _temp (keep=&var rename=(&var=_var))
              %if %sysevalf(%superq(by)^=,boolean) %then %do; _temp (keep=&by rename=(&by=_by)) %end; 
              %if %sysevalf(%superq(group)^=,boolean) %then %do; _temp (keep=&group rename=(&group=_group)) %end;
              %if %sysevalf(%superq(patternvar)^=,boolean) %then %do; _temp (keep=&patternvar rename=(&patternvar=_patv)) %end;  ;
    
    
        length _by_formatted _group_formatted _patv_formatted $300.;
        %if %sysevalf(%superq(by)=,boolean) %then %do;
            _by=.;_by_formatted='';
        %end;
        %else %do;
            _by_formatted=vvalue(_by);
            if missing(_by_formatted) then delete;
        %end;

        %if %sysevalf(%superq(group)=,boolean) %then %do;
            _group=1;_group_formatted='M';
        %end;
        %else %do;
            _group_formatted=vvalue(_group);
            if missing(_group_formatted) then delete;
        %end;

        %if %sysevalf(%superq(patternvar)=,boolean) %then %do;
            _patv=.;_patv_formatted='';
        %end;
        %else %do;
            _patv_formatted=vvalue(_patv);
        %end;
    
    run;
    
    /**Get By Order**/
    proc sort data=_temp;
        by _by;
        format _by;
    run;
    %local _nby nerror_run;
    %let nerror_Run=0;
    data _temp;
        set _temp end=last;
        by _by;
        if first._by then _by_order+1;
        if last then call symputx('_nby',_by_order);
    run;
    %if %sysevalf(%superq(by)^=,boolean) and %sysevalf(%superq(by_order)^=,boolean) %then %do;
        /**Pull largest value in order list**/
        %local _maxord;
        %let _maxord = %sysfunc(max(%sysfunc(tranwrd(%superq(by_order),%str( ),%str(,)))));
        /**Pull number of items in order list**/
        %local _nord;
        %let _nord = %sysfunc(countw(%superq(by_order),%str( )));
        /**Check if there are too many levels given**/
        %if &_nord ^= &_nby %then %do;
            /**Throw errors**/
            %put ERROR: (Global: %qupcase(by_order)): Number in order list (&_nord) does not equal the number of values for BY variable %qupcase(%superq(BY)) (&_nby);
            %let nerror_run=%eval(&nerror_run+1);
        %end;
        /**Check if the largest value is larger than the number of levels in the by variable**/
        %else %if &_maxord > &_nby %then %do;
            /**Throw errors**/
            %put ERROR: (Global: %qupcase(by_order)): Largest number in order list (&_maxord) is larger than the number of values for BY variable %qupcase(%superq(BY)) (&_nby);
            %let nerror_run=%eval(&nerror_run+1);
        %end;
        /**Check if all values from 1 to max are represented in the order list**/
        %else %do _z2=1 %to &_nby;
            %local _test;
            %let _test=;
            %do z = 1 %to &_maxord;
                %if %scan(%superq(by_order),&z,%str( )) = &_z2 %then %let _test=1;
            %end;
            %if &_test ^=1 %then %do;
                /**Throw errors**/
                %put ERROR: (Global: %qupcase(by_order)): Number &_z2 was not found in the by_order list;
                %put ERROR: (Global: %qupcase(by_order)): Each number from 1 to maximum number of levels in BY variable %qupcase(%superq(BY)) (&_maxord) must be represented;
                %let nerror_run=%eval(&nerror_run+1);
            %end;                                   
        %end;
        %if &nerror_run=0 %then %do;                
            data _temp;
                set _temp;
                
                %do i = 1 %to &_nby;
                    %if &i>1 %then %do; else %end;
                    if _by_order=%scan(%superq(by_order),&i,%str( )) then _by_order=&i;
                %end;
            run;
        %end;    
    %end;
    /**Get Group Order**/
    proc sort data=_temp;
        by _group;
        format _group;
    run;
    %local _ngroup;
    data _temp;
        set _temp end=last;
        by _group;
        if first._group then _group_order+1;
        if last then call symputx('_ngroup',_group_order);
    run;
    %if %sysevalf(%superq(group)^=,boolean) and %sysevalf(%superq(group_order)^=,boolean) %then %do;
        /**Pull largest value in order list**/
        %local _maxord;
        %let _maxord = %sysfunc(max(%sysfunc(tranwrd(%superq(group_order),%str( ),%str(,)))));
        /**Pull number of items in order list**/
        %local _nord;
        %let _nord = %sysfunc(countw(%superq(group_order),%str( )));
        /**Check if there are too many levels given**/
        %if &_nord ^= &_ngroup %then %do;
            /**Throw errors**/
            %put ERROR: (Global: %qupcase(group_order)): Number in order list (&_nord) does not equal the number of values for group variable %qupcase(%superq(group)) (&_ngroup);
            %let nerror_run=%eval(&nerror_run+1);
        %end;
        /**Check if the largest value is larger than the number of levels in the group variable**/
        %else %if &_maxord > &_ngroup %then %do;
            /**Throw errors**/
            %put ERROR: (Global: %qupcase(group_order)): Largest number in order list (&_maxord) is larger than the number of values for group variable %qupcase(%superq(group)) (&_ngroup);
            %let nerror_run=%eval(&nerror_run+1);
        %end;
        /**Check if all values from 1 to max are represented in the order list**/
        %else %do _z2=1 %to &_ngroup;
            %local _test;
            %let _test=;
            %do z = 1 %to &_maxord;
                %if %scan(%superq(group_order),&z,%str( )) = &_z2 %then %let _test=1;
            %end;
            %if &_test ^=1 %then %do;
                /**Throw errors**/
                %put ERROR: (Global: %qupcase(group_order)): Number &_z2 was not found in the group_order list;
                %put ERROR: (Global: %qupcase(group_order)): Each number from 1 to maximum number of levels in group variable %qupcase(%superq(group)) (&_maxord) must be represented;
                %let nerror_run=%eval(&nerror_run+1);
            %end;                                   
        %end;
        %if &nerror_run=0 %then %do;                
            data _temp;
                set _temp;
                
                %do i = 1 %to &_ngroup;
                    %if &i>1 %then %do; else %end;
                    if _group_order=%scan(%superq(group_order),&i,%str( )) then _group_order=&i;
                %end;
            run;
        %end;
    %end;
    /**Get Pattern Variable Order**/
    %if %sysevalf(%superq(patternvar)^=,boolean) %then %do;
        proc sort data=_temp out=_tempp;
            by _patv;
            format _patv;
            where ^missing(_patv);
        run;
        %local _npat;
        data _tempp;
            set _tempp end=last;
            by _patv;
            if first._patv then _patv_order+1;
            if last then call symputx('_npat',_patv_order);
        run;
        %if %sysevalf(%superq(patternvar_order)^=,boolean) %then %do;
            /**Pull largest value in order list**/
            %local _maxord;
            %let _maxord = %sysfunc(max(%sysfunc(tranwrd(%superq(patternvar_order),%str( ),%str(,)))));
            /**Pull number of items in order list**/
            %local _nord;
            %let _nord = %sysfunc(countw(%superq(patternvar_order),%str( )));
            /**Check if there are too many levels given**/
            %if &_nord ^= &_npat %then %do;
                /**Throw errors**/
                %put ERROR: (Global: %qupcase(group_order)): Number in order list (&_nord) does not equal the number of values for patternvar variable %qupcase(%superq(patternvar)) (&_npat);
                %let nerror_run=%eval(&nerror_run+1);
            %end;
            /**Check if the largest value is larger than the number of levels in the group variable**/
            %else %if &_maxord > &_npat %then %do;
                /**Throw errors**/
                %put ERROR: (Global: %qupcase(patternvar_order)): Largest number in order list (&_maxord) is larger than the number of values for patternvar variable %qupcase(%superq(patternvar)) (&_npat);
                %let nerror_run=%eval(&nerror_run+1);
            %end;
            /**Check if all values from 1 to max are represented in the order list**/
            %else %do _z2=1 %to &_npat;
                %local _test;
                %let _test=;
                %do z = 1 %to &_maxord;
                    %if %scan(%superq(patternvar_order),&z,%str( )) = &_z2 %then %let _test=1;
                %end;
                %if &_test ^=1 %then %do;
                    /**Throw errors**/
                    %put ERROR: (Global: %qupcase(patternvar_order)): Number &_z2 was not found in the patternvar_order list;
                    %put ERROR: (Global: %qupcase(patternvar_order)): Each number from 1 to maximum number of levels in patternvar variable %qupcase(%superq(patternvar)) (&_maxord) must be represented;
                    %let nerror_run=%eval(&nerror_run+1);
                %end;                                   
            %end;
            %if &nerror_run=0 %then %do;                
                data _tempp;
                    set _tempp;
                    
                    %do i = 1 %to &_npat;
                        %if &i>1 %then %do; else %end;
                        if _patv_order=&i then _patv_order=%scan(%superq(patternvar_order),&i,%str( ));
                    %end;
                run;
            %end;
        %end;
        proc sort data=_tempp;
            by _patv;
        proc sort data=_temp;
            by _patv;
        data _temp;
            merge _temp _tempp (keep=_patv _patv_order);
            by _patv;
        run;
    %end;
    %else %let _npat=0;
    /**Get ID Order**/
    proc sort data=_temp;
        by _by_order %if %sysevalf(%qupcase(&id_order)=GROUP,boolean) %then %do; _group_order %end; %if %sysevalf(%qupcase(&var_order)=DESCENDING,boolean) %then %do; descending %end; _var;
    run;
    data _temp;
        set _temp end=last;
        by _by_order %if %sysevalf(%qupcase(&id_order)=GROUP,boolean) %then %do; _group_order %end; %if %sysevalf(%qupcase(&var_order)=DESCENDING,boolean) %then %do; descending %end; _var;
        if first._by_order then _id_num=0;
        _id_num+1;
    run;
    /**Sort data**/
    proc sort data=_temp;
        by _group_order _by_order _id_num;
    run;
    
    
    %if %sysevalf(%superq(reflines)^=,boolean) %then %do;
        data _temp;
            set _temp;
                length _refline_ 8. _refline_label $400.;
                %do i = 1 %to %sysfunc(countw(%superq(reflines),%str( )));
                    %if &i>1 %then %do; else %end;
                    if _n_=&i then do;
                        _refline_=%scan(%superq(reflines),&i,%str( ));
                        _refline_label="%qscan(%superq(refline_labels),&i,|,m)";
                    end;
                %end;
        run;
    %end;
    proc sql noprint;
        %local max null _bylevels _grouplevels _patvlevels;
        select max(_id_num)+1 into :max separated by '' from _temp;
        select distinct _by_order,_by_formatted into :null, :_bylevels separated by '|' from _temp;
        select distinct _group_order,_group_formatted into :null, :_grouplevels separated by '|' from _temp;
        %if %sysevalf(%superq(patternvar)^=,boolean) %then %do;
            select distinct _patv_order,_patv_formatted into :null, :_patvlevels separated by '|' from _tempp;
        %end;
        %if %sysevalf(%superq(reflines)^=,boolean) %then %do i = 1 %to &_nby;
            %local cp_y&i cp_v&i;
            select distinct _refline_,_refline_label into :cp_y&i separated by '|',:cp_v&i separated by '|'
                from _temp where _by_order=&i;
        %end;
    quit;
    
    /**Tick Values**/
    %local tickvalues;
    %if %sysevalf(%superq(yaxis_tickvalues)^=,boolean) %then %do;
        data _null_;
            length tickvalues $3000.;
            tickvalues='';
            %if %sysevalf(%sysfunc(find(%superq(yaxis_tickvalues),to,i))>0,boolean) %then %do; do tick = &yaxis_tickvalues; %end;
            %else %if %sysevalf(%sysfunc(find(%superq(yaxis_tickvalues),%str(,),i))>0,boolean) %then %do; do tick = &yaxis_tickvalues; %end;
            %else %do; do tick = %sysfunc(tranwrd(%sysfunc(compbl(&yaxis_tickvalues)),%str( ),%str(,))); %end;
                tickvalues=catx(' ',strip(tickvalues),strip(put(tick,12.)));
            end;
            call symput('tickvalues',strip(tickvalues));
        run;
        %if %sysevalf(%superq(tickvalues)=,boolean) %then %do;
            /**Throw errors**/
            %put ERROR: (Global: %qupcase(yaxis_tickvalues)): Issue with format of tick value list;
            %put ERROR: (Global: %qupcase(yaxis_tickvalues)): Acceptable formats are %str(XX to XX by XX, a space delimited list, or a comma delimited list);
            %let nerror_run=%eval(&nerror_run+1);        
        %end;
    %end;
    
    %if &nerror_run > 0 %then %goto errhandl2;
    ods path WORK.TEMPLAT(UPDATE) SASHELP.TMPLMST (READ);
    /**Creates document to save**/
    %if %sysevalf(%superq(outdoc)=,boolean)=0 %then %do;
        ods escapechar='^';
        /**Sets up DPI and ODS generated file**/
        ods &destination 
            %if %qupcase(&destination)=RTF %then %do; 
                file="&outdoc"
                image_dpi=&dpi startpage=NO 
            %end;
            %else %if %qupcase(&destination)=HTML %then %do; 
                image_dpi=&dpi 
                %if %upcase(&sysscpl)=LINUX or %upcase(&sysscpl)=UNIX %then %do;
                    path="%substr(&outdoc,1,%sysfunc(find(&outdoc,/,-%sysfunc(length(&outdoc)))))"
                    file="%scan(&outdoc,1,/,b)"
                %end;
                %else %do;
                    path="%substr(&outdoc,1,%sysfunc(find(&outdoc,\,-%sysfunc(length(&outdoc)))))"
                    file="%scan(&outdoc,1,\,b)"
                %end;
                %if %sysevalf(%superq(gpath)=,boolean)=0 %then %do;
                    gpath="&gpath" (url=none)
                %end;
            %end;
            %else %if %qupcase(&destination)=PDF %then %do; 
                dpi=&dpi startpage=NO bookmarkgen=off notoc
                file="&outdoc"
            %end;
            %else %if %qupcase(&destination)=EXCEL %then %do; 
                file="&outdoc"
                dpi=&dpi options(sheet_interval='none') 
            %end;
            %else %if %qupcase(&destination)=POWERPOINT %then %do; 
                file="&outdoc"
                dpi=&dpi 
            %end;;
    %end;
    %else %if %SYMEXIST(_clientapp) %then %do;
        %if &_listing=0 or %sysevalf(%superq(gpath)=,boolean) %then %do;
            ods listing close image_dpi=&dpi;
        %end;
        %else %do;
            ods listing image_dpi=&dpi %if %sysevalf(%superq(gpath)^=,boolean) %then %do;  gpath="&gpath" %end;;
        %end;    
    %end;
    %else %do;
        %if &_listing=0 %then %do;
            ods listing close image_dpi=&dpi;
        %end;
        %else %do;
            ods listing image_dpi=&dpi %if %sysevalf(%superq(gpath)^=,boolean) %then %do;  gpath="&gpath" %end;;
        %end; 
    %end;
    proc sql noprint;
        %local _destinations;
        select upcase(destination),upcase(style) into :_destinations separated by '|',:_styles separated by '|'
            from sashelp.vdest
            where upcase(destination)^in('OUTPUT');
    quit;
    proc template;
        %do i = 1 %to %sysfunc(countw(%superq(_destinations),|));
            define style styles.newsurv_axes&i;
                parent=styles.%scan(%superq(_styles),&i,|);
                class GraphAxisLines /
                    ContrastColor=&axiscolor
                    color=&axiscolor;
                class GraphBorderLines /
                    contrastcolor=&axiscolor
                    color=&axiscolor;
                class GraphWalls /
                    contrastcolor=&axiscolor
                    color=&axiscolor;
                class Graph / attrpriority = "none";  
                %if %sysevalf(%superq(patternvar)=,boolean) and %sysevalf(%superq(patterns)^=,boolean) %then %do j = 1 %to &_ngroup;
                    %if %sysevalf(%qscan(%superq(patterns),&j,%str( ))^=,boolean) %then %do; 
                        style GraphData&j from graphdata&j / fillpattern = "%scan(%superq(patterns),&j,%str( ))";
                    %end;
                    %else %do;
                        style GraphData&j from graphdata&j  / fillpattern = "E";
                    %end;
                %end;
                %else %do j = 1 %to &_ngroup;
                    style GraphData&j from graphdata&j  / fillpattern = "E";
                %end;
                End;
        %end;
        define statgraph _waterfall;
            begingraph / designheight=&height designwidth=&width
                backgroundcolor=&background        
                %if %superq(transparent)=1 %then %do;
                    opaque=false 
                %end;
                /**Turns the border around the plot off if border=0**/
                %if %superq(border)=0 %then %do;
                    border=false 
                    %if %superq(transparent)=1 %then %do;
                        pad=0px    
                    %end;
                %end;;
                %local i;
                discreteattrmap name='attrs' / DISCRETELEGENDENTRYPOLICY=ATTRMAP ;
                    %do i = 1 %to &_ngroup;
                        value "%qscan(%superq(_grouplevels),&i,|,m)" / 
                            fillattrs=(%if %sysevalf(%qscan(%superq(colors),&i,%str( ))^=,boolean) %then %do; 
                                          color=%qscan(%superq(colors),&i,%str( ))
                                       %end;
                                       transparency=0);
                    %end;
                enddiscreteattrmap;
                discreteattrvar var=_group_formatted attrvar=_attr_ attrmap='attrs';   
                /**Create plot title**/
                %if %sysevalf(%superq(title)=,boolean)=0 %then %do i = 1 %to %sysfunc(countw(%superq(title),`,m));
                    entrytitle halign=&title_align textattrs=(color=&fontcolor weight=&title_weight size=&title_size style=normal) "%scan(%superq(title),&i,`,m)" / 
                        ;
                %end;
                /**Create plot footnote**/
                %if %sysevalf(%superq(footnote)=,boolean)=0 %then %do i = 1 %to %sysfunc(countw(%superq(footnote),`,m));
                    entryfootnote halign=&footnote_align textattrs=(color=&fontcolor weight=&footnote_weight size=&footnote_size style=normal) "%scan(%superq(footnote),&i,`,m)" / 
                        ;
                %end;
                
                layout lattice / rows=&_nby columns=1;
                    %if %sysevalf(%superq(group)^=,boolean) and &legend_display=1 %then %do;
                        sidebar / align=bottom;  
                            discretelegend 'Plot 1' / 
                                valign=top halign=center border=false opaque=false 
                                %if %sysevalf(%superq(legend_title)^=,boolean) %then %do; title="%superq(legend_title)" %end;
                                %else %do; title="%superq(_group_label)" %end; 
                                %if %sysevalf(%superq(legend_across)^=,boolean) %then %do; across=&legend_across %end;
                                %if %sysevalf(%superq(legend_down)^=,boolean) %then %do; down=&legend_across %end;
                                titleattrs=(size=&legend_title_size weight=&legend_title_weight color=&fontcolor)
                                valueattrs=(size=&legend_values_size weight=&legend_values_weight color=&fontcolor) ;
                        endsidebar;
                    %end;
                    %if %sysevalf(%superq(patternvar)^=,boolean) and &legend2_display=1 %then %do;
                        sidebar / align=bottom;  
                            discretelegend %do j = 1 %to &_npat; "Pattern 1-&j" %end; / valign=top halign=center border=false opaque=false 
                                %if %sysevalf(%superq(legend2_title)^=,boolean) %then %do; title="%superq(legend2_title)" %end;
                                %else %do; title="%superq(_patv_label)" %end; 
                                %if %sysevalf(%superq(legend2_across)^=,boolean) %then %do; across=&legend2_across %end;
                                %if %sysevalf(%superq(legend2_down)^=,boolean) %then %do; down=&legend2_across %end;
                                titleattrs=(size=&legend2_title_size weight=&legend2_title_weight color=&fontcolor)
                                valueattrs=(size=&legend2_values_size weight=&legend2_values_weight color=&fontcolor);
                        endsidebar;
                    %end;
                    %do i = 1 %to &_nby;
                        layout lattice / rows=1 columns=%sysevalf(1+(%sysevalf(%superq(reflines)^=,boolean) and %sysevalf(%superq(refline_labels)^=,boolean)))
                            columnweights=preferred rowdatarange=union opaque=false;
                            sidebar / align=top;
                                entry halign=&header_align "%qscan(&_bylevels,&i,|,m)" / border=false textattrs=(size=&header_size weight=&header_weight color=&fontcolor);
                            endsidebar;
                            rowaxes;
                                rowaxis / label="%superq(_var_label)" display=(label ticks tickvalues)
                                    labelattrs=(size=&yaxis_label_size weight=&yaxis_label_weight color=&fontcolor)
                                    type=linear offsetmin=0 offsetmax=0 tickvalueattrs=(size=&yaxis_tickvalue_size weight=&yaxis_tickvalue_weight color=&fontcolor)
                                    linearopts=(tickvaluefitpolicy=none %if %sysevalf(%superq(tickvalues)^=,boolean) %then %do; tickvaluelist=(&tickvalues) %end;
                                                %if %sysevalf(%superq(yaxis_min)^=,boolean) %then %do; viewmin=&yaxis_min %end;
                                                %if %sysevalf(%superq(yaxis_max)^=,boolean) %then %do; viewmax=&yaxis_max %end;
                                                );
                            endrowaxes;
                            layout overlay / walldisplay=(outline)
                                xaxisopts=(display=(line) type=linear offsetmin=0 offsetmax=0 linearopts=(viewmin=0 viewmax=&max))
                                yaxisopts=(label="%superq(_var_label)" 
                                    labelattrs=(size=&yaxis_label_size weight=&yaxis_label_weight color=&fontcolor)
                                    type=linear offsetmin=0 offsetmax=0 tickvalueattrs=(size=&yaxis_tickvalue_size weight=&yaxis_tickvalue_weight color=&fontcolor)
                                    linearopts=(tickvaluefitpolicy=none %if %sysevalf(%superq(tickvalues)^=,boolean) %then %do; tickvaluelist=(&tickvalues) %end;
                                                %if %sysevalf(%superq(yaxis_min)^=,boolean) %then %do; viewmin=&yaxis_min %end;
                                                %if %sysevalf(%superq(yaxis_max)^=,boolean) %then %do; viewmax=&yaxis_max %end;
                                                ));
                                referenceline y=&intercept / lineattrs=(color=&axiscolor);
                                
                                
                                %do j = 1 %to &_ngroup;
                                    barchartparm x=eval(ifn(_by_order=&i and _group_order=&j,_id_num,.)) y=_var / display=(fill fillpattern) groupdisplay=cluster
                                            baselineintercept=&intercept group=_attr_ name="Plot &i" fillpatternattrs=(color=black);
                                %end;
                                %if %sysevalf(%superq(patternvar)^=,boolean) %then %do j = 1 %to &_npat;
                                    barchartparm x=eval(ifn(_by_order=&i and _patv_order=&j,_id_num,.)) y=eval(ifn(_by_order=&i and _patv_order=&j,_var,.)) / 
                                        baselineintercept=&intercept legendlabel="%qscan(%superq(_patvlevels),&j,|,m)" name="Pattern &i-&j" groupdisplay=cluster
                                        display=(fillpattern)
                                        %if %sysevalf(%qscan(%superq(patterns),&j,%str( ))^=,boolean) %then %do; 
                                            fillpatternattrs=(pattern=%qscan(%superq(patterns),&j,%str( )) color=black)
                                        %end;
                                        %else %do;
                                            fillpatternattrs=(pattern=E)
                                        %end;;
                                %end;   
                                /**Add Reference Lines**/
                                %if %sysevalf(%superq(reflines)^=,boolean) %then %do;
                                    referenceline y=_refline_ / lineattrs=(color=&refline_color pattern=&refline_pattern thickness=&refline_thickness);
                                %end;
                            
                            endlayout;
                            %if %sysevalf(%superq(reflines)^=,boolean) and %sysevalf(%superq(refline_labels)^=,boolean) %then %do;
                                layout overlay / walldisplay=none ;
                                    axistable y=_refline_ value=eval(repeat('A0'x,1.5*length(_refline_label))) / display=(values) valueattrs=(size=&refline_labels_size weight=&refline_labels_weight)
                                        valuehalign=left;
                                    %do j = 1 %to %sysfunc(countw(%superq(cp_y&i),|,m));
                                        %if %sysevalf(%qscan(%superq(cp_v&i),&j,|,m)^=,boolean) %then %do;
                                            drawtext textattrs=(color=&fontcolor size=&refline_labels_size weight=&refline_labels_weight) "%qscan(%superq(cp_v&i),&j,|,m)" / 
                                                y=%scan(%superq(cp_y&i),&j,|,m) x=0  yspace=datavalue xspace=layoutpercent width=100 
                                                anchor=left justify=left;
                                        %end;
                                    %end;
                                endlayout;
                            %end;
                        endlayout;
                    %end;
                endlayout;
            endgraph;
        end;
    run;
    /**Save image to specified location**/
    %if %sysevalf(%superq(gpath)=,boolean)=0 %then %do;
        ods listing gpath="&gpath";
    %end;
    %else %do;
        ods listing close;
    %end;
    /**Names and formats the image**/
    %if %sysevalf(%superq(plottype)^=,boolean) %then %do; 
        %if %qupcase(&plottype)=EMF or (&svg=1 and %qupcase(&destination)=RTF and %qupcase(&plottype)^=TIFF and %qupcase(&plottype)^=TIF)  
            or (&svg=1 and %qupcase(&destination)=EXCEL)
            or (&svg=1 and %qupcase(&destination)=POWERPOINT) %then %do;
            options printerpath='emf';
            ods graphics / imagefmt=&plottype;  
            %if &transparent=0 %then %do;
                /**Modifies temporary registry keys to create better EMF image in 9.4**/
                /**Taken from SAS Technical Support Martin Mincey**/
                %local workdir;
                %let workdir=%trim(%sysfunc(pathname(work))); 
                /**Creates the new keys**/
                data _null_;
                %if %qupcase(&sysscp)=WIN %then %do; 
                    file "&workdir.\_newsurv_emf94.sasxreg";
                %end;
                %else %do;
                    file "&workdir./_newsurv_emf94.sasxreg";
                %end;
                put '[CORE\PRINTING\PRINTERS\EMF\ADVANCED]';
                put '"Description"="Enhanced Metafile Format"';
                put '"Metafile Type"="EMF"';
                put '"Vector Alpha"=int:0';
                put '"Image 32"=int:1';
                run;    
                %if %qupcase(&sysscp)=WIN %then %do; 
                    proc registry export="&workdir.\_newsurv_preexisting.sasxreg";/* Exports current SASUSER Keys */
                    proc registry import="&workdir.\_newsurv_emf94.sasxreg"; /* Import the new keys */
                    run;
                %end;
                %else %do;
                    proc registry export="&workdir./_newsurv_preexisting.sasxreg";/* Exports current SASUSER Keys */
                    proc registry import="&workdir./_newsurv_emf94.sasxreg"; /* Import the new keys */
                    run;
                %end;
            %end;
            %else %do;
                ods graphics / imagefmt=&plottype;  
            %end;
        %end;
        %else %if %qupcase(&plottype)=TIFF or %qupcase(&plottype)=TIF %then %do;
            ods graphics / imagefmt=png;    
        %end;
        %else %do;
            ods graphics / imagefmt=&plottype;  
        %end;          
    %end;
    %if %sysevalf(%superq(plotname)^=,boolean) %then %do; 
        ods graphics / reset=index imagename="&plotname";
    %end;  
    /**Turns on Scalable-Vector-Graphics**/
    %if &svg = 1 %then %do;
        %if %qupcase(&destination) = RTF or %qupcase(&destination) = EXCEL or %qupcase(&destination) = POWERPOINT %then %do;
            ods graphics / OUTPUTFMT=EMF;
        %end;
        %else %if %qupcase(&destination) = HTML %then %do;
            ods graphics / OUTPUTFMT=SVG;
        %end;
        %else %do;
            ods graphics / OUTPUTFMT=STATIC;
        %end;
    %end;          
    %do i = 1 %to %sysfunc(countw(%superq(_destinations),|));
        ods %scan(%superq(_destinations),&i,|) style=newsurv_axes&i
             %if %qupcase(%scan(%superq(_destinations),&i,|))=LISTING and %sysevalf(%superq(gpath)^=,boolean) %then %do;  gpath="&gpath" %end;;
    %end;
    /**Turn Results and ODS back on**/
    ods select all;
    ods results;  
    /**Sets plot options**/
    ods graphics /  antialias antialiasmax=&antialiasmax scale=off width=&width height=&height;
    /**Generates the Plot**/
    options notes;
    proc sgrender data=_temp template=_waterfall;
    run;
    options nonotes;
    /**Changes Potential Registry Changes back**/
    %if %qupcase(&plottype)=EMF or (&svg=1 and %qupcase(&destination)=RTF and %qupcase(&plottype)^=TIFF and %qupcase(&plottype)^=TIF)
        or (&svg=1 and %qupcase(&destination)=EXCEL)
        or (&svg=1 and %qupcase(&destination)=POWERPOINT) %then %do;
        %if &transparent=0 and &_any_trans=0 %then %do;
            proc registry clearsasuser; /* Deletes the SASUSER directory */
            proc registry import="&workdir./_newsurv_preexisting.sasxreg";/* Imports starting SASUSER Keys */
            run;
        %end;
    %end;
    /**Creates the TIFF file from the PNG file created earlier**/
    %else %if %qupcase(&plottype)=TIFF or %qupcase(&plottype)=TIF %then %do;
        %local _fncheck _fncheck2;
        options nonotes;
        %if %sysevalf(%superq(gpath)=,boolean) %then %do;
            filename nsurvpng "./&plotname..png"; 
            filename nsurvtif "./&plotname..tiff";
            data _null_;
                x=fexist('nsurvpng');
                x2=fdelete('nsurvtif');
                call symput('_fncheck',strip(put(x,12.)));
                call symput('_fncheck2',strip(put(x2,12.)));
            run;
            %if %sysevalf(%superq(_fncheck)^=1,boolean) %then %do;
                filename nsurvpng "./&plotname.1.png"; 
            %end;
        %end;
        %else %do;
            filename nsurvpng "%sysfunc(tranwrd(&gpath./&plotname..png,//,/))"; 
            filename nsurvtif "%sysfunc(tranwrd(&gpath./&plotname..tiff,//,/))"; 
            data _null_;
                x=fexist('nsurvpng');
                x2=fdelete('nsurvtif');
                call symput('_fncheck',strip(put(x,12.)));
                call symput('_fncheck2',strip(put(x2,12.)));
            run;
            %if %sysevalf(%superq(_fncheck)^=1,boolean) %then %do;
                filename nsurvpng "%sysfunc(tranwrd(&gpath./&plotname.1.png,//,/))"; 
            %end;
        %end;
        options notes;
        goptions device=&tiffdevice gsfname=nsurvtif 
            xmax=&width ymax=&height 
            xpixels=%sysevalf(%sysfunc(compress(&width,abcdefghijklmnopqrstuvwxyz,i))*&dpi) 
            ypixels=%sysevalf(%sysfunc(compress(&height,abcdefghijklmnopqrstuvwxyz,i))*&dpi)
            imagestyle=fit iback=nsurvpng
            %if &border=1 %then %do; border %end;
            %else %if &border=0 %then %do; noborder %end;;
        proc gslide;
        run;
        quit; 
        data _null_;
            x=fdelete('nsurvpng');
        run;
        filename nsurvpng clear;
        filename nsurvtif clear;
    %end;
    options nonotes; 
    %do i = 1 %to %sysfunc(countw(%superq(_destinations),|));
        ods %scan(%superq(_destinations),&i,|) style=%scan(%superq(_styles),&i,|);
    %end;
    /**Closes the ODS file**/
    %if %sysevalf(%superq(outdoc)=,boolean)=0 %then %do;
        ods &destination close;
    %end;
    /*Copy PLOT dataset*/
    %if %sysevalf(%superq(out)^=,boolean) %then %do;
        data &out;
            set _temp;
        run;
    %end;
    /**Reset Graphics Options**/
    ods graphics / reset=all;
    %errhandl2:
    /**If errors occurred then throw message and end macro**/
    %if &nerror_run > 0 %then %do;
        %put ERROR: &nerror_run run-time errors listed;
        %put ERROR: Macro WATERFALL will cease;   
    %end;
    
    %errhandl:
    %if &_listing=1 %then %do;
        ods Listing;
    %end;
    %else %do;
        ods listing close;
    %end;
    /*Clean up temporary datasets*/
    proc datasets nolist nodetails;
        delete _temp _tempp;
    quit;
    /**Reload previous Options**/ 
    ods path &_odspath;
    options mergenoby=&_mergenoby &_notes &_qlm linesize=&_linesize;
    goptions device=&_device gsfname=&_gsfname &_gborder
        xmax=&_xmax ymax=&_ymax xpixels=&_xpixels ypixels=&_ypixels imagestyle=&_imagestyle iback=&_iback;
    %put WATERFALL has finished processing, runtime: %sysfunc(putn(%sysevalf(%sysfunc(TIME())-&_starttime.),mmss.)); 
%mend;


