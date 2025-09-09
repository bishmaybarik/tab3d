# tab3d - Three-Dimensional Tabulation for Stata

**Author:** Bishmay Barik (bishmaykbarik@gmail.com)

## Overview

Tab3d extends Stata's standard tabulation functionality to handle three categorical variables simultaneously (both numeric and string). It creates layered frequency tables where each layer represents one level of the third variable.

## Installation

### From GitHub
```stata
net install tab3d, from("https://raw.githubusercontent.com/bishmaybarik/tab3d/main/")
```

### From SSC (once available)
```stata
ssc install tab3d
```

## Quick Start

```stata
sysuse auto
tab3d foreign rep78 price_cat
```

## Features

- Three-dimensional cross-tabulation
- Support for both numeric and string variables
- Layered display for three variables  
- Frequency and percentage tables
- Summary statistics
- Missing value handling
- Matrix output options
- Subset analysis with if/in conditions

## Syntax

```stata
tab3d var1 var2 var3 [if] [in] [, options]
```

## Examples

```stata
// Basic usage with numeric variables
sysuse auto
tab3d foreign rep78 price_cat

// String variables
sysuse nlsw88, clear
generate age_group = "young" if age < 30
replace age_group = "middle" if age >= 30 & age < 50
replace age_group = "older" if age >= 50
tab3d race married age_group

// Include missing values
tab3d race married age_group, missing

// Save frequency matrix
tab3d race married age_group, matfreq(freq_matrix)
```

## Requirements

- Stata version 14.0 or higher

## Files

- `tab3d.ado` - Main program file
- `tab3d.sthlp` - Help documentation
- `tab3d_test.do` - Test file with examples

## Support

For questions or issues, please contact: bishmaykbarik@gmail.com

## License

This project is open source.