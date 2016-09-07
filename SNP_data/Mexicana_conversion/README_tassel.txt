Tassel Notebook

1-remove taxa names; taxa with lots of missing data

BLANK:250481877
da6:250481907
tx12:250481947

the remaining 93 taxa present, had at most a missing data rate of 45%.  all 93 taxa were retained

We then filter on sites, requiring presence of data at 100%, (93/93), and no minor allele freq
filter.  This leaves us with ~48.5K sites.

We instead want a minimum of 0.01 and max of 0.99 to get rid of monomorphic sites.

We then load it into R, run the Tasselsnpconversion.Rmd script to convert to 2 letter base pairs.
We write the csv out, open in excel, remove rownames and column names.
We run the perl script below in the directory:

/Users/paulbilinski/Documents/Projects/Genome_Size_Analysis/Github_ParallelGS/SNP_data

perl ConvertSNP2.pl 



For the threshold set, we need to remove:

	BLANK:250481877
	da6:250481907
	tx12:250481947

And remove populations:

	AM
	M
	TZ

Then filter on taxa, at 0.45, all 70 remain.
Filter on sites: 70/70 remain, 0.01 and 0.99 for max allele frequencies, will get rid of monomorphics

Export tab delimited with no depth.  File is named:

	GBS_alt_threshold_Tasselout.txt 

Now into R markdown; for convert single basepair to double base:

	GBS_alt_threshold_2bpout.txt

Open in text wrangler, remove quotes at start.  Cut out sequence order and save in file:

	GBS_alt_threshold_justorder.txt

And the cleaned up, no header file is:

	GBS_alt_threshold_2bp_noheader.txt

Now remove leading characters using perl, and then convert to 0 and 1 and -1.

	perl Removeleadingchars.pl GBS_alt_threshold_2bp_noheader.txt > GBS_alt_threshold_2bp_nolead.txt
