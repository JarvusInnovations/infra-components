# INVAR: key_patterns
# INVAR: key_trailer
# INVAR: val_items
BEGIN {
  FS = "\t"
  key_patterns_count = split(key_patterns, key_patterns_list, "\n")
  val_items_count    = split(val_items, val_items_list, "\n")
  for (i = 1; i <= key_patterns_count; i++) key_patterns_set[tolower(key_patterns_list[i])] = 1
  for (i = 1; i <= val_items_count; i++) val_items_set[val_items_list[i]] = 1
  key_trailer = tolower(key_trailer)
  keseq_count = 0
}

{ stmt_key = $1; stmt_val = ""; stmt_is_selected = 1; }
NF > 1 { for (i = 2; i <= NF; i++) if (i == NF) { stmt_val = stmt_val $i } else { stmt_val = stmt_val sprintf("%s\t", $i) } }

key_patterns_count > 0 {
  key_matches_pattern = 0
  for (key_pattern in key_patterns_set) {
    if (stmt_key ~ "^" key_pattern key_trailer "$") {
      key_matches_pattern = 1
    }
  }
  if (!key_matches_pattern) stmt_is_selected = 0
}

val_items_count > 0 {
  val_equalto_item = 0
  for (val_item in val_items_set) {
    if (val_item == stmt_val) {
      val_equalto_item = 1
    }
  }
  if (!val_equalto_item) stmt_is_selected = 0
}

stmt_is_selected { print stmt_key }
