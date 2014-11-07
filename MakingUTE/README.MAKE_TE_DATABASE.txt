**************************************
*      Build the UTE with BLAST      *
**************************************
By: Paul Bilinski, UC Davis, 2012
Updated for GS project 2014

This is the series of steps to take to generate a unique transposable element database 
(UTE).  The goal is to use BLAST to identify the shared regions and then use this series 
of scripts to mask out the common regions with ---.  Once NNNs and common regions are 
turned into ---, we can then use the scripts to cycle through and extract all tags of a 
given length into a UTE.  Then, the masked regions are blasted back against the UTE to 
make sure that no repeated regions exist in the UTE.

Step 1.  Have the FASTA of the TEdb, make it into a blast DB and blast against self.

makeblastdb -in TEdb_nobreak_namechange.fasta -dbtype 'nucl' -parse_seqids

This step is done on the cluster (/home/pbilinsk/UTE_Project)
blastn -query TEdb_nobreak_namechange.fasta -evalue 1E-1 -outfmt 7 -task blastn -db TEdb_nobreak_namechange.fasta -num_threads 4 -out TEself
blastn -query TEdb_nobreak_namechange.fasta -evalue 1E-1 -outfmt 7 -db TEdb_nobreak_namechange.fasta -num_threads 4 -out TEselfmega

Step 2. Use the blast to mask out the regions within the TE reference with the perl script
Mask_Blasthits.pl and also print the masked regions with the script PrintMaskedregions.pl

perl Mask_Blasthits.pl TEself TEdb_nobreak_namechange.fasta dashes.txt MaskedTEdb.fasta 
perl PrintMaskedregions.pl TEself TEdb_nobreak_namechange.fasta dashes.txt trash maskedparts.txt

perl Mask_Blasthits.pl TEselfmega TEdb_nobreak_namechange.fasta dashes.txt MaskedTEdbmega.fasta 
perl PrintMaskedregions.pl TEselfmega TEdb_nobreak_namechange.fasta dashes.txt trash maskedpartsmega.txt


The path these take will be different.  We want to use the MaskedTEdb.fasta to make the
real UTE, while we will use the maskedparts.txt to blast against the UTE and take out any
remaining hits.  To make the UTE from MaskedTEdb.fasta, we bring it off the cluster and
process it with textwrangler. NN's after the masking is complete.  To do so, search for NN
and replace with --.  Be careful, as 5 TEs with SINE have an N, so if you replace that N 
with a dash you replace that as well.  When replacing N, check case sensitive to not delete
the consensus words.  Then go back and change SIE to SINE.

MaskedTEdb.fasta (process with so no N) -> MaskedTEdb_noN.fasta

Also, replace the -- so that they are a single -, in the end. Sep tags works on 1 -.  Need
to get rid of the N as well.

Step 3. Separate the tags, and count up how many are present:

Run:
perl Sep_TE_tags.pl MaskedTEdb_noN.fasta preUTE.fasta
perl Sep_TE_tags.pl MaskedTEdbmega_noN.fasta preUTEmega.fasta


To check how many unique TE's are in there:
grep ">" preUTE.fasta | sed 's/..$//' | uniq | wc -l
grep -v ">" preUTE.fasta | wc -m
grep ">" preUTEmega.fasta | sed 's/..$//' | uniq | wc -l
grep -v ">" preUTEmega.fasta | wc -m


So 1009 uniq TEs, with 1,418,642 bp when using blastn.
vs 1194 and 2,768,308.  Clearly megablast will have so much more to map to.

This will make the UTE, but we probably actually want the megablast, since it is less
specific.  So ditch the blastn, has so much less to map to.  preUTEmega.fasta it is!

Step 4.  Refilter the preUTE for hits that were deleted.

First, make the blastdb.
makeblastdb -in maskedpartsmega.txt -dbtype 'nucl' -parse_seqids

Blast masked parts against the UTE.
blastn -query preUTEmega.fasta -evalue 1E-1 -outfmt 7 -db maskedpartsmega.txt -num_threads 4 -out refilter

Mask other parts.
perl Mask_Blasthits.pl refilter preUTEmega.fasta dashes.txt RefilteredUTEmega.fasta

Bring back to desktop, clean out the dashes, run sep again.
perl Sep_TE_tags.pl RefilteredUTEmega.fasta FTEdb.fasta

grep ">" FTEdb.fasta | sed 's/..$//' | uniq | wc -l
grep -v ">" FTEdb.fasta | wc -m

And final UTE has:
1834 Unique TE families
2,752,101 BP
