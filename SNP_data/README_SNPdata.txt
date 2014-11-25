Processing SNP data

October 2014-November 2014
by: Paul Bilinski

SNP data for the landraces and teosintes was gathered from the Pyhajarvi and Hufford.

Use the MergeSNPs.R to generate the MergedSNPs.csv file.  Open the file in a text editor,
move row 19 to the header since it is the column names.  Also, substitute any -- for NA
in the text editor as well.  The file should now contain landraces (SWUS+others), parv, 
mex.

Next, we have to remove columns for which we have no phenotypic data.  The list of column
ID's is in the MergeSNPs.R script, as are as follows.

AccessionID's from phenotypes, different names in genotype file <- RIMMA0656.1,RIMMA0664.1,RIMMA0665.1,RIMMA0670.1,RIMMA0672.1,RIMMA0677.1,RIMMA0682.1,RIMMA0687.1,RIMMA0707.1,RIMMA0722.1,RIMMA0668.1,RIMPA0110.4_dup1,RIMPA0110.10,RIMPA0110.11,RIMPA0110.2_dup1,RIMPA0110.5,RIMPA0110.6,RIMPA0110.7,RIMPA0110.3_dup2,RIMPA0110.8,RIMPA0110.9,RIMPA0155-C12.1,RIMPA0155-C13.1,RIMPA0155-C14.1,RIMPA0155-C19.1,RIMPA0155-C23.1,RIMPA0155-C28.1,RIMPA0155-C32.1,RIMPA0155-C33.1,RIMPA0155-C36.1,RIMPA0155-C39.1,RIMPA0155-C42.1,RIMPA0155-C45.1,RIMPA0156C15,RIMPA0156C18,RIMPA0156C19,RIMPA0156C21,RIMPA0156C28,RIMPA0156C29,RIMPA0156C38,RIMPA0156C42,RIMPA0156C43,RIMPA0156C45,RIMPA0156C48,RIMPA0156C49,RIMPA0157-C10.1,RIMPA0157-C15.1,RIMPA0157-C16.1,RIMPA0157-C19.1,RIMPA0157-C20.1,RIMPA0157-C22.1,RIMPA0157-C3.1,RIMPA0157-C32.1,RIMPA0157-C39.1,RIMPA0157-C45.1,RIMPA0157-C48.1,RIMPA0157-C9.1,RIMPA0158C13,RIMPA0158C15,RIMPA0158C21,RIMPA0158C27,RIMPA0158C29,RIMPA0158C3,RIMPA0158C33,RIMPA0158C44,RIMPA0158C46,RIMPA0158C49,RIMPA0158C6,RIMPA158(C50).1,RIMMA0384.1,RIMMA0386.1
List to be excluded, names in Genofile as seen in R <- "RIMMA0656.1","RIMMA0664.1","RIMMA0665.1","RIMMA0670.1","RIMMA0672.1","RIMMA0677.1","RIMMA0682.1","RIMMA0687.1","RIMMA0707.1","RIMMA0722.1","RIMMA0668.1","RIMPA0110.4_dup1","RIMPA0110.10","RIMPA0110.11","RIMPA0110.2_dup1","RIMPA0110.5","RIMPA0110.6","RIMPA0110.7","RIMPA0110.3_dup2","RIMPA0110.8","RIMPA0110.9","RIMPA0155.C12.1","RIMPA0155.C13.1","RIMPA0155.C14.1","RIMPA0155.C19.1","RIMPA0155.C23.1","RIMPA0155.C28.1","RIMPA0155.C32.1","RIMPA0155.C33.1","RIMPA0155.C36.1","RIMPA0155.C39.1","RIMPA0155.C42.1","RIMPA0155.C45.1","RIMPA0156C15","RIMPA0156C18","RIMPA0156C19","RIMPA0156C21","RIMPA0156C28","RIMPA0156C29","RIMPA0156C38","RIMPA0156C42","RIMPA0156C43","RIMPA0156C45","RIMPA0156C48","RIMPA0156C49","RIMPA0157.C10.1","RIMPA0157.C15.1","RIMPA0157.C16.1","RIMPA0157.C19.1","RIMPA0157.C20.1","RIMPA0157.C22.1","RIMPA0157.C3.1","RIMPA0157.C32.1","RIMPA0157.C39.1","RIMPA0157.C45.1","RIMPA0157.C48.1","RIMPA0157.C9.1","RIMPA0158C13","RIMPA0158C15","RIMPA0158C21","RIMPA0158C27","RIMPA0158C29","RIMPA0158C3","RIMPA0158C33","RIMPA0158C44","RIMPA0158C46","RIMPA0158C49","RIMPA0158C6","RIMPA158.C50..1","RIMMA0384.1","RIMMA0386.1"

With those accession excluded, we want to check to make sure each SNP only has 4 possible
genotypes, with NA included.  We do this back in R with the final output Check4GenosPer.txt.
They do, we cool.

Next, we have to convert the SNPs to -1 0 1 format.  To do so, we have the perl script
ConvertSNP2.pl (2 because the first one worked on a different format of SNPs and is still
included in this folder). Run this on the JustGenos.txt, and it will return a matrix with
columns as individuals and SNPs as rows.

	perl ConvertSNP2.pl JustGenos.txt Converted_JustGenos.csv

I added the column and row names to the file from GenosForConvert.csv, which was where the
JustGenos.txt was generated from.  The final line of the R script prints out Column names
of the genotype matrix, which will be used later in the melding of phenotype data with
genotype data.

This is now ready for Berg's Code!  Files to bring over:

	Converted_JustGenos_addednames.csv
	ColumnOrder_ForGenos.csv
	
	
	