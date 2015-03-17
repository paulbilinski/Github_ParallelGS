**************************************
*      BWA MEM REPEAT Mapping        *
**************************************
By: Paul Bilinski, UC Davis, 2014

This readme will include all of the instructions necessary for all repetitive content read
mapping on the cluster.  First, we will start with some basic tools for playing with the
data.  Here are a few bits of code I use frequently:

#Getting on bigmem to start playing around data interactively

srun --pty -p bigmemh bash


1. BUILDING REPETITIVE CONTENT LIBRARIES
In bwa, we want ot use index to make our repeat libraries

	bwa index FTEdb.fasta
	bwa index B73v2.centcseq
	bwa index 180Knob_ref.fasta
	bwa index ZMcdna.fa
	bwa index ZMpt.fa
	bwa index ZMmt.fa
	bwa index TR-1_ref.fasta
	bwa index TEdb_nobreak.fasta
		
2. MAP AND COUNT HITS

Script for mapping is as follows:

temp=/scratch/pbilinsk/tmp$SLURM_JOB_ID/
mkdir -p $temp
cd $temp

for files in ____

do
cp /group/jrigrp/Share/PaulB_Data/Run1_Fwd/$files .
cp /home/pbilinsk/bwamapping/ParseSam.pl .
cp /home/pbilinsk/bwamapping/TEdb_nobreak.fasta* .
#align
bwa mem -B 2 -k 11 TEdb_nobreak.fasta $files > $files.sam
#bwa mem parameters switch between DEFAULT (nothing; used against chloroplast, mito, and cDNA),
# -B 2 -k 11 -a (keep multiple maps), and the -B 2 -k 11 (only keep track of total)
perl ./ParseSam.pl $files.sam $files.abund
sort $files.abund | tail -n +2 > $files.abundsort
cut -d "," -f 2 $files.abundsort | awk '{s+=$1} END {print s}' > $files.total
mv $files.total /home/pbilinsk/bwamapping/allteabund/
#mv $files.abund /home/pbilinsk/bwamapping/allteabund/
rm $files*
rm TEdb_nobreak.fasta*
rm ParseSam.pl

3. MERGE COUNTS

For total in each file:
grep "" *total

Then bring the output to text wrangler and input it into the excel spreadsheet!



List of files in each run:
Run1_Fwd:
RIMMA0385.1.fastq RIMMA0614.1.fastq RIMMA0682.1.fastq RIMMA0730.1.fastq RIMME0026_C12.1.fastq RIMME0030.5.fastq RIMMA0387.1.fastq RIMMA0615.1.fastq RIMMA0687.1.fastq RIMMA0731.1.fastq RIMME0026_C14.1.fastq RIMME0030.7.fastq RIMMA0389.1.fastq RIMMA0619.1.fastq RIMMA0690.1.fastq RIMMA0733.1.fastq RIMME0026_C3.1.fastq RIMME0031.10.fastq RIMMA0395.2.fastq RIMMA0620.1.fastq RIMMA0691.1.fastq RIMME0021_C10.1.fastq RIMME0026_C4.1.fastq RIMME0031.11.fastq RIMMA0397.1.fastq RIMMA0626.2.fastq RIMMA0700.1.fastq RIMME0021_C11.1.fastq RIMME0026_C5.1.fastq RIMME0031.12.fastq RIMMA0404.1.fastq RIMMA0656.1.fastq RIMMA0701.1.fastq RIMME0021_C1.1.fastq RIMME0026_C6.1.fastq RIMME0031.4.fastq RIMMA0405.1B.fastq RIMMA0657.1.fastq RIMMA0702.1.fastq RIMME0021_C12.1.fastq RIMME0026_C7.1.fastq RIMME0031.7.fastq RIMMA0430.1.fastq RIMMA0662.1.fastq RIMMA0703.1.fastq RIMME0021_C13.1.fastq RIMME0026_C8.1.fastq RIMME0035.11.fastq RIMMA0436.1.fastq RIMMA0663.1.fastq RIMMA0709.1.fastq RIMME0021_C14.1.fastq RIMME0026_C9.1.fastq RIMME0035.8.fastq RIMMA0438.1.fastq RIMMA0665.1.fastq RIMMA0710.1.fastq RIMME0021_C2.1.fastq RIMME0029.12.fastq RIMME0035.9.fastq RIMMA0439.1.fastq RIMMA0667.1.fastq RIMMA0712.1.fastq RIMME0021_C4.1.fastq RIMME0029.1.fastq RIMPA0071.16.fastq RIMMA0464.1.fastq RIMMA0668.1.fastq RIMMA0720.1.fastq RIMME0021_C6.1.fastq RIMME0029.3.fastq RIMPA0071.17.fastq RIMMA0465.1.fastq RIMMA0671.1.fastq RIMMA0721.1.fastq RIMME0021_C7.1.fastq RIMME0029.4.fastq RIMPA0071.4.fastq RIMMA0466.1.fastq RIMMA0672.1.fastq RIMMA0722.1.fastq RIMME0021_C9.1.fastq RIMME0029.9.fastq RIMPA0071.5.fastq RIMMA0468.1.fastq RIMMA0677.1.fastq RIMMA0727.1.fastq RIMME0026_C10.1.fastq RIMME0030.12.fastq RIMPA0096.12.fastq RIMMA0473.1.fastq RIMMA0680.1.fastq RIMMA0729.1.fastq RIMME0026_C11.1.fastq RIMME0030.13.fastq RITD0001.1.fastq
Run2_Rev: (Fwd was missing a few files... my bet is they got lost just like Run3_Rev during intern time)
RIMMA0381.1.fastq RIMMA0416.1.fastq RIMMA0658.1.fastq RIMME0028.5.fastq RIMME0030.2.fastq RIMME0035.4.fastq RIMPA0096.13.fastq RIMMA0382.1.fastq RIMMA0418.1.fastq RIMMA0664.1.fastq RIMME0028.6.fastq RIMME0030.4.fastq RIMME0035.5.fastq RIMPA0096.14.fastq RIMMA0383.1.fastq RIMMA0423.1.fastq RIMMA0670.1.fastq RIMME0028.8.fastq RIMME0030.6.fastq RIMME0035.7.fastq RIMPA0096.15.fastq RIMMA0390.1.fastq RIMMA0426.1.fastq RIMMA0674.1.fastq RIMME0028.9.fastq RIMME0030.8.fastq RIMPA0071.1B.fastq RIMPA0096.17.fastq RIMMA0391.1B.fastq RIMMA0431.1.fastq RIMMA0696.1.fastq RIMME0029.10.fastq RIMME0030.9.fastq RIMPA0071.2.fastq RIMPA0096.2.fastq RIMMA0392.1.fastq RIMMA0437.1.fastq RIMMA0708.1.fastq RIMME0029.11.fastq RIMME0031.2.fastq RIMPA0071.3.fastq RIMPA0096.3.fastq RIMMA0393.1.fastq RIMMA0441.1.fastq RIMMA0716.1.fastq RIMME0029.13.fastq RIMME0031.5.fastq RIMPA0086.11.fastq RIMPA0096.6.fastq RIMMA0396.1.fastq RIMMA0467.1.fastq RIMME0021_C3_.1.fastq RIMME0029.14.fastq RIMME0031.6.fastq RIMPA0086.13.fastq RIMPA0096.7.fastq RIMMA0398.1.fastq RIMMA0616.1.fastq RIMME0026_C15_.1.fastq RIMME0029.2.fastq RIMME0031.8.fastq RIMPA0086.8.fastq RIMPA0142.1.fastq RIMMA0399.1.fastq RIMMA0621.1.fastq RIMME0028.13.fastq RIMME0029.6.fastq RIMME0031.9.fastq RIMPA0087.12.fastq RIMPA0142.6.fastq RIMMA0403.2.fastq RIMMA0623.1.fastq RIMME0028.1.fastq RIMME0029.8.fastq RIMME0033.10.fastq RIMPA0087.1.fastq RIMPA0142.7.fastq RIMMA0406.1.fastq RIMMA0625.1.fastq RIMME0028.2.fastq RIMME0030.11.fastq RIMME0033.11.fastq RIMPA0087.2.fastq RIMPA0142.9.fastq RIMMA0410.1B.fastq RIMMA0628.1.fastq RIMME0028.3.fastq RIMME0030.14.fastq RIMME0035.2.fastq RIMPA0087.3.fastq RIMMA0415.1.fastq RIMMA0630.1.fastq RIMME0028.4.fastq RIMME0030.1.fastq RIMME0035.3.fastq RIMPA0096.11.fastq
Run3_Fwd:
RIL0001.1.fastq RIMMA0707.1.fastq RIMME0032.8.fastq RIMME0034.3.fastq RIMPA0086.3.fastq RIMPA0135.12.fastq RIMMA0384.1.fastq RIMME0028.10.fastq RIMME0032.9.fastq RIMME0034.4.fastq RIMPA0086.6.fastq RIMPA0135.1.fastq RIMMA0386.1.fastq RIMME0028.14.fastq RIMME0033.12.fastq RIMME0034.5.fastq RIMPA0086.7.fastq RIMPA0135.2.fastq RIMMA0388.1.fastq RIMME0028.7.fastq RIMME0033.13.fastq RIMME0034.8.fastq RIMPA0086.9.fastq RIMPA0135.3.fastq RIMMA0394.2.fastq RIMME0031.1.fastq RIMME0033.1.fastq RIMME0034.9.fastq RIMPA0087.10.fastq RIMPA0135.4.fastq RIMMA0407.1.fastq RIMME0031.3.fastq RIMME0033.3.fastq RIMME0035.10.fastq RIMPA0087.11.fastq RIMPA0135.5.fastq RIMMA0409.1.fastq RIMME0032.10.fastq RIMME0033.4.fastq RIMME0035.12.fastq RIMPA0087.4.fastq RIMPA0135.8.fastq RIMMA0417.1.fastq RIMME0032.12.fastq RIMME0033.5.fastq RIMME0035.1.fastq RIMPA0087.5.fastq RIMPA0135.9.fastq RIMMA0421.1.fastq RIMME0032.13.fastq RIMME0033.6.fastq RIMME0035.6.fastq RIMPA0087.6.fastq RIMPA0142.11.fastq RIMMA0422.1.fastq RIMME0032.14.fastq RIMME0033.7.fastq RIMPA0071.11.fastq RIMPA0087.7.fastq RIMPA0142.12.fastq RIMMA0424.1.fastq RIMME0032.15.fastq RIMME0033.8.fastq RIMPA0071.12.fastq RIMPA0087.8.fastq RIMPA0142.13.fastq RIMMA0425.1.fastq RIMME0032.1.fastq RIMME0033.9.fastq RIMPA0071.13.fastq RIMPA0087.9.fastq RIMPA0142.14.fastq RIMMA0428.1.fastq RIMME0032.3.fastq RIMME0034.10.fastq RIMPA0071.14.fastq RIMPA0096.1.fastq RIMPA0142.2.fastq RIMMA0433.1.fastq RIMME0032.4.fastq RIMME0034.12.fastq RIMPA0086.10.fastq RIMPA0096.8.fastq RIMPA0142.3.fastq RIMMA0462.1.fastq RIMME0032.5.fastq RIMME0034.1.fastq RIMPA0086.1.fastq RIMPA0135.10.fastq RIMPA0142.4.fastq RIMMA0661.1.fastq RIMME0032.7.fastq RIMME0034.2.fastq RIMPA0086.2.fastq RIMPA0135.11.fastq RIMPA0142.8.fastq

