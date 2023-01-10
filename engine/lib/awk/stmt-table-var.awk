# INVAR: var_key
BEGIN { FS = "\t"; var_key = tolower(var_key); }
{ opt_key = $1 }
opt_key == var_key {
  var_val = ""
  for (i = 2; i <= NF; i++) {
    if (i == NF) {
      var_val = var_val $i
    } else {
      var_val = var_val sprintf("%s\t", $i)
    }
  }
}
END { if (var_val) print var_val }
