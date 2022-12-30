BEGIN { processing = 0 }

# adoc title
/^# = [^[:space:]]/ { processing = 1 }

# non-comment line
/^[^#]/             { processing = 0 }

processing          { print substr($0, 3) }
