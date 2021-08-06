#!/bin/sh
echo "What's the file's name?"
read FILE

INFILE=$(readlink -f ${FILE}_atleast-2.fastq)
OUTDIR="output"
NPROC=4

sed -n '1~4s/^@/>/p;2~4p' $INFILE > ${FILE}_atleast-2.fasta

export IGDATA=~/ImmcantationScripts/share/igblast
	~/ImmcantationScripts/share/igblast/bin/igblastn \
	    -germline_db_V ~/ImmcantationScripts/share/igblast/database_igh/rhesus_ig_v\
	    -germline_db_D ~/ImmcantationScripts/share/igblast/database_igh/rhesus_ig_d \
	    -germline_db_J ~/ImmcantationScripts/share/igblast/database_igh/rhesus_ig_j \
	    -auxiliary_data /share/igblast/optional_file/rhesus_monkey_gl.aux \
	    -domain_system imgt -ig_seqtype Ig -organism rhesus_monkey \
	    -outfmt '7 std qseq sseq btop' \
	    -query ${FILE}_atleast-2.fasta \
	    -out A84_atleast-2_igh.fmt7
