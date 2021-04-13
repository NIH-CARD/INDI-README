### Goal is to assess potential genomic alterations in the genotyping array data


### using genotyping array data to assess genomic alterations


```
###### INDI genotypes 
#
# March 28th 2021 
# Cornelis

----- Step 1 -----
# prep data in correct format

cd /data/CARD/projects/INDI_genotypes/INDI_RERUN/CNV/raw_files/

# check number of text files
ls | grep FinalReport | wc -l
# 185 which makes sense !!
# update names of current files
create list of all samples
ls | grep FinalReport > CNV_files.txt
# create backup copy
scp -r ../raw_files/ ../raw_files_OG/ 
# remove header = 10 rows
cat CNV_files.txt  | while read line
do 
   tail -487375 $line > short.$line
done
# add proper sample name... manually made conversion sheet
# add in mv and save as .txt
sh update_names_v2.sh
# clean-up folder
mkdir raw_files
mv INDI_RERUN_* raw_files
# make new sample list...
ls | grep txt | grep -v CNV > CNV_files.txt
# replace space with _
cat CNV_files.txt  | while read line
do 
	sed -i 's/ /_/g' $line
done
### filter out very low quality variants...
----- GC score of >0.4
awk '$5 >0.4' KOLF2-ARID2_A2_01.txt | cut -f 2 > GC_score_0_4_variants.txt
# make an additional anno_file_neurochip.txt file
module load R/3.6.1
R
anno_file <- read.table("anno_file_neurochip.txt",header=T)
GC_filter <- read.table("GC_score_0_4_variants.txt",header=T)
MM <- merge(anno_file, GC_filter, by.x="snpName", by.y="SNP_Name")
MM2 <- MM[,c(2,1,3,4)]
MM3 <- MM2[order(MM2$snpID),]
MM3$snpID <- 1:nrow(MM3) 
write.table(MM3, file="anno_file_neurochip_GC_filter04.txt", quote=FALSE,row.names=FALSE,sep="\t")
q()
n
----- GC score of >0.7
awk '$5 >0.7' KOLF2-ARID2_A2_01.txt | cut -f 2 > GC_score_0_7_variants.txt
# make an additional anno_file_neurochip.txt file
module load R/3.6.1
R
anno_file <- read.table("anno_file_neurochip.txt",header=T)
GC_filter <- read.table("GC_score_0_7_variants.txt",header=T)
MM <- merge(anno_file, GC_filter, by.x="snpName", by.y="SNP_Name")
MM2 <- MM[,c(2,1,3,4)]
MM3 <- MM2[order(MM2$snpID),]
MM3$snpID <- 1:nrow(MM3) 
write.table(MM3, file="anno_file_neurochip_GC_filter07.txt", quote=FALSE,row.names=FALSE,sep="\t")
q()
n

----- Step 2 -----

# DONE and ready for plot per chip
Need files

plot_per_chip.R => this is the R code that does the plotting
anno_file_neurochip.txt => this is the annotation file needed for plotting 
anno_file_neurochip_GC_filter04.txt => this is the annotation file needed for plotting but filtered for higher quality variants
anno_file_neurochip_GC_filter07.txt => this is the annotation file needed for plotting but filtered for high quality variants
scan_file_to_use.txt => this is the "scan" file needed for plotting
scan_file.txt => this is the "scan" file needed for plotting

# how to start for one sample
Rscript --vanilla plot_per_chip.R NCRM5-C5_24
Rscript --vanilla plot_per_chip_GC04.R NCRM5-C5_24
Rscript --vanilla plot_per_chip_GC07.R NCRM5-C5_24

# or to run all them all...
## make sample file
ls | grep txt | grep -v CNV | grep -v anno | grep -v score | grep -v scan | sed -e 's/.txt//g' > short_CNV_files_plot.txt


#!/bin/bash
# sbatch --cpus-per-task=20 --mem=240g --mail-type=END --time=21:00:00 RUN_DMC_ALL.sh
module load plink
module load R/3.6.1
# normal
cat short_CNV_files_plot.txt  | while read line
do 
	Rscript --vanilla plot_per_chip.R $line
done
# GC > 0.4
cat short_CNV_files_plot.txt  | while read line
do 
	Rscript --vanilla plot_per_chip_GC04.R $line
done
# GC > 0.7
cat short_CNV_files_plot.txt  | while read line
do 
	Rscript --vanilla plot_per_chip_GC07.R $line
done

## DONE !

```


