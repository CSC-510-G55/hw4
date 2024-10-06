#!/bin/bash

# Define the FPAT variable
# Note: Field pattern (FPAT) is used to help gawk in correctly parsing the CSV file, as the fields might contain quoted strings with commas and nested quotes.
FPAT='([^,]+)|(\"([^\"]|\"\")+\")'

# Define the special sequence for empty csv values
# Note: This sequence is used to replace empty csv values for easier processing
EMPTY_SEQ='%$%$%'

# Note: The above two variables are defined to make the below pipeline more readable

# Pre-processing

# Read the CSV file without the header (1st line)
sed -e '1d' titanic.csv | \
# Strip carriage return characters
sed -e 's/\r$//' | \
# Replace empty csv values with a special sequence for easier processing
sed -e "s/,,/,$EMPTY_SEQ,/g" | \



# [4a] Filter the rows with 2nd class and embarking at Southampton
gawk -v FPAT="$FPAT" 'BEGIN { OFS = "," } $3 == 2 && $12 == "S" { print $0 }' | \

# [4b] Replace the Sex column with M/F
gawk -v FPAT="$FPAT" 'BEGIN { OFS = "," } { if ($5 == "male") $5 = "M"; else if ($5 == "female") $5 = "F"; print $0 }' | \
# Print the output so far, while undoing and redoing the special sequence replacement
sed -e "s/,$EMPTY_SEQ,/,,/g" | tee >(cat >&2) | sed -e "s/,,/,$EMPTY_SEQ,/g" | \

# [4c] Find average age of passengers for whom age is available
gawk -v FPAT="$FPAT" 'BEGIN { OFS = "," } $6 ~ /^[0-9\.]+$/ { sum += $6; count++ } END { if (count > 0) print "\nAverage: " sum / count; else print "\nNo valid entries" }'