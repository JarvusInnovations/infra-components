#!/bin/sh

path_dest=$1
path_start=$2

SCRIPT=$(basename "$0")

#
# Functions
#

usage()
{
  printf 'Usage: %s DEST_PATH START_DIR\n' "$SCRIPT"
  printf 'Print the relative path to DEST_PATH from START_DIR on the current system\n'
}

die()
{
  printf '%s: fatal: %s\n' "$SCRIPT" "$1" >&2
  exit 1
}

path_norm()
{
  _path=$1
  _base=
  _stem=
  while ! realpath "$_path" >/dev/null 2>&1; do
    if [ "$_path" = '/' ]; then
      die 'path_norm: realpath failed to resolve /'
    fi
    _stem="/$(basename "$_path")$_stem"
    _path=$(dirname "$_path")
  done
  _base=$(realpath "$_path")
  test "$_base" != '/' || _base=
  printf '%s\n' "$_base$_stem"
}

path_strip_base()
{
  _path=$1
  _base=$2
  printf '%s\n' "${_path#$_base}"
}

paths_shared_base()
{
  _path1=$1
  _path2=$2
  awk_prog='
  BEGIN   { FS = "/"; base_depthsz = 0; }
  NR == 1 { for (depth = 1; depth <= NF; depth++) { path1[depth] = $depth }; path1_depthsz = NF; }
  NR == 2 { for (depth = 1; $depth == path1[depth]; depth++) { base[depth] = $depth; base_depthsz++; if (depth+1 > NF || depth+1 > path1_depthsz) break; }}
  END     {
    for (depth = 1; depth <= base_depthsz; depth++) {
      printf("%s", base[depth]);
      if (depth == 1 && base[depth] == "") {
	printf "/"
      }
      else if ((depth+1) <= base_depthsz) {
	printf "/"
      }
    }
    if (base_depthsz > 0) printf "\n";
  }
'
  awk "$awk_prog" <<-EOF
	$_path1
	$_path2
	EOF
}

stem_to_traversal()
{
  _stem=$1
  awk_prog='
  BEGIN { FS = "/" }
        {
	  for (depth = 1; depth <= NF; depth++)
	  {
	    if ($depth)
	    {
	      printf "..";
	      if ((depth+1) <= NF) printf "/";
	    }
	  }
	  if (NF > 0) printf "\n";
	}
'
  awk "$awk_prog" <<-EOF
	$_stem
	EOF
}

#
# Main
#

if [ "$1" = '-h' ] || [ "$1" = '--help' ] || [ $# -eq 0 ]; then
  usage
  exit 0
fi

inputs_valid=1

if ! type realpath >/dev/null 2>&1; then
  die 'a realpath implementation is required'
fi

if ! [ "$path_dest" ]; then
  printf 'DEST_PATH is required\n' >&2
  inputs_valid=
fi

if ! [ "$path_start" ]; then
  printf 'START_DIR is required\n' >&2
  inputs_valid=
fi

if ! [ $inputs_valid ]; then
  die 'invalid inputs'
fi

path_dest_norm=$(path_norm "$path_dest")
path_start_norm=$(path_norm "$path_start")
path_base=$(paths_shared_base "$path_dest_norm" "$path_start_norm")

if ! [ "$path_base" ]; then
  die "no shared base between paths: $path_dest_norm, $path_base_norm"
fi

if [ "$path_base" = '/' ]; then
  stem_dest=$path_dest_norm
  stem_start=$path_start_norm
else
  stem_dest=$(path_strip_base "$path_dest_norm" "$path_base")
  stem_start=$(path_strip_base "$path_start_norm" "$path_base")
fi

if [ "$stem_start" ]; then
  path_traversal=$(stem_to_traversal "$stem_start")
else
  path_traversal=.
fi

if [ "$DEBUG" ]; then
  printf 'DEBUG path_dest_norm=%s\n'  "$path_dest_norm"
  printf 'DEBUG path_start_norm=%s\n' "$path_start_norm"
  printf 'DEBUG path_base=%s\n'       "$path_base"
  printf 'DEBUG stem_dest=%s\n'       "$stem_dest"
  printf 'DEBUG stem_start=%s\n'      "$stem_start"
  printf 'DEBUG path_traversal=%s\n'  "$path_traversal"
fi

printf '%s%s\n' "$path_traversal" "$stem_dest"
