# INVAR: keyseq
# INVAR: opt_col
BEGIN {
  FS = "\t"
  keyseq_count = split(keyseq, keyseq_list, "\n")
  last_key     = tolower(keyseq_list[keyseq_count])
  if (!last_key)
  {
    exit 0
  }
  if (opt_col && opt_col != "keys" && opt_col != "values")
  {
    print "stmt-table-keyseq-last.awk: fatal: invalid opt_col: " opt_col | "cat 1>&2"
    exit 1
  }
}

{ stmt_key = $1; stmt_val = ""; }
NF > 1 { for (i = 2; i <= NF; i++) if (i == NF) { stmt_val = stmt_val $i } else { stmt_val = stmt_val sprintf("%s\t", $i) } }

stmt_key == last_key {
  last_val = stmt_val
}

END {
  if (!last_val) exit 0
  if (opt_col == "keys") {
    printf("%s\n", last_key)
  } else if (opt_col == "values") {
    printf("%s\n", last_val)
  } else {
    printf("%s\t%s\n", last_key, last_val)
  }
}

