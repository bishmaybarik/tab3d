{smcl}
{* *! version 1.0.0  09sep2025}{...}
{viewerdialog tab3d "dialog tab3d"}{...}
{vieweralsosee "[R] tabulate twoway" "mansection R tabulatetwoway"}{...}
{viewerjumpto "Syntax" "tab3d##syntax"}{...}
{viewerjumpto "Description" "tab3d##description"}{...}
{viewerjumpto "Options" "tab3d##options"}{...}
{viewerjumpto "Examples" "tab3d##examples"}{...}
{viewerjumpto "Stored results" "tab3d##results"}{...}
{title:Title}

{phang}
{bf:tab3d} {hline 2} Three-dimensional tabulation


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmdab:tab3d}
{it:varname1} {it:varname2} {it:varname3}
{ifin}
[{cmd:,} {it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt miss:ing}}include missing values in tabulation{p_end}
{synopt:{opt nofreq:uency}}suppress display of frequencies{p_end}
{synopt:{opt noper:cent}}suppress display of percentages{p_end}

{syntab:Cell percentages}
{synopt:{opt cellp:ercent}}display cell percentages{p_end}
{synopt:{opt rowp:ercent}}display row percentages{p_end}
{synopt:{opt colp:ercent}}display column percentages{p_end}

{syntab:Statistics}
{synopt:{opt chi2}}report Pearson's chi-squared test{p_end}
{synopt:{opt exact}}report Fisher's exact test{p_end}
{synopt:{opt gamma}}report Goodman and Kruskal's gamma{p_end}
{synopt:{opt taub}}report Kendall's tau-b{p_end}
{synopt:{opt v}}report Cramér's V{p_end}

{syntab:Advanced}
{synopt:{opt format(format)}}display format for frequencies; default is {cmd:%9.0g}{p_end}
{synopt:{opt matcell(matname)}}save frequencies in {it:matname}{p_end}
{synopt:{opt matrow(matname)}}save row marginals in {it:matname}{p_end}
{synopt:{opt matcol(matname)}}save column marginals in {it:matname}{p_end}
{synopt:{opt matfreq(matname)}}save full frequency matrix in {it:matname}{p_end}
{synopt:{opt sav:ing(filename)}}save table to file{p_end}
{synopt:{opt replace}}overwrite existing file{p_end}
{synoptline}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
{cmd:tab3d} displays three-dimensional tabulation tables. It extends Stata's standard 
{cmd:tabulate} command to handle three categorical variables simultaneously, creating 
layered displays where each layer represents one level of the third variable. The 
command works with both numeric and string variables.

{pstd}
The command produces frequency tables organized as layers, where each layer shows 
a two-way cross-tabulation of the first two variables for a specific value of the 
third variable. This is useful for examining relationships between three categorical 
variables of any type (numeric, string, or mixed).


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt missing} includes missing values of all three variables in the tabulation. 
By default, observations with missing values are excluded.

{phang}
{opt nofrequency} suppresses the display of frequencies. Only percentages are shown 
if percentage options are specified.

{phang}
{opt nopercent} suppresses the display of percentages.

{dlgtab:Cell percentages}

{phang}
{opt cellpercent} displays each cell's percentage of the total number of observations.

{phang}
{opt rowpercent} displays each cell's percentage of its row total.

{phang}
{opt colpercent} displays each cell's percentage of its column total.

{dlgtab:Statistics}

{phang}
{opt chi2} reports Pearson's chi-squared test of independence for each layer.

{phang}
{opt exact} reports Fisher's exact test for each 2x2 table within each layer.

{phang}
{opt gamma} reports Goodman and Kruskal's gamma for ordinal variables.

{phang}
{opt taub} reports Kendall's tau-b correlation coefficient.

{phang}
{opt v} reports Cramér's V measure of association.

{dlgtab:Advanced}

{phang}
{opt format(format)} specifies the display format for frequencies. The default 
is {cmd:%9.0g}.

{phang}
{opt matcell(matname)} saves the frequencies in matrix {it:matname}.

{phang}
{opt matrow(matname)} saves the row marginal frequencies in matrix {it:matname}.

{phang}
{opt matcol(matname)} saves the column marginal frequencies in matrix {it:matname}.

{phang}
{opt matfreq(matname)} saves the complete frequency matrix including all dimensions 
in matrix {it:matname}.

{phang}
{opt saving(filename)} saves the tabulation results to a file.

{phang}
{opt replace} permits overwriting an existing file when used with {opt saving()}.


{marker examples}{...}
{title:Examples}

{pstd}Setup with numeric variables{p_end}
{phang2}{cmd:. sysuse auto}{p_end}
{phang2}{cmd:. generate price_cat = 1 if price < 5000}{p_end}
{phang2}{cmd:. replace price_cat = 2 if price >= 5000 & price < 10000}{p_end}
{phang2}{cmd:. replace price_cat = 3 if price >= 10000 & !missing(price)}{p_end}

{pstd}Basic three-way tabulation with numeric variables{p_end}
{phang2}{cmd:. tab3d foreign rep78 price_cat}{p_end}

{pstd}Setup with string variables{p_end}
{phang2}{cmd:. sysuse nlsw88, clear}{p_end}
{phang2}{cmd:. generate age_group = "young" if age < 30}{p_end}
{phang2}{cmd:. replace age_group = "middle" if age >= 30 & age < 50}{p_end}
{phang2}{cmd:. replace age_group = "older" if age >= 50 & !missing(age)}{p_end}

{pstd}Three-way tabulation with string variables{p_end}
{phang2}{cmd:. tab3d race married age_group}{p_end}

{pstd}Mixed variable types (numeric and string){p_end}
{phang2}{cmd:. tab3d collgrad race age_group}{p_end}

{pstd}Include missing values{p_end}
{phang2}{cmd:. tab3d race married age_group, missing}{p_end}

{pstd}Display percentages only{p_end}
{phang2}{cmd:. tab3d race married age_group, nofreq cellpercent}{p_end}

{pstd}Save frequencies to matrix{p_end}
{phang2}{cmd:. tab3d race married age_group, matfreq(freq_matrix)}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:tab3d} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}number of observations{p_end}
{synopt:{cmd:r(r)}}number of rows (levels of first variable){p_end}
{synopt:{cmd:r(c)}}number of columns (levels of second variable){p_end}
{synopt:{cmd:r(layers)}}number of layers (levels of third variable){p_end}

{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:r(cmd)}}{cmd:tab3d}{p_end}
{synopt:{cmd:r(varlist)}}names of the three variables{p_end}

{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:r(freq)}}frequency matrix (if {cmd:matfreq()} specified){p_end}
{p2colreset}{...}


{title:Author}

{pstd}
{bf:Bishmay Barik}{break}
Email: {browse "mailto:bishmaykbarik@gmail.com":bishmaykbarik@gmail.com}{break}

{pstd}
Tab3d was developed by Bishmay Barik for extending Stata's tabulation capabilities to three dimensions.


{title:Also see}

{psee}
Manual:  {bf:[R] tabulate oneway}, {bf:[R] tabulate twoway}

{psee}
Online:  {manhelp tabulate R:tabulate oneway}, {manhelp tabulate_twoway R:tabulate twoway}
{p_end}