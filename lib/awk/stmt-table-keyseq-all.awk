# INVAR: keyseq
# INVAR: opt_col
# INVAR: flag_clearable
BEGIN {
  FS = "\t"
  keyseq_count = split(keyseq, keyseq_list, "\n")
  for (i = 1; i <= keyseq_count; i++) keyseq_set[tolower(keyseq_list[i])] = 1
  if (opt_col && opt_col != "keys" && opt_col != "values")
  {
    print "stmt-table-keyseq-all.awk: fatal: invalid opt_col: " opt_col | "cat 1>&2"
    exit 1
  }
  stmt_count = 0
}

{ stmt_key = $1; stmt_val = ""; }
NF > 1 { for (i = 2; i <= NF; i++) if (i == NF) { stmt_val = stmt_val $i } else { stmt_val = stmt_val sprintf("%s\t", $i) } }

stmt_key in keyseq_set {
  if (stmt_val || !flag_clearable)
  {
    stmt_count++
    if (opt_col == "keys") {
      stmt_list[stmt_count] = stmt_key
    } else if (opt_col == "values") {
      stmt_list[stmt_count] = stmt_val
    } else {
      stmt_list[stmt_count] = sprintf("%s\t%s", stmt_key, stmt_val)
    }
  }
  else
  {
    stmt_count = 0
    for (i in stmt_list) delete stmt_list[i]
  }
}

END {
  for (i = 1; i <= stmt_count; i++) print stmt_list[i]
}
