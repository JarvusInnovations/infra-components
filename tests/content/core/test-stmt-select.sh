set -e


AS_DOT_SCRIPT=1 . "$ENGINE_PROJECT_DIR/content/sh/case.sh"
AS_DOT_SCRIPT=1 . "$LIB/sh/stmt-select.sh"

usage()
{
  printf 'Usage: %s OPTS_FILE... \n' "$SCRIPT" >&2
}

SCRIPT=$(basename "$0")

test $# -gt 0 || { usage; printf 'fatal: missing OPTS_FILE\n' >&2; exit 1; }
case $1 in
  -h|--help) usage; exit 0 ;;
          *) true          ;;
esac

test_cmd stmt_table_artifactrefs_load "$@"
test_cmd stmt_table_artifactopts_load "$@"
test_cmd stmt_table_pipelineopts_load "$@"
test_cmd "test foo-value = $(opt_keyseq_tovar 'optFoo')"
test_cmd "test corge-subject-value = $(opt_keyseq_tovar 'optCorge')"
baz_keyseq=
test_cmd "baz_keyseq='" $(opt_name_keyseq 'optBaz') "'"
test_cmd "test $(path_relto "$ENGINE_ARTIFACTS_DIR" .)/baz.txt = $(opt_keyseq_tovar $baz_keyseq)"
bar_keyseq=
test_cmd "bar_keyseq='" $(opt_name_keyseq 'optBar') "'"
test_cmd "test ../../../../environments/core/bar-local-path = $(opt_keyseq_tovar $bar_keyseq)"
qux_keyseq=
test_cmd "qux_keyseq='" $(opt_name_keyseq 'optQux') "'"
test_cmd "test ../../../../content/core/qux-project-env = $(opt_keyseq_tovar $qux_keyseq)"
quux_keyseq=
test_cmd "quux_keyseq='" $(opt_name_keyseq 'optQuux') "'"
test_cmd "test optquuxprojectpath = $(echo $quux_keyseq | awk '{print $1}')"
test_cmd "test optquuxsubjectpath = $(echo $quux_keyseq | awk '{print $2}')"
test_cmd "test ./quux-subject-env = $(opt_keyseq_tovar $quux_keyseq) "
test_cmd "test '$(pwd)/quux-subject-env' = $(path_fmt=abs opt_keyseq_tovar $quux_keyseq)"
test_cmd "test foos-item-1 = $(opt_keyseq_tolist 'optFoosItem' | sed -n 1p)"
test_cmd "test foos-item-2 = $(opt_keyseq_tolist 'optFoosItem' | sed -n 2p)"
test_cmd "test bars-item-2 = $(opt_keyseq_tolist 'optBarsItem' | sed -n 1p)"
test_cmd "test bars-item-3 = $(opt_keyseq_tolist 'optBarsItem' | sed -n 2p)"
bazs_item_keyseq=
test_cmd "bazs_item_keyseq='" $(opt_name_keyseq 'optBazsItem') "'"
test_cmd "test bazs-item-1 = $(opt_keyseq_tolist $bazs_item_keyseq | sed -n 1p)"
test_cmd "test ../../../../environments/core/bazs-local-path = $(opt_keyseq_tolist $bazs_item_keyseq | sed -n 2p)"
test_cmd "test ../../../../content/core/bazs-project-path = $(opt_keyseq_tolist $bazs_item_keyseq | sed -n 3p)"
test_cmd "test $(path_relto "$ENGINE_ARTIFACTS_DIR" .)/baz.txt = $(opt_keyseq_tolist $bazs_item_keyseq | sed -n 4p)"
test_cmd "test bazs-item-2 = $(opt_keyseq_tolist $bazs_item_keyseq | sed -n 5p)"
test_cmd "test ./bazs-subject-path = $(opt_keyseq_tolist $bazs_item_keyseq | sed -n 6p)"
test_cmd "test bazs-item-3 = $(opt_keyseq_tolist $bazs_item_keyseq | sed -n 7p)"
test_cmd "test $(path_relto "$ENGINE_ARTIFACTS_DIR" .)/baz.txt = $(stmt_table_name=stmt_table_artifactrefs opt_keyseq_tovar 'baz')"
test_cmd stmt_table_use stmt_table_artifactopts
test_cmd "test setup/opt = $(opt_keyseq_tovar baz.producer)"
test_cmd "test tests-publisher-1 = $(opt_keyseq_tolist baz.publishersItem | sed -n 1p)"
test_cmd "test tests-publisher-2 = $(opt_keyseq_tolist baz.publishersItem | sed -n 2p)"
