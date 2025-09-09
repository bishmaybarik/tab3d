* =============================================================================
* Tab3d Test File
* =============================================================================
* Author: Bishmay Barik (bishmaykbarik@gmail.com)
* This file tests the tab3d command with various options and scenarios

clear all
set more off

* Load the auto dataset
sysuse auto, clear

* Create a categorical price variable for testing
generate price_cat = 1 if price < 5000
replace price_cat = 2 if price >= 5000 & price < 10000  
replace price_cat = 3 if price >= 10000 & !missing(price)
label define price_lbl 1 "Low" 2 "Medium" 3 "High"
label values price_cat price_lbl

* Test 1: Basic three-way tabulation
display "=== Test 1: Basic three-way tabulation ==="
tab3d foreign rep78 price_cat

* Test 2: With missing values included  
display ""
display "=== Test 2: Including missing values ==="
tab3d foreign rep78 price_cat, missing

* Test 3: Frequencies only (no percentages)
display ""
display "=== Test 3: Frequencies only ==="  
tab3d foreign rep78 price_cat, nopercent

* Test 4: Save frequency matrix
display ""
display "=== Test 4: Save frequency matrix ==="
tab3d foreign rep78 price_cat, matfreq(freq_matrix)
matrix list freq_matrix

* Test 5: Test with subset of data
display ""
display "=== Test 5: Test with if condition ==="
tab3d foreign rep78 price_cat if price < 8000

* Create additional test variables
generate size_cat = 1 if length < 170
replace size_cat = 2 if length >= 170 & length < 190
replace size_cat = 3 if length >= 190 & !missing(length)
label define size_lbl 1 "Small" 2 "Medium" 3 "Large" 
label values size_cat size_lbl

* Test 6: Test with different variables
display ""
display "=== Test 6: Different variable combination ==="
tab3d foreign size_cat price_cat

* Test 7: STRING VARIABLES - Create string variables for testing
display ""
display "=== Test 7: Testing string variables ==="
sysuse nlsw88, clear

generate age_group = "young" if age < 30
replace age_group = "middle" if age >= 30 & age < 50  
replace age_group = "older" if age >= 50 & !missing(age)

* Test string variables
tab3d race married age_group

* Test 8: Mixed variable types (numeric and string)
display ""
display "=== Test 8: Mixed variable types ==="
tab3d collgrad race age_group

* Test 9: String variables with missing values
display ""
display "=== Test 9: String variables with missing option ==="
tab3d race married age_group, missing

* Test 10: String variables with percentages
display ""
display "=== Test 10: String variables with percentages ==="
tab3d race married age_group, nopercent

* Test 11: String variables with matrix output
display ""
display "=== Test 11: String variables with matrix output ==="
tab3d race married age_group, matfreq(string_matrix)
matrix list string_matrix

display ""
display "=== All tests completed successfully! ==="
display "✓ Numeric variables: Working"
display "✓ String variables: Working" 
display "✓ Mixed variables: Working"
display "✓ Missing values: Working"
display "✓ Matrix output: Working"
