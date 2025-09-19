/* Quick test to verify string handling fix */
clear all
use mock_dataset.dta, clear

/* Simple string test */
display "=== QUICK STRING TEST ==="
display "Testing: region (string) × department (string) × education (string)"
tab3d region department education

display ""
display "If you see a proper 3D table above (not 'no observations'), the fix worked!"