#!/bin/sh

usage()
{
  printf 'Usage: %s [OPTION...] OPTS_FILE...                                                                            \n' "$SCRIPT" >&2
  printf '                                                                                                              \n'           >&2
  printf 'Options:                                                                                                      \n'           >&2
  printf '  -h              print this help message                                                                     \n'           >&2
  printf '  -t TABLE        table to select statements from                                                             \n'           >&2
  printf "                  TABLE is 'pipelineOpts', 'artifactRefs' or 'artifactOpts'; defaults to 'pipelineOpts'      \\n"           >&2
  printf '  -c COLUMN       column to return from selected statements                                                   \n'           >&2
  printf "                  COLUMN is 'values' or 'keys'                                                               \\n"           >&2
  printf '  -r RET_TYPE     return type for selection                                                                   \n'           >&2
  printf "                  RET_TYPE is 'variable' or 'list'; defaults to 'variable'                                   \\n"           >&2
  printf "  -p PATH_FMT     format of returned path values; ignored unless RET_TYPE is 'variable'                      \\n"           >&2
  printf "                  PATH_FMT is 'abs' or 'rel'; defaults to 'rel'                                              \\n"           >&2
  printf "  -k OPT_NAME     select statements with keys matching OPT_NAME                                              \\n"           >&2
  printf "  -v OPT_VALUE    select statements with values equal to OPT_VALUE                                           \\n"           >&2
  printf "  -a ARTIFACT_ID  select statements assigned to artifact ARTIFACT_ID; ignored unless TABLE is 'artifactOpts' \\n"           >&2
  printf '                                                                                                              \n'           >&2
  printf 'OPTS_FILE is a path to an options file                                                                        \n'           >&2
  printf '                                                                                                              \n'           >&2
}

input_error()
{
  if [ "$input_errors" ]; then
    input_errors="$input_errors$(printf '\n%s\n' "$1")"
  else
    input_errors="$(printf '%s\n' "$1")"
  fi
}

keyseq_all_stmts()
{
  _awk_prog=$LIB/awk/stmt-table-keyseq-all.awk
  stmt_table_print | awk                                                  \
    -v "keyseq=$(for keyname in "$@"; do printf '%s\n' "$keyname"; done)" \
    -v "opt_col=$opt_col"                                                 \
    -v "flag_clearable=$(stmt_table_get lists_clearable)"                 \
    -f "$_awk_prog"
}

keyseq_last_stmt()
{
  _awk_prog=$LIB/awk/stmt-table-keyseq-last.awk
  stmt_table_print | awk                                                  \
    -v "keyseq=$(for keyname in "$@"; do printf '%s\n' "$keyname"; done)" \
    -v "opt_col=$opt_col"                                                 \
    -f "$_awk_prog"
}

stmt_table_select_keyseq()
{
  # patterns and items should be newline delimited
  _stmt_key_patterns=$1
  _stmt_val_items=$2
  _awk_prog=$LIB/awk/stmt-table-select-keyseq.awk
  _trailer=

  test -z "$(stmt_table_get modified)" || _trailer="($stmt_key_modifiers_pattern)?"

  stmt_table_print | awk                  \
    -v "key_patterns=$_stmt_key_patterns" \
    -v "key_trailer=$_trailer"            \
    -v "val_items=$_stmt_val_items"       \
    -f "$_awk_prog"
}

stmt_table_pipelineopts_load()
{
  _raw_table=$(
  git config --file - --get-regexp "^(engineSubject\\.$PIPELINE_NAME/$SUBJECT_NAME\\.|include\\.path)" <<EOF
[include]
$(for optsfile in "$@"; do printf 'path = %s\n' "$(realpath "$optsfile")"; done)
EOF
  git config --file - --get-regexp "^(engineEnv\\.$ENGINE_ENV\\.|include\\.path)" <<EOF
[include]
$(for optsfile in "$@"; do printf 'path = %s\n' "$(realpath "$optsfile")"; done)
EOF
)
  stmt_table_use stmt_table_pipelineopts
  stmt_table_set modified
  stmt_table_set lists_clearable
  stmt_table_load <<EOF
$(printf '%s\n' "$_raw_table" | stmt_table_format_opts)
EOF
}

stmt_table_artifactrefs_load()
{
  _awk_prog=$LIB/awk/stmt-table-format-artifactrefs.awk
  _raw_table=$(
  git config --file - --get-regexp "^(engineArtifact\\.[^.]+\\.[^[:space:]]+|include\\.path)" <<EOF
[include]
$(for optsfile in "$@"; do printf 'path = %s\n' "$(realpath "$optsfile")"; done)
EOF
)
  stmt_table_use stmt_table_artifactrefs
  stmt_table_load <<EOF
$(printf '%s\n' "$_raw_table" | awk -f "$_awk_prog")
EOF
}

stmt_table_artifactopts_load()
{
  _raw_table=$(
  git config --file - --get-regexp "^(engineArtifact\\.[^.]+\\.[^[:space:]]+|include\\.path)" <<EOF
[include]
$(for optsfile in "$@"; do printf 'path = %s\n' "$(realpath "$optsfile")"; done)
EOF
)
  stmt_table_use stmt_table_artifactopts
  stmt_table_set modified
  stmt_table_set lists_clearable
  stmt_table_load <<EOF
$(printf '%s\n' "$_raw_table" | stmt_table_format_opts)
EOF
}

stmt_table_load()
{
  test "$stmt_table_name" || return 1
  eval "$stmt_table_name=\$(cat)"
  eval "export $stmt_table_name"
}

stmt_table_use()
{
  unset stmt_table_name
  stmt_table_name=$1
  export stmt_table_name
}

stmt_table_set()
{
  _flag_name=$1
  test "$stmt_table_name" || return 1
  test "$_flag_name"      || return 1
  eval "${stmt_table_name}_flag_${_flag_name}=1"
  eval "export ${stmt_table_name}_flag_${_flag_name}"
}

stmt_table_unset()
{
  _flag_name=$1
  test "$stmt_table_name" || return 1
  test "$_flag_name"      || return 1
  eval "unset ${stmt_table_name}_flag_${_flag_name}"
}

stmt_table_get()
{
  _flag_name=$1
  test "$stmt_table_name" || return 1
  test "$_flag_name"      || return 1
  eval "printf '%s\\n' \"\$${stmt_table_name}_flag_${_flag_name}\""
}

stmt_table_print()
{
  test "$stmt_table_name" || stmt_table_name=$1
  test "$stmt_table_name" || return 1
  eval "printf '%s\\n' \"\$$stmt_table_name\""
}

stmt_table_format_opts()
{
  while read _in_key _in_val; do
    _out_key=$_in_key
    _out_val=$_in_val
    _modifier_name=$(stmt_key_modifier "$_in_key")
    _modifier_fn=xfrm_$_modifier_name

    test "$(stmt_table_get modified)" ||  _modifier_name=

    if   [ "$_in_key" = 'include.path' ]; then
      _out_key=OPTSFILE
    elif [ $(echo "$_in_key" | awk -F. '{print NF}') -eq 3 ]; then
      case $stmt_table_name in
        stmt_table_pipelineopts) _out_key=$(echo "$_in_key" | cut -d. -f3);;
        stmt_table_artifactopts) _out_key=$(echo "$_in_key" | awk -F. '{printf "%s.%s\n", $2, $3}');;
      esac
    else
      continue
    fi

    if [ "$_modifier_name" ]; then
      _out_val=$($_modifier_fn "$_out_key" "$_in_val")
    fi

    printf '%s\t%s\n' "$_out_key" "$_out_val"

  done
}

stmt_key_modifiers_pattern='(project|local|subject)path|artifact'

stmt_key_modifier()
{
  _stmt_key=$1
  if   echo "$_stmt_key" | grep -E '(project|local|subject)path$' >/dev/null; then
    echo path
  elif echo "$_stmt_key" | grep -E 'artifact$'   >/dev/null; then
    echo artifact
  fi
}

xfrm_artifact()
{
  _in_key=$1
  _in_val=$2
  _artifact_id=$_in_val
  _artifact_path=$(stmt_table_name=stmt_table_artifactrefs opt_col=values keyseq_last_stmt "$_artifact_id")
  test ! "$_artifact_path" || printf '%s\n' "$_artifact_path"
}

xfrm_path()
{
  _in_key=$1
  _in_val=$2
  _out_val=
  _xfrm_path_resolvers="project local subject"
  for _resolver in $_xfrm_path_resolvers; do
    if echo "$_in_key" | grep "${_resolver}path\$" >/dev/null; then
      _xfrm_path_fn=xfrm_path_$_resolver
      _out_val=$($_xfrm_path_fn "$_in_val")
      printf '%s\n' "$_out_val"
      return 0
    fi
  done
  printf '%s\n' "$_in_val"
}

xfrm_path_project()
{
  _stem=$1
  if [ "$_stem" ]; then
    printf '%s\n' "$(path_relto "$ENGINE_PROJECT_DIR/$_stem" .)"
  fi
}

xfrm_path_local()
{
  _stem=$1
  if [ "$_stem" ]; then
    printf '%s\n' "$(path_relto "$ENGINE_LOCAL_DIR/$_stem" .)"
  fi
}

xfrm_path_subject()
{
  _stem=$1
  if [ "$_stem" ]; then
    printf '%s\n' "$(path_relto "$SUBJECT_DIR/$_stem" .)"
  fi
}

path_relto()
{
  "$LIB/sh/path-relto.sh" "$@"
}

if [ "$AS_DOT_SCRIPT" ]; then
  return
fi

#
# Startup
#

SCRIPT=$(basename "$0")
input_errors=

test $# -gt 0 || { usage; exit 0; }

#
# Arguments
#

path_fmt=rel
opt_table=pipelineOpts
opt_col=
opt_ref_type=var
opt_names=
opt_values=
artifact_ids=

while getopts :ht:c:r:p:k:v:a: flag; do
  case "$flag" in
    h) usage; exit 0;;
    t) opt_table=$OPTARG;;
    c) opt_col=$OPTARG;;
    r) opt_ref_type=$OPTARG;;
    p) path_fmt=$OPTARG;;
    k) opt_names=$(printf '%s\n%s\n' "$opt_names" "$OPTARG");;
    v) opt_values=$(printf '%s\n%s\n' "$opt_values" "$OPTARG");;
    a) artifact_ids=$(printf '%s\n%s\n' "$artifact_ids" "$OPTARG");;
   \?) input_error "invalid argument: -$OPTARG";;
  esac
done
shift `expr $OPTIND - 1`

#
# Validation
#

test "$ENGINE_ENV"           || input_error 'missing required context: ENGINE_ENV'
test "$ENGINE_PROJECT_DIR"   || input_error 'missing required context: ENGINE_PROJECT_DIR'
test "$ENGINE_LOCAL_DIR"     || input_error 'missing required context: ENGINE_LOCAL_DIR'
test "$ENGINE_ARTIFACTS_DIR" || input_error 'missing required context: ENGINE_ARTIFACTS_DIR'
test "$PIPELINE_NAME"        || input_error 'missing required context: PIPELINE_NAME'
test "$SUBJECT_NAME"         || input_error 'missing required context: SUBJECT_NAME'
test "$SUBJECT_DIR"          || input_error 'missing required context: SUBJECT_DIR'
test $# -gt 0                || input_error 'missing required argument: OPTS_FILE'

case $opt_table in
  pipelineOpts) true                                         ;;
  artifactRefs) true                                         ;;
  artifactOpts) true                                         ;;
             *) input_error "invalid TABLE: $opt_table"      ;;
esac

case $opt_col in
  values) true                                   ;;
    keys) true                                   ;;
      '') true                                   ;;
       *) input_error "invalid COLUMN: $opt_col" ;;
esac

case $opt_ref_type in
  variable|var) true                                          ;;
          list) true                                          ;;
             *) input_error "invalid RET_TYPE: $opt_ref_type" ;;
esac

case $path_fmt in
  rel) true                                      ;;
  abs) true                                      ;;
    *) input_error "invalid PATH_FMT: $path_fmt" ;;
esac

if [ "$input_errors" ]; then
  usage
  printf 'fatal: input errors\n' >&2
  printf '%s\n' "$input_errors"  >&2
  exit 1
fi

if [ "$opt_names" ]; then
  opt_names=$(printf '%s\n' "$opt_names" | sed -n '2,$p')
fi

if [ "$opt_values" ]; then
  opt_values=$(printf '%s\n' "$opt_values" | sed -n '2,$p')
fi

if [ "$artifact_ids" ]; then
  artifact_ids=$(printf '%s\n' "$artifact_ids" | sed -n '2,$p')
fi

#
# Defaults
#

test "$LIB"        || LIB=$(realpath "$(dirname "$0")/..")
test "$PATH_RELTO" || PATH_RELTO=$LIB/sh/path-relto.sh
export LIB
export PATH_RELTO

#
# Main
#

stmt_table_artifactrefs_load "$@"
stmt_table_artifactopts_load "$@"
stmt_table_pipelineopts_load "$@"
stmt_table_use "stmt_table_$(printf '%s\n' "$opt_table" | tr '[:upper:]' '[:lower:]')"

if [ "$opt_table" = artifactOpts ]; then

  artifact_opt_names=

  while read aid; do
    while read opt_name; do
      artifact_opt_names=$(printf '%s\n%s\\\.%s\n' "$artifact_opt_names" "$aid" "$opt_name")
    done <<EOF
$opt_names
EOF
  done <<EOF
$artifact_ids
EOF

  opt_names=$artifact_opt_names

fi

opt_keyseq=$(stmt_table_select_keyseq "$opt_names" "$opt_values")

case $opt_ref_type in
  variable|var) opt_value=$(keyseq_last_stmt $opt_keyseq)
                if [ absolute = "$path_fmt"                                                   ] &&
                   [ path     = "$(stmt_key_modifier `echo $opt_keyseq | awk '{print $NF}'`)" ] &&
                   [ "$(stmt_table_get modified)"                                             ]
                then
                  opt_value=$(path_relto "$opt_value" / | sed 's,^\.,,')
                fi
                test ! "$opt_value" || printf '%s\n' "$opt_value"
             ;;
          list) keyseq_all_stmts $opt_keyseq                                ;;
             *) printf 'BUG: fatal: unhandled table: %s\n' "$opt_table" >&2 ;;
esac
