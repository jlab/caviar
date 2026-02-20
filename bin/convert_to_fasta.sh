#!/bin/bash

# Usage: ./convert_to_fasta.sh left_reads.fq right_reads.fq left_reads.fa right_reads.fa

set -euo pipefail

left_in="$1"
right_in="$2"
left_out="$3"
right_out="$4"

awk 'NR%4 == 1 {print ">" substr($0, 2)} NR%4 == 2 {print}' "$left_in" > "$left_out"
awk 'NR%4 == 1 {print ">" substr($0, 2)} NR%4 == 2 {print}' "$right_in" > "$right_out"
