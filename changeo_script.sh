#!/bin/sh
echo "What's the file ID?"
read FILE

dirnow=$(pwd)

if [ -e ${FILE}_atleast-2.fasta ]
then
        echo "File in" $dirnow
else
        echo "File not in" $dirnow
	echo "Unable to proceed..."
	exit
fi

echo "CPU cores:"
read CORES

cpu=$(grep -c ^processor /proc/cpuinfo)

while [ $CORES -gt $cpu ]
do
        echo "Number of cores unavailable. Set the number of cores again:"
        read CORES
        if [ $CORES -lt $cpu ]; then
        break
        fi
done

NPROC=${CORES}
PIPELINE_LOG="Pipeline.log"
R_LOG="R.log"

MakeDb.py igblast -i ${FILE}_atleast-2_igh.fmt7 -s ${FILE}_atleast-2.fasta \
    -r IMGT_IGHV.fasta IMGT_IGHD.fasta IMGT_IGHJ.fasta \
    --partial --extended >> $PIPELINE_LOG

ParseDb.py select -d ${FILE}_atleast-2_igh_db-pass.tsv -f productive -u T >> $PIPELINE_LOG

Rscript changeO.R >> $R_LOG
DIST=$(awk '{print substr($2,1,4)}' R.log)

DefineClones.py -d ${FILE}_atleast-2_igh_db-pass_parse-select.tsv --act set --model ham \
    --norm len --dist $DIST  --nproc $NPROC >> $PIPELINE_LOG

CreateGermlines.py -d ${FILE}_atleast-2_igh_db-pass_parse-select_clone-pass.tsv -g dmask --cloned \
    -r IMGT_IGHV.fasta IMGT_IGHD.fasta IMGT_IGHJ.fasta >> $PIPELINE_LOG
