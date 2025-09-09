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

display ""
display "=== All tests completed successfully! ==="