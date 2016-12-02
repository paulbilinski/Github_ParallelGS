README SNP merging:

8-13-16 by Paul Bilinski

Starting materials:
	Parviglumis_TopStrand_FinalReport.txt # parv snp data
	55KAnnotations.txt #chip location IDs
	tassel55_merging_30min.hmp.txt #gbs location info

The goal is to find the overlap between GBS and chip SNPs for structure analysis.
We will first merge just the locations for the gbs and snpchip, and then pull out the SNPs for the individuals after, so that the files we are filtering in the end are smaller.

All of this was done with a combination of excel and text wrangler and a few perl scripts that are in this folder. Mutate the ID's to get a unique ID that has chromosome and location information. The mutate scripts are located in the folder:

	mutateID55k.pl
	tassel55_mutated.txt

Remove the ID's from the gbs and chip files, and use the Mergingscript.R to merge the files.  From there you will pull out the individuals for the chip and the gbs.  These scripts will help:

Pull55ksites.pl  Pullgbssites.pl

From there, combine them in a single file.  Now we have to take the + and top strand alleles and make sure we are reading from the same strand.  Here you have to REMOVE TRIALLELIC sites from the main data set. Extract the chip/parv data + the allele calls from the gbs. Run the matchtopstrandplu.pl script, out the data back.  Then replace missing data with NA, even if one SNP is missing recode the whole thing.  Samephase_nowconvert.csv then has the genotypes with individuals in columns. Then convert genotypes to 0 1 for structure.

	Matchtopstrandplus.pl
	ConvertSNP_gbschip.pl

I removed tri-allelic SNPS in the GBS data.

