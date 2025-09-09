*! tab3d version 1.1.0  09sep2025
*! Three-dimensional tabulation command for Stata
*! Author: Bishmay Barik (bishmaykbarik@gmail.com)
*! 
*! Extends Stata's tabulation to handle three categorical variables (string and numeric)

program define tab3d, rclass
    version 14.0
    
    syntax varlist(min=3 max=3) [if] [in] [, ///
        MISSing ///
        NOFREQuency ///
        NOPERcent ///
        ROWPercent ///
        COLPercent ///
        CELLPercent ///
        CHI2 ///
        EXact ///
        GAMma ///
        TAUb ///
        V ///
        Format(string) ///
        MATcell(name) ///
        MATRow(name) ///
        MATCol(name) ///
        MATFreq(name) ///
        SAVing(string) ///
        REPlace ]
    
    marksample touse
    
    tokenize `varlist'
    local var1 `1'
    local var2 `2' 
    local var3 `3'
    
    // Check that variables exist and are appropriate for tabulation
    foreach var of varlist `varlist' {
        capture confirm variable `var'
        if _rc {
            di as error "Variable `var' not found"
            exit 111
        }
    }
    
    // Set default format if not specified
    if "`format'" == "" local format "%9.0g"
    
    // Preserve data for clean restoration
    preserve
    
    // Keep only observations that meet the if/in conditions
    qui keep if `touse'
    
    // Handle missing values
    if "`missing'" == "" {
        qui drop if missing(`var1') | missing(`var2') | missing(`var3')
    }
    
    // Check if we have any observations left
    qui count
    if r(N) == 0 {
        di as error "no observations"
        exit 2000
    }
    
    // Check variable types
    foreach var of local varlist {
        local vartype_`var' : type `var'
        if substr("`vartype_`var''", 1, 3) == "str" {
            local is_string_`var' = 1
        }
        else {
            local is_string_`var' = 0
        }
    }
    
    // Get unique values for each variable (levelsof handles both string and numeric)
    if "`missing'" == "" {
        qui levelsof `var1', local(levels1) clean
        qui levelsof `var2', local(levels2) clean  
        qui levelsof `var3', local(levels3) clean
    }
    else {
        qui levelsof `var1', local(levels1) missing
        qui levelsof `var2', local(levels2) missing  
        qui levelsof `var3', local(levels3) missing
    }
    
    local n1: word count `levels1'
    local n2: word count `levels2'
    local n3: word count `levels3'
    
    // Create matrices to store results
    tempname freq_matrix row_totals col_totals layer_totals grand_total
    matrix `freq_matrix' = J(`n1'*`n2'*`n3', 5, 0)  // Extra column for storage
    matrix `row_totals' = J(`n1', 1, 0)
    matrix `col_totals' = J(`n2', 1, 0) 
    matrix `layer_totals' = J(`n3', 1, 0)
    
    // Calculate frequencies with proper string/numeric handling
    local row = 1
    foreach level3 of local levels3 {
        foreach level1 of local levels1 {
            foreach level2 of local levels2 {
                // Build condition string based on variable types
                local condition ""
                
                // Handle var1
                if `is_string_`var1'' {
                    local condition "`condition' `var1' == `"`level1'"'"
                }
                else {
                    local condition "`condition' `var1' == `level1'"
                }
                
                // Handle var2
                if `is_string_`var2'' {
                    local condition "`condition' & `var2' == `"`level2'"'"
                }
                else {
                    local condition "`condition' & `var2' == `level2'"
                }
                
                // Handle var3
                if `is_string_`var3'' {
                    local condition "`condition' & `var3' == `"`level3'"'"
                }
                else {
                    local condition "`condition' & `var3' == `level3'"
                }
                
                qui count if `condition'
                local freq = r(N)
                matrix `freq_matrix'[`row', 4] = `freq'
                local row = `row' + 1
            }
        }
    }
    
    // Calculate totals
    qui count
    scalar `grand_total' = r(N)
    
    // Display results with enhanced formatting
    di ""
    di as text "{hline 80}"
    di as text "{bf:THREE-DIMENSIONAL TABULATION}"
    di as text "Variables: " as result "{bf:`var1'}" as text " × " as result "{bf:`var2'}" as text " × " as result "{bf:`var3'}"
    di as text "Sample size: " as result "{bf:`grand_total'}" as text " observations"
    di as text "{hline 80}"
    di ""
    
    // Display the 3D table layer by layer with improved formatting
    foreach level3 of local levels3 {
        di as text "{bf:║ Layer `level3': `var3' = `level3' ║}"
        di as text "{hline 50}"
        
        // Create enhanced header for this layer
        di as text "       `var1' {c |}", _c
        foreach level2 of local levels2 {
            di as text %10s "`level2'", _c
        }
        di as text %12s "{bf:Total}"
        
        // Enhanced separator line
        di as text "{hline 11}{c +}", _c
        foreach level2 of local levels2 {
            di as text "{hline 10}", _c
        }
        di as text "{hline 12}"
        
        // Display rows for this layer with enhanced formatting
        foreach level1 of local levels1 {
            di as text %10s "`level1'" " {c |}", _c
            local row_total = 0
            
            foreach level2 of local levels2 {
                // Build condition for display
                local condition ""
                if `is_string_`var1'' {
                    local condition "`condition' `var1' == `"`level1'"'"
                }
                else {
                    local condition "`condition' `var1' == `level1'"
                }
                if `is_string_`var2'' {
                    local condition "`condition' & `var2' == `"`level2'"'"
                }
                else {
                    local condition "`condition' & `var2' == `level2'"
                }
                if `is_string_`var3'' {
                    local condition "`condition' & `var3' == `"`level3'"'"
                }
                else {
                    local condition "`condition' & `var3' == `level3'"
                }
                
                qui count if `condition'
                local freq = r(N)
                local row_total = `row_total' + `freq'
                if `freq' > 0 {
                    di as result %10.0f `freq', _c
                }
                else {
                    di as text %10s ".", _c
                }
            }
            di as result %12.0f `row_total'
        }
        
        // Enhanced separator for totals
        di as text "{hline 11}{c +}", _c
        foreach level2 of local levels2 {
            di as text "{hline 10}", _c
        }
        di as text "{hline 12}"
        
        // Column totals with enhanced formatting
        di as text %10s "{bf:Total}" " {c |}", _c
        local layer_total = 0
        foreach level2 of local levels2 {
            // Build condition for column totals
            local condition ""
            if `is_string_`var2'' {
                local condition "`condition' `var2' == `"`level2'"'"
            }
            else {
                local condition "`condition' `var2' == `level2'"
            }
            if `is_string_`var3'' {
                local condition "`condition' & `var3' == `"`level3'"'"
            }
            else {
                local condition "`condition' & `var3' == `level3'"
            }
            
            qui count if `condition'
            local col_total = r(N)
            local layer_total = `layer_total' + `col_total'
            di as result %10.0f `col_total', _c
        }
        
        // Layer total
        if `is_string_`var3'' {
            qui count if `var3' == `"`level3'"'
        }
        else {
            qui count if `var3' == `level3'
        }
        di as result %12.0f r(N)
        di ""
    }
    
    // Enhanced grand totals display
    di as text "{hline 80}"
    di as text "{bf:SUMMARY STATISTICS}"
    di as text "{hline 30}"
    di as text "Grand Total: " as result "{bf:`grand_total'}" as text " observations"
    di as text "Dimensions:  " as result "{bf:`n1'}" as text " × " as result "{bf:`n2'}" as text " × " as result "{bf:`n3'}" as text " = " as result "{bf:" `n1'*`n2'*`n3' "}" as text " cells"
    local filled_cells = 0
    forvalues i = 1/`=rowsof(`freq_matrix')' {
        if `freq_matrix'[`i',4] > 0 {
            local filled_cells = `filled_cells' + 1
        }
    }
    local pct_filled = (`filled_cells' / (`n1'*`n2'*`n3')) * 100
    di as text "Non-zero cells: " as result "{bf:`filled_cells'}" as text " (" as result "{bf:" %4.1f `pct_filled' "%}" as text " of total cells)"
    
    // Calculate and display percentages if requested
    if "`nopercent'" == "" {
        di ""
        di as text "{hline 80}"
        di as text "{bf:PERCENTAGE BREAKDOWN (% of Grand Total)}"
        di as text "{hline 80}"
        
        foreach level3 of local levels3 {
            di ""
            di as text "{bf:║ Layer `level3': `var3' = `level3' ║}"
            di as text "{hline 50}"
            
            // Enhanced percentage header
            di as text "       `var1' {c |}", _c
            foreach level2 of local levels2 {
                di as text %10s "`level2'", _c
            }
            di as text %12s "{bf:Total}"
            
            // Separator line
            di as text "{hline 11}{c +}", _c
            foreach level2 of local levels2 {
                di as text "{hline 10}", _c
            }
            di as text "{hline 12}"
            
            foreach level1 of local levels1 {
                di as text %10s "`level1'" " {c |}", _c
                
                foreach level2 of local levels2 {
                    // Build condition for percentage calculation
                    local condition ""
                    if `is_string_`var1'' {
                        local condition "`condition' `var1' == `"`level1'"'"
                    }
                    else {
                        local condition "`condition' `var1' == `level1'"
                    }
                    if `is_string_`var2'' {
                        local condition "`condition' & `var2' == `"`level2'"'"
                    }
                    else {
                        local condition "`condition' & `var2' == `level2'"
                    }
                    if `is_string_`var3'' {
                        local condition "`condition' & `var3' == `"`level3'"'"
                    }
                    else {
                        local condition "`condition' & `var3' == `level3'"
                    }
                    
                    qui count if `condition'
                    local freq = r(N)
                    local pct = (`freq' / `grand_total') * 100
                    if `pct' > 0 {
                        di as result %9.2f `pct' "%", _c
                    }
                    else {
                        di as text %10s ".", _c
                    }
                }
                
                // Row percentage totals
                local condition ""
                if `is_string_`var1'' {
                    local condition "`condition' `var1' == `"`level1'"'"
                }
                else {
                    local condition "`condition' `var1' == `level1'"
                }
                if `is_string_`var3'' {
                    local condition "`condition' & `var3' == `"`level3'"'"
                }
                else {
                    local condition "`condition' & `var3' == `level3'"
                }
                qui count if `condition'
                local row_pct = (r(N) / `grand_total') * 100
                di as result %11.2f `row_pct' "%"
            }
            
            // Percentage totals separator
            di as text "{hline 11}{c +}", _c
            foreach level2 of local levels2 {
                di as text "{hline 10}", _c
            }
            di as text "{hline 12}"
            
            // Column percentage totals
            di as text %10s "{bf:Total}" " {c |}", _c
            foreach level2 of local levels2 {
                // Build condition for column percentages
                local condition ""
                if `is_string_`var2'' {
                    local condition "`condition' `var2' == `"`level2'"'"
                }
                else {
                    local condition "`condition' `var2' == `level2'"
                }
                if `is_string_`var3'' {
                    local condition "`condition' & `var3' == `"`level3'"'"
                }
                else {
                    local condition "`condition' & `var3' == `level3'"
                }
                
                qui count if `condition'
                local col_pct = (r(N) / `grand_total') * 100
                di as result %9.2f `col_pct' "%", _c
            }
            
            // Layer percentage total
            if `is_string_`var3'' {
                qui count if `var3' == `"`level3'"'
            }
            else {
                qui count if `var3' == `level3'
            }
            local layer_pct = (r(N) / `grand_total') * 100
            di as result %11.2f `layer_pct' "%"
        }
    }
    
    // Return results
    return scalar N = `grand_total'
    return scalar r = `n1'
    return scalar c = `n2' 
    return scalar layers = `n3'
    return local cmd "tab3d"
    return local varlist "`varlist'"
    
    // Save matrices if requested
    if "`matfreq'" != "" {
        matrix `matfreq' = `freq_matrix'
        return matrix freq = `freq_matrix'
    }
    
    restore
    
end