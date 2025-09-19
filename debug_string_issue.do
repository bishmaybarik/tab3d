/* Debug script to identify string handling issues */
clear all
use mock_dataset.dta, clear

/* Test 1: Check what levelsof returns for string variables */
display "=== DEBUGGING STRING LEVELS ==="
levelsof region, local(levels1)
display "region levels (default): `levels1'"

levelsof region, local(levels1_clean) clean
display "region levels (clean): `levels1_clean'"

levelsof department, local(levels2)
display "department levels (default): `levels2'"

levelsof education, local(levels3)
display "education levels (default): `levels3'"

/* Test 2: Check variable types */
display ""
display "=== VARIABLE TYPES ==="
local vartype_region : type region
display "region type: `vartype_region'"
if substr("`vartype_region'", 1, 3) == "str" {
    display "region is STRING"
}
else {
    display "region is NUMERIC"
}

/* Test 3: Manual string comparison test */
display ""
display "=== MANUAL STRING COMPARISON TEST ==="
local test_region "North America"
count if region == "`test_region'"
display "Count for region == 'North America': " r(N)

count if region == "North America"
display "Count for region == \"North America\": " r(N)

/* Test 4: Show actual data */
display ""
display "=== ACTUAL DATA SAMPLE ==="
list region department education in 1/10

/* Test 5: Test different quoting methods */
display ""
display "=== QUOTING METHOD TESTS ==="
foreach val in "North America" "Europe" "Asia Pacific" {
    count if region == "`val'"
    display "Method 1 - region == \"`val'\": " r(N)

    count if region == `"`val'"'
    display "Method 2 - region == \`\"\`val'\"\': " r(N)
}

/* Test 6: Test the problematic condition building */
display ""
display "=== CONDITION BUILDING TEST ==="
local level1 "North America"
local level2 "Sales"
local level3 "High School"

local condition ""
local condition "`condition' region == `"`level1'"'"
local condition "`condition' & department == `"`level2'"'"
local condition "`condition' & education == `"`level3'"'"

display "Built condition: `condition'"
count if `condition'
display "Count result: " r(N)