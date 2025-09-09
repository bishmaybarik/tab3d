TAB3D - Three-Dimensional Tabulation for Stata
===============================================

AUTHOR: Bishmay Barik (bishmaykbarik@gmail.com)

OVERVIEW
--------
Tab3d is a Stata package that extends standard tabulation functionality to handle 
three categorical variables simultaneously. It creates layered frequency tables 
where each layer represents one level of the third variable.

INSTALLATION
------------
To install tab3d from SSC (once uploaded):
    ssc install tab3d

For manual installation:
1. Copy tab3d.ado and tab3d.sthlp to your Stata personal ado directory
2. Find your ado directory with: sysdir
3. Place files in the "PERSONAL" directory shown
4. Alternatively, place files in your current working directory

QUICK START
-----------
Basic syntax:
    tab3d var1 var2 var3

Example:
    sysuse auto
    tab3d foreign rep78 price_cat

FEATURES
--------
- Three-dimensional cross-tabulation
- Layered display for three variables
- Frequency and percentage tables
- Summary statistics
- Missing value handling
- Matrix output options
- Subset analysis with if/in conditions

FILES INCLUDED
--------------
tab3d.ado      - Main program file
tab3d.sthlp    - Help documentation  
tab3d.pkg      - Package description
tab3d_test.do  - Test file with examples
README.txt     - This file

TESTING
-------
Run the test file to verify installation:
    do tab3d_test.do

REQUIREMENTS
------------
- Stata version 14.0 or higher
- Standard Stata installation (no additional packages required)

SUPPORT
-------
For questions or issues, please contact: bishmaykbarik@gmail.com
For updates and documentation, visit: https://github.com/bishmaykbarik

VERSION HISTORY
---------------
Version 1.0.0 (September 2025)
- Initial release
- Three-way tabulation functionality
- Comprehensive help file and documentation
- Complete test suite included

AUTHOR
------
Bishmay Barik
Email: bishmaykbarik@gmail.com
GitHub: https://github.com/bishmaykbarik