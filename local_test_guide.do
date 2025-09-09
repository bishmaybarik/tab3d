* =============================================================================
* Local Testing Guide for tab3d Package
* Author: Bishmay Barik (bishmaykbarik@gmail.com)
* =============================================================================

* Step 1: Install the package locally
* Copy tab3d.ado and tab3d.sthlp to your personal ado directory
adopath

* Find your PERSONAL ado directory (usually ~/ado/personal/)
* Copy files there, or alternatively:

* Step 2: Test from current directory (temporary)
pwd  // Make sure you're in the right directory

* Step 3: Run comprehensive tests
do tab3d_test.do

* Step 4: Test help functionality
help tab3d

* Step 5: Test edge cases
clear
sysuse auto

* Test with missing values
generate test_var = .
replace test_var = 1 in 1/20
replace test_var = 2 in 21/40
tab3d foreign rep78 test_var, missing

* Test with single categories
tab3d foreign foreign foreign  // Should handle gracefully

* Step 6: Test different data types
sysuse nlsw88, clear
tab3d race married collgrad

* If all tests pass, you're ready for distribution!