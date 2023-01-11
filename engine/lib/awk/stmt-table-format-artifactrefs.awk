BEGIN {
  artifacts_count = 0
  if (!ENVIRON["ENGINE_ARTIFACTS_DIR"]) {
    print "stmt-table-format-artifacts.awk: missing environ ENGINE_ARTIFACTS_DIR" | "cat 1>&2"
    exit 1
  }
  if (!ENVIRON["LIB"]) {
    print "stmt-table-format-artifacts.awk: missing environ LIB" | "cat 1>&2"
    exit 1
  }
  path_relto = ENVIRON["LIB"] "/sh/path-relto.sh"
}

{
  raw_table_key_fields_count = split($1, raw_table_key_fields, ".")
  if (raw_table_key_fields_count > 2) {
    artifact_id  = raw_table_key_fields[2]
    artifact_opt = raw_table_key_fields[3]
  } else {
    artifact_id  = ""
    artifact_opt = ""
  }
}

artifact_id && !(artifact_id in artifact_ids_seen) {
  artifact_ids_seen[artifact_id] = 1
  artifacts_count++
  artifacts[artifacts_count] = artifact_id
}

artifact_opt == "path" {
  artifact_paths[artifact_id] = ""
  for (i = 2; i <= NF; i++) {
    if (i == NF) {
      artifact_paths[artifact_id] = artifact_paths[artifact_id] $i
    } else {
      artifact_paths[artifact_id] = artifact_paths[artifact_id] sprintf("%s ", $i)
    }
  }
}

END {
  for (i = 1; i <= artifacts_count; i++) {
    artifact_id   = artifacts[i]
    artifact_path = artifact_paths[artifact_id]
    if (artifact_path) {
      path_relto sprintf(" '%s/%s' .", ENVIRON["ENGINE_ARTIFACTS_DIR"], artifact_path) | getline artifact_path
    }
    printf("%s\t%s\n", artifact_id, artifact_path)
    }
}
