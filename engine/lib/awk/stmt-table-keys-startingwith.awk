# INVAR: starting_with
# INVAR: ending_with
BEGIN {
  ending_with   = tolower(ending_with)
  starting_with = tolower(starting_with)
}
{ opt_key = $1; }
opt_key ~ "^" starting_with ending_with "$" { print opt_key }

