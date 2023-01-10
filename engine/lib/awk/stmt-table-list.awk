# INVAR: list_keys_str
BEGIN {
  FS                = "\t"
  list_keys_str     = tolower(list_keys_str)
  list_keys_count   = split(list_keys_str, list_keys, " ")
  list_values_count = 0
  for (i = 1; i <= list_keys_count; i++) list_keys_set[list_keys[i]] = 1
}
{ opt_key = $1 }
opt_key in list_keys_set {
  if ($2) {
    list_values_count++
    for (i = 2; i <= NF; i++) {
      if (i == NF) {
        list_values[list_values_count] = list_values[list_values_count] $i
      } else {
        list_values[list_values_count] = list_values[list_values_count] sprintf("%s\t", $i)
      }
    }
  } else {
    for (i in list_values) {
      delete list_values[i]
    }
    list_values_count = 0
  }
}
END { for (i=1; i <= list_values_count; i++) print list_values[i]  }

