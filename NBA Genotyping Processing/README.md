## NBA Genotyping processing for INDI

June 2021

Cornelis + Caroline

### Prior to this...

```
- DNA isolated
- Genotyping done by external
- Genotype data clustered and processed by Dan Vitale (DTI)
```


### Initial data processing

```
Working-dir:
/data/CARD/projects/INDI_genotypes/PHASE2_post_KOLF_selection/

### first_data_release_June_2021

- F4SEttehadieh_P1.zip
- F4SEttehadieh_P2-3.zip

F4SEttehadieh_P1.zip contains:
F4SEttehadieh_P1_Genotyping_Report.txt => full report 
F4SEttehadieh_P1_QC_Report.xlsx => QC metrics
Raw_Data/ => with 192 .idats 

F4SEttehadieh_P2-3.zip contains:
F4SEttehadieh_P2-P3_Genotyping_Report.txt => full report 
F4SEttehadieh_P2-P3_QC_Report.xlsx => QC metrics  
Raw_Data/ => with 384 .idats 

- plink files => in folder plink
ibx.bed  ibx.bim	ibx.fam  ibx.log

these are files from Dan, note general plink files + NOTE has to be clustered with other data since the Illumina algorithm needs some more diversity

minor follow-up change => update the names of the plink files....

module load plink

plink --bfile ibx --update-ids UPDATE_IBX_names.txt --make-bed --out ibx_new_name


- ibx_variant_metrics.txt
Massive file containing:
```
| CHROM | POS    | ID           | REF | ALT | variable            | metrics                    | GT  | GQ | BAF       | LRR        |
|-------|--------|--------------|-----|-----|---------------------|----------------------------|-----|----|-----------|------------|
| 1     | 49554  | 1:49554-G-A  | A   | G   | 204835450051_R02C01 | 0/1:4:0.443945:0.0862759   | 0/1 | 4  | 0.443945  | 0.0862759  |
| 1     | 115746 | JHU_1.115745 | C   | T   | 204835450051_R02C01 | 0/0:3:0.0800513:-0.0912774 | 0/0 | 3  | 0.0800513 | -0.0912774 |
| 1     | 534238 | JHU_1.534237 | A   | C   | 204835450051_R02C01 | 0/0:2:0:-0.228487          | 0/0 | 2  | 0         | -0.228487  |
```
For all samples...

```

### KOLF genome

```
# option 1 (from Lirong)
cd /data/CARD/projects/INDI_genotypes/PHASE2_post_KOLF_selection/KOLF_GENOME

module load plink/2.3-alpha
module load bcftools
# split multiallelics, but wonder why they are even in there?
bcftools norm -m- consensus_variants_3common.vcf > consensus_variants_3common_split_multi.vcf

plink2 --vcf consensus_variants_3common_split_multi.vcf --make-bed --out KOLF_PLINK

# option 2 (older version used in phase 2 combined with 8 other genomes)

cd /data/CARD/projects/INDI_genotypes/PHASE1_pre_KOLF_selection/WGS
INDI_WGS_RS_only.*


```


## Three analyses to do

### 1. Verify presence of CRISPR'ed variant
  Simple check if the variant that is CRISPR'ed in is actually present
  
### 2. Comparison with WGS
  Comparing the array data with the donor KOLF WGS
  
### 3. Plot per sample
  Make a plot per array to assess for genomic alterations
  

## 1. Verify presence of CRISPR'ed variant

Variants to investigate are:

JAX:
| Chromosome | NBA_ID                           | BP        | A1   | A2  | INDI          |
|------------|----------------------------------|-----------|------|-----|---------------|
| 16         | Seq_rs387906627                  | 31202373  | A    | G   | FUS_R495*     |
| 17         | 17:44101427-C-T                  | 44101427  | A    | G   | MAPT_R317W    |
| 17         | Seq_rs63750424                   | 44101427  | A    | G   | MAPT_R317W    |
| 17         | rs63750424                       | 44101427  | A    | G   | MAPT_R317W    |
| 21         | exm1563596                       | 27269932  | A    | G   | APP_A673T     |
| 21         | seq_rs63750847                   | 27269932  | A    | G   | APP_A673T     |
| 14         | Seq_rs121909536_ilmnfwd_ilmnF2BT | 21161845  | A    | T   | ANG_K41I      |
| 14         | exm1085312                       | 21161845  | A    | T   | ANG_K41I      |
| 14         | rs121909536                      | 21161845  | A    | T   | ANG_K41I      |
| 5          | exm505578                        | 176048219 | A    | C   | SNCB_P123H    |
| 5          | seq_rs104893937                  | 176048219 | A    | C   | SNCB_P123H    |
| 17         | 17:4850037-T-G                   | 4850037   | C    | A   | PFN1_C71G     |
| 12         | 12:54677628-G-A                  | 54677628  | 0    | G   | HNRNPA1_D262N |
| 12         | Seq_rs397518453                  | 54677628  | 0    | G   | HNRNPA1_D262N |
| Not        | Present                          | on        | the  | NBA | CSF1R_E633K   |

Synthego:
| Chromosome | NBA_ID                             | BP        | A1 | A2 | INDI             |
|------------|------------------------------------|-----------|----|----|------------------|
| 1          | 1:227073304-A-T                    | 227073304 | T  | A  | PSEN2_N141I      |
| 1          | rs63750215                         | 227073304 | T  | A  | PSEN2_N141I      |
| 19         | chr19:44908684:T:C                 | 45411941  | 0  | A  | APOE_C156R       |
| 19         | rs429358                           | 45411941  | 0  | A  | APOE_C156R       |
| 19         | 19:45412013-C-A                    | 45412013  | 0  | 0  | APOE_R136S       |
| 19         | seq_rs7412                         | 45412079  | 0  | G  | APOE_R158C       |
| 16         | 16:31196382-C-T                    | 31196382  | A  | G  | FUS_R216C        |
| 16         | Seq_rs267606832.1_ilmnfwd_ilmnF2BT | 31196382  | G  | C  | FUS_R216C        |
| 16         | Seq_rs267606832.2_ilmnfwd_ilmnF2BT | 31196382  | A  | G  | FUS_R216C        |
| 17         | 17:42427619-C-T                    | 42427619  | A  | G  | GRN_Q125X        |
| 17         | Seq_rs63750077                     | 42427619  | A  | G  | GRN_Q125X        |
| 9          | 9:135205819-T-C                    | 135205819 | G  | A  | SETX_L389S       |
| 9          | Seq_rs29001584                     | 135205819 | G  | A  | SETX_L389S       |
| 9          | rs29001584                         | 135205819 | G  | A  | SETX_L389S       |
| 1          | Seq_rs1057519291                   | 17320323  | A  | G  | ATP13A2_T517I    |
| 1          | 1:11082457-C-A                     | 11082457  | A  | C  | TARDBP_Q331K     |
| 1          | Seq_rs80356727                     | 11082457  | A  | C  | TARDBP_Q331K     |
| 6          | Seq_rs201258663                    | 41129195  | A  | G  | TREM2_T66M       |
| 6          | Variant64110                       | 41129195  | A  | G  | TREM2_T66M       |
| 6          | rs201258663                        | 41129195  | A  | G  | TREM2_T66M       |
| 9          | 9:35065348-G-A                     | 35065348  | A  | G  |        VCP_R159H |
| 9          | Seq_rs121909335                    | 35065348  | A  | G  | VCP_R159H        |
| 9          | rs121909335                        | 35065348  | A  | G  | VCP_R159H        |
| 13         | 13:77566311-G-A                    | 77566311  | A  | G  | CLN5_W26X        |
| 13         | Seq_rs104894385.1_ilmnrev_ilmnF2BT | 77566311  | A  | G  | CLN5_W26X        |
| 13         | Seq_rs104894385.2_ilmnrev_ilmnF2BT | 77566311  | A  | C  | CLN5_W26X        |
| 3          | exm331440                          | 87289899  | G  | A  | CHMP2B_I29V      |
| 3          | rs63750818                         | 87289899  | G  | A  | CHMP2B_I29V      |
| 3          | seq_rs63750818                     | 87289899  | G  | A  | CHMP2B_I29V      |
| 4          | 4:90749321-G-A                     | 90749321  | A  | G  | SNCA_E46K        |
| 1          | 1:227071518-C-T                    | 227071518 | A  | G  | PSEN2_A85V       |
| 1          | Seq_rs63750048                     | 227071518 | A  | G  | PSEN2_A85V       |
| 1          | rs63750048                         | 227071518 | A  | G  | PSEN2_A85V       |
| 21         | 21:27264167-A-G                    | 27264167  | G  | A  | APP_E693G        |


```
cd /data/CARD/projects/INDI_genotypes/PHASE2_post_KOLF_selection/first_data_release_June_2021/plink/

module load plink
plink --bfile ibx_new_name --extract snps_of_interest_first_data.txt --recodeA --out VARIANT_investigation

```

## 2. Comparison with WGS

```
mkdir comparison_with_WGS
cd comparison_with_WGS

# first create dummy WGS file...

cd /data/CARD/projects/INDI_genotypes/PHASE1_pre_KOLF_selection/WGS
head -1 INDI_WGS_21_RS_only.fam  | cut -d " " -f 1,2 > KOLF_sample_name.txt

# make sample dummy file
cd /data/CARD/projects/INDI_genotypes/PHASE2_post_KOLF_selection/first_data_release_June_2021/plink
cut -d " " -f 2 ibx_new_name.fam | grep -v 2048424 > /data/CARD/projects/INDI_genotypes/PHASE1_pre_KOLF_selection/WGS/phase2_sampleIDs.txt

# NOW this times 284.... this will create multiple exact copies of the WGS data... so we can compare each clone with the same WGS data
cd /data/CARD/projects/INDI_genotypes/PHASE1_pre_KOLF_selection/WGS

module load plink
cat phase2_sampleIDs.txt | while read line
  do
  plink --bfile INDI_WGS_21_RS_only --make-bed --keep KOLF_sample_name.txt \
  --extract ../../PHASE2_post_KOLF_selection/first_data_release_June_2021/plink/ibx_new_name.bim  \
  --out INDI_WGS_NBA"$line" --keep-allele-order
done

# create update names file
scp phase2_sampleIDs.txt phase2_sampleIDs2.txt
printf "GT19-KOLF2.1 %.0s\n" {1..284} > KOLF_name1.txt
printf "GT19-KOLF2.1 %.0s\n" {1..284} > KOLF_name2.txt
paste KOLF_name1.txt KOLF_name2.txt phase2_sampleIDs.txt phase2_sampleIDs2.txt > update_names_phase2.txt

# update sample names
cat phase2_sampleIDs.txt  | while read line
do 
   grep "$line" update_names_phase2.txt > update_names.txt
   plink --bfile INDI_WGS_NBA"$line" --make-bed \
   --extract ../../PHASE2_post_KOLF_selection/first_data_release_June_2021/plink/ibx_new_name.bim \
   --update-ids update_names.txt --out INDI_WGS_NBA_to_merge"$line"
done


# make merge list
ls -lhS | grep "INDI_WGS_NBA_to_merge" | grep Jul | grep fam | cut -d " " -f 12 | sed 's/.fam//g' | grep merge > merge_list_phase2.txt
plink --merge-list merge_list_phase2.txt --make-bed --out WGS_data_format_OK
# 284 people, 483680 variants

scp WGS_data_format_OK.*  /data/CARD/projects/INDI_genotypes/PHASE2_post_KOLF_selection/first_data_release_June_2021/plink

----- GENOTYPES below

cd /data/CARD/projects/INDI_genotypes/PHASE2_post_KOLF_selection/first_data_release_June_2021/plink

grep 2048424 ibx_new_name.fam | cut -d " " -f 1,2 > remove.txt

plink --bfile ibx_new_name --make-bed --out ibx_new_name_v2 --remove remove.txt \
--extract WGS_data_format_OK.bim --mind 0.05

# 483680 variants and 280 people pass filters and QC.

# 4 samples removed...
ATP13A2_T517I_A01       ATP13A2_T517I_A01
APOE_C156R_A09  APOE_C156R_A09
PSEN2_A85V_A03  PSEN2_A85V_A03
PSEN2_A85V_A05  PSEN2_A85V_A05

----- Merging WGS with GENOTYPES below

# Plotting chromosomes to assess not matching regions

### first make sure sample IDs are the same because then if you merge them plink actually compares them
plink --bfile WGS_data_format_OK --keep ibx_new_name_v2.fam --make-bed --out WGS_to_merge
plink --bfile ibx_new_name_v2 --keep WGS_data_format_OK.fam --make-bed --out GENO_to_merge

# Then start merging with WGS
plink --bfile GENO_to_merge --bmerge WGS_to_merge --out merge1 --make-bed
# flip bad alleles not matching to WGS
plink --bfile GENO_to_merge --flip merge1-merge.missnp --make-bed --out GENO_to_merge2 
# merge again to check allele for allele flips
plink --bfile GENO_to_merge2 --bmerge WGS_to_merge --out merge2 --merge-mode 6 --make-bed
# remove variants that are bad + only keep samples of which WGS is present
plink --bfile GENO_to_merge2 --exclude merge2.missnp --out GENO_to_merge3 --make-bed
# make sure all samples are what they are supposed to be and all sample switches are corrected...
# FIRST PASS
plink --bfile GENO_to_merge3 --bmerge WGS_to_merge --out merge_NBA_INDI --merge-mode 7 --make-bed
# 483678 variants and 284 people pass filters and QC.
# this spits out this file -> merge_NBA_INDI.diff
# with header NEW = GENOMES OLD = NEUROCHIP
# SNP                  FID                  IID      NEW      OLD 
# then remove SNPs that are wrong in all lines
# first remove double space because plink has the inconvenient output with double spaces
sed -i 's/  / /g' merge_NBA_INDI.diff # need to do this x5
sed -i 's/  / /g' merge_NBA_INDI.diff # need to do this x5
sed -i 's/  / /g' merge_NBA_INDI.diff # need to do this x5
sed -i 's/  / /g' merge_NBA_INDI.diff # need to do this x5
sed -i 's/  / /g' merge_NBA_INDI.diff # need to do this x5
## this is the file with the times each variant is error
cut -d " " -f 2 merge_NBA_INDI.diff | sort | uniq -c | sort -nk1 > variant_failure_count.txt
# now create variant list to exclude because of too many mismatches and likely a problem variant
# set here at ~94 which is 33% based on N=284
awk '{if ($1 > 94) print $2;}' variant_failure_count.txt > variant_failure_count_EXCLUDE.txt
## this is the file with the times each SAMPLE is error
cut -d " " -f 3 merge_NBA_INDI.diff | sort | uniq -c | sort -nk1 > INDI_failure_count.txt

# SECOND PASS
# remove bad variants + samples with massive error rates if present...
plink --bfile GENO_to_merge3 --exclude variant_failure_count_EXCLUDE.txt --out GENO_to_merge4 --make-bed
# run merge again
plink --bfile GENO_to_merge4 --bmerge WGS_to_merge --out merge_NBA_INDI_v2 --merge-mode 7 --make-bed
sed -i 's/  / /g' merge_NBA_INDI_v2.diff # need to do this x5
sed -i 's/  / /g' merge_NBA_INDI_v2.diff # need to do this x5
sed -i 's/  / /g' merge_NBA_INDI_v2.diff # need to do this x5
sed -i 's/  / /g' merge_NBA_INDI_v2.diff # need to do this x5
sed -i 's/  / /g' merge_NBA_INDI_v2.diff # need to do this x5

# Then Running comparison plots for all chromosome based on the merge_NBA_INDI_v2.diff file

module load R
for chrnum in {1..23};
do
	Rscript --vanilla plot_differences_between_WGS_and_chip.R $chrnum
done


# DONE


```



## 3. Plot per sample

```
----- Step 1 -----
# prep data in correct format

cd /data/CARD/PD/ibx_data/gtc/

scp ibx_variant_metrics.txt /data/CARD/projects/INDI_genotypes/PHASE2_post_KOLF_selection/first_data_release_June_2021/CNV_data/

cd /data/CARD/projects/INDI_genotypes/PHASE2_post_KOLF_selection/first_data_release_June_2021/CNV_data/

header of file:
CHROM	POS	ID	REF	ALT	variable	metrics	GT	GQ	BAF	LRR

# cut out sampleIDs
cut -f 6 ibx_variant_metrics.txt | sort -u > unqiue_samples.txt
grep -v "variable" unqiue_samples.txt > unqiue_samplesv2.txt

# extract per sample data
cat unqiue_samplesv2.txt  | while read line
do 
   grep "$line" ibx_variant_metrics.txt > $line.txt
done

# add header...
head -1 ibx_variant_metrics.txt > header.txt
cat unqiue_samplesv2.txt  | while read line
do 
   cat header.txt $line.txt > $line.header.txt
done

# update sample names...

sh UPDATE_IBX_names_CNV.sh

# make a set of high quality variants
cd /data/CARD/PD/ibx_data/
cut -f 2,6 F4SEttehadieh_P1_Genotyping_Report.txt | awk '$2 > 0.8' | cut -f 1 \
> /data/CARD/projects/INDI_genotypes/PHASE2_post_KOLF_selection/first_data_release_June_2021/CNV_data/high_qual_NBA_variants_0point8_or_higher.txt 
# N= 1,451,932
cd /data/CARD/projects/INDI_genotypes/PHASE2_post_KOLF_selection/first_data_release_June_2021/CNV_data/

module load R
R
require("dplyr")
highqual <- read.table("high_qual_NBA_variants_0point8_or_higher.txt",header=T)
bim <- read.table("../plink/ibx_new_name.bim",header=F)
MM <- merge(bim, highqual, by.x="V2", by.y="Name")
MM$V3 <- NULL
MM$V5 <- NULL
MM$V6 <- NULL
names(MM)[1] <- "snpName"
names(MM)[2] <- "chromosome"
names(MM)[3] <- "position"
# remove a couple other problematic variants
# grep "\.\," *.csv > PROBLEM_VARIANTS.txt
# cut -d "," -f 4 PROBLEM_VARIANTS.txt | sort -u > problem_snps_v2.txt
problem <- read.table("problem_snps_v2.txt",header=F)
names(problem)[1] <- "snpName"
MM2 <- anti_join(MM, problem, by=c("snpName"))
# make sure all variants from CNV file are in there...
CNV_file <- read.csv("ANG_K41I_A04_17_D01.csv",header=T)
CNV_file_short <- CNV_file[c(1,2,4)]
CNV_file_short$chromosome <- NULL
CNV_file_short$position <- NULL
MM3 <- merge(MM2, CNV_file_short, by.x="snpName", by.y="snpName")
# sort and add row name
newdata <- MM3[order(MM3$chromosome, MM3$position),]
newdata2 <- subset(newdata, chromosome > 0 | position > 0)
newdata2$snpID <- seq.int(nrow(newdata2)) 
final <- newdata2[, c(4, 1, 2, 3)]
head(final)
# save...
write.table(final, file="anno_file_NBA_v2.txt",quote=F,row.names=F,sep="\t")

```

```
----- Step 2 -----

# DONE and ready for plot per chip
Need files

plot_per_chip.R => this is the R code that does the plotting
anno_file_NBA.txt => this is the annotation file needed for plotting but filtered for high quality variants
scan_file_to_use.txt => this is the "scan" file needed for plotting
scan_file.txt => this is the "scan" file needed for plotting

# how to start for one sample
module load R/3.6.1
Rscript --vanilla plot_per_chip.R ANG_K41I_A04_17_D01

# or to run all them all...
## make sample file
cut -d " " -f 3 UPDATE_IBX_names_CNV.sh | sed -e 's/.txt//g' > short_CNV_files_plot.txt

#!/bin/bash
# sbatch --cpus-per-task=20 --mem=240g --mail-type=END --time=21:00:00 RUN_DMC_ALL.sh
module load plink
module load R/3.6.1
# normal
cat short_CNV_files_plot.txt  | while read line
do 
	Rscript --vanilla plot_per_chip.R $line
done


```


## 4. Plot per gene of interest

```

cd /data/CARD/projects/INDI_genotypes/PHASE2_post_KOLF_selection/first_data_release_June_2021/CNV_data/


SNCB example
location: 5:176048219

ls | grep SNCB | grep csv > SNCB_list.txt

cat SNCB_list.txt  | while read line
do 
   awk -F, '$1 == 5' $line | awk -F, '$2 > 175998218' | awk -F, '$2 < 176098218' > short.$line.SNCB.txt
done
# note 176048218 is mutation basepair

mkdir SNCB
mv short.SNCB_P123H_* SNCB/
cd SNCB
# header = chromosome,position,snpID,snpName,Sample_ID,Allele1,Allele2,BAlleleFreq,LogRRatio

module load R
R
SNCB_P123H_B08_17_E01 <- read.csv("short.SNCB_P123H_B08_17_E01.csv.SNCB.txt",header=F)
SNCB_P123H_E08_17_E07 <- read.csv("short.SNCB_P123H_E08_17_E07.csv.SNCB.txt",header=F)
SNCB_P123H_C08_17_E02 <- read.csv("short.SNCB_P123H_C08_17_E02.csv.SNCB.txt",header=F)
SNCB_P123H_F04_17_E08 <- read.csv("short.SNCB_P123H_F04_17_E08.csv.SNCB.txt",header=F)
SNCB_P123H_C09_17_E03 <- read.csv("short.SNCB_P123H_C09_17_E03.csv.SNCB.txt",header=F)
SNCB_P123H_F10_17_E09 <- read.csv("short.SNCB_P123H_F10_17_E09.csv.SNCB.txt",header=F)
SNCB_P123H_D11_17_E04 <- read.csv("short.SNCB_P123H_D11_17_E04.csv.SNCB.txt",header=F)
SNCB_P123H_G01_17_E10 <- read.csv("short.SNCB_P123H_G01_17_E10.csv.SNCB.txt",header=F)
SNCB_P123H_E01_17_E05 <- read.csv("short.SNCB_P123H_E01_17_E05.csv.SNCB.txt",header=F)
SNCB_P123H_G07_17_E11 <- read.csv("short.SNCB_P123H_G07_17_E11.csv.SNCB.txt",header=F)
SNCB_P123H_E06_17_E06 <- read.csv("short.SNCB_P123H_E06_17_E06.csv.SNCB.txt",header=F)
SNCB_P123H_H11_17_E12 <- read.csv("short.SNCB_P123H_H11_17_E12.csv.SNCB.txt",header=F)

# now plot BAF
options(scipen=20)
pdf("BAF_SNCB.pdf",height=24, width=24)
par(mfrow=c(6,2))
plot(SNCB_P123H_B08_17_E01$V2,SNCB_P123H_B08_17_E01$V8,pch=20,ylab="B allele frequency",xlab="CHR 5 basepair",main="SNCB_P123H_B08_17_E01")
rect(xleft=176048218,xright = 176048219,ybottom=par("usr")[3], ytop=par("usr")[4], density=10, col = "blue")
abline(h=0.66, col="blue")
abline(h=0.33, col="blue")
abline(h=0.5, col="blue", lwd = 3)
grid()
plot(SNCB_P123H_E08_17_E07$V2,SNCB_P123H_E08_17_E07$V8,pch=20,ylab="B allele frequency",xlab="CHR 5 basepair",main="SNCB_P123H_E08_17_E07")
rect(xleft=176048218,xright = 176048219,ybottom=par("usr")[3], ytop=par("usr")[4], density=10, col = "blue")
abline(h=0.66, col="blue")
abline(h=0.33, col="blue")
abline(h=0.5, col="blue", lwd = 3)
grid()
plot(SNCB_P123H_C08_17_E02$V2,SNCB_P123H_C08_17_E02$V8,pch=20,ylab="B allele frequency",xlab="CHR 5 basepair",main="SNCB_P123H_C08_17_E02")
rect(xleft=176048218,xright = 176048219,ybottom=par("usr")[3], ytop=par("usr")[4], density=10, col = "blue")
abline(h=0.66, col="blue")
abline(h=0.33, col="blue")
abline(h=0.5, col="blue", lwd = 3)
grid()
plot(SNCB_P123H_F04_17_E08$V2,SNCB_P123H_F04_17_E08$V8,pch=20,ylab="B allele frequency",xlab="CHR 5 basepair",main="SNCB_P123H_F04_17_E08")
rect(xleft=176048218,xright = 176048219,ybottom=par("usr")[3], ytop=par("usr")[4], density=10, col = "blue")
abline(h=0.66, col="blue")
abline(h=0.33, col="blue")
abline(h=0.5, col="blue", lwd = 3)
grid()
plot(SNCB_P123H_C09_17_E03$V2,SNCB_P123H_C09_17_E03$V8,pch=20,ylab="B allele frequency",xlab="CHR 5 basepair",main="SNCB_P123H_C09_17_E03")
rect(xleft=176048218,xright = 176048219,ybottom=par("usr")[3], ytop=par("usr")[4], density=10, col = "blue")
abline(h=0.66, col="blue")
abline(h=0.33, col="blue")
abline(h=0.5, col="blue", lwd = 3)
grid()
plot(SNCB_P123H_F10_17_E09$V2,SNCB_P123H_F10_17_E09$V8,pch=20,ylab="B allele frequency",xlab="CHR 5 basepair",main="SNCB_P123H_F10_17_E09")
rect(xleft=176048218,xright = 176048219,ybottom=par("usr")[3], ytop=par("usr")[4], density=10, col = "blue")
abline(h=0.66, col="blue")
abline(h=0.33, col="blue")
abline(h=0.5, col="blue", lwd = 3)
grid()
plot(SNCB_P123H_D11_17_E04$V2,SNCB_P123H_D11_17_E04$V8,pch=20,ylab="B allele frequency",xlab="CHR 5 basepair",main="SNCB_P123H_D11_17_E04")
rect(xleft=176048218,xright = 176048219,ybottom=par("usr")[3], ytop=par("usr")[4], density=10, col = "blue")
abline(h=0.66, col="blue")
abline(h=0.33, col="blue")
abline(h=0.5, col="blue", lwd = 3)
grid()
plot(SNCB_P123H_G01_17_E10$V2,SNCB_P123H_G01_17_E10$V8,pch=20,ylab="B allele frequency",xlab="CHR 5 basepair",main="SNCB_P123H_G01_17_E10")
rect(xleft=176048218,xright = 176048219,ybottom=par("usr")[3], ytop=par("usr")[4], density=10, col = "blue")
abline(h=0.66, col="blue")
abline(h=0.33, col="blue")
abline(h=0.5, col="blue", lwd = 3)
grid()
plot(SNCB_P123H_E01_17_E05$V2,SNCB_P123H_E01_17_E05$V8,pch=20,ylab="B allele frequency",xlab="CHR 5 basepair",main="SNCB_P123H_E01_17_E05")
rect(xleft=176048218,xright = 176048219,ybottom=par("usr")[3], ytop=par("usr")[4], density=10, col = "blue")
abline(h=0.66, col="blue")
abline(h=0.33, col="blue")
abline(h=0.5, col="blue", lwd = 3)
grid()
plot(SNCB_P123H_G07_17_E11$V2,SNCB_P123H_G07_17_E11$V8,pch=20,ylab="B allele frequency",xlab="CHR 5 basepair",main="SNCB_P123H_G07_17_E11")
rect(xleft=176048218,xright = 176048219,ybottom=par("usr")[3], ytop=par("usr")[4], density=10, col = "blue")
abline(h=0.66, col="blue")
abline(h=0.33, col="blue")
abline(h=0.5, col="blue", lwd = 3)
grid()
plot(SNCB_P123H_E06_17_E06$V2,SNCB_P123H_E06_17_E06$V8,pch=20,ylab="B allele frequency",xlab="CHR 5 basepair",main="SNCB_P123H_E06_17_E06")
rect(xleft=176048218,xright = 176048219,ybottom=par("usr")[3], ytop=par("usr")[4], density=10, col = "blue")
abline(h=0.66, col="blue")
abline(h=0.33, col="blue")
abline(h=0.5, col="blue", lwd = 3)
grid()
plot(SNCB_P123H_H11_17_E12$V2,SNCB_P123H_H11_17_E12$V8,pch=20,ylab="B allele frequency",xlab="CHR 5 basepair",main="SNCB_P123H_H11_17_E12")
rect(xleft=176048218,xright = 176048219,ybottom=par("usr")[3], ytop=par("usr")[4], density=10, col = "blue")
abline(h=0.66, col="blue")
abline(h=0.33, col="blue")
abline(h=0.5, col="blue", lwd = 3)
grid()
dev.off()


# now plot LRR
options(scipen=20)
pdf("LRR_SNCB.pdf",height=24, width=24)
par(mfrow=c(6,2))
plot(SNCB_P123H_B08_17_E01$V2,SNCB_P123H_B08_17_E01$V9,pch=20,ylab="Log R ratio",xlab="CHR 5 basepair",main="SNCB_P123H_B08_17_E01")
rect(xleft=176048218,xright = 176048219,ybottom=par("usr")[3], ytop=par("usr")[4], density=10, col = "blue")
abline(h=0, col="blue")
grid()
plot(SNCB_P123H_E08_17_E07$V2,SNCB_P123H_E08_17_E07$V9,pch=20,ylab="Log R ratio",xlab="CHR 5 basepair",main="SNCB_P123H_E08_17_E07")
rect(xleft=176048218,xright = 176048219,ybottom=par("usr")[3], ytop=par("usr")[4], density=10, col = "blue")
abline(h=0, col="blue")
grid()
plot(SNCB_P123H_C08_17_E02$V2,SNCB_P123H_C08_17_E02$V9,pch=20,ylab="Log R ratio",xlab="CHR 5 basepair",main="SNCB_P123H_C08_17_E02")
rect(xleft=176048218,xright = 176048219,ybottom=par("usr")[3], ytop=par("usr")[4], density=10, col = "blue")
abline(h=0, col="blue")
grid()
plot(SNCB_P123H_F04_17_E08$V2,SNCB_P123H_F04_17_E08$V9,pch=20,ylab="Log R ratio",xlab="CHR 5 basepair",main="SNCB_P123H_F04_17_E08")
rect(xleft=176048218,xright = 176048219,ybottom=par("usr")[3], ytop=par("usr")[4], density=10, col = "blue")
abline(h=0, col="blue")
grid()
plot(SNCB_P123H_C09_17_E03$V2,SNCB_P123H_C09_17_E03$V9,pch=20,ylab="Log R ratio",xlab="CHR 5 basepair",main="SNCB_P123H_C09_17_E03")
rect(xleft=176048218,xright = 176048219,ybottom=par("usr")[3], ytop=par("usr")[4], density=10, col = "blue")
abline(h=0, col="blue")
grid()
plot(SNCB_P123H_F10_17_E09$V2,SNCB_P123H_F10_17_E09$V9,pch=20,ylab="Log R ratio",xlab="CHR 5 basepair",main="SNCB_P123H_F10_17_E09")
rect(xleft=176048218,xright = 176048219,ybottom=par("usr")[3], ytop=par("usr")[4], density=10, col = "blue")
abline(h=0, col="blue")
grid()
plot(SNCB_P123H_D11_17_E04$V2,SNCB_P123H_D11_17_E04$V9,pch=20,ylab="Log R ratio",xlab="CHR 5 basepair",main="SNCB_P123H_D11_17_E04")
rect(xleft=176048218,xright = 176048219,ybottom=par("usr")[3], ytop=par("usr")[4], density=10, col = "blue")
abline(h=0, col="blue")
grid()
plot(SNCB_P123H_G01_17_E10$V2,SNCB_P123H_G01_17_E10$V9,pch=20,ylab="Log R ratio",xlab="CHR 5 basepair",main="SNCB_P123H_G01_17_E10")
rect(xleft=176048218,xright = 176048219,ybottom=par("usr")[3], ytop=par("usr")[4], density=10, col = "blue")
abline(h=0, col="blue")
grid()
plot(SNCB_P123H_E01_17_E05$V2,SNCB_P123H_E01_17_E05$V9,pch=20,ylab="Log R ratio",xlab="CHR 5 basepair",main="SNCB_P123H_E01_17_E05")
rect(xleft=176048218,xright = 176048219,ybottom=par("usr")[3], ytop=par("usr")[4], density=10, col = "blue")
abline(h=0, col="blue")
grid()
plot(SNCB_P123H_G07_17_E11$V2,SNCB_P123H_G07_17_E11$V9,pch=20,ylab="Log R ratio",xlab="CHR 5 basepair",main="SNCB_P123H_G07_17_E11")
rect(xleft=176048218,xright = 176048219,ybottom=par("usr")[3], ytop=par("usr")[4], density=10, col = "blue")
abline(h=0, col="blue")
grid()
plot(SNCB_P123H_E06_17_E06$V2,SNCB_P123H_E06_17_E06$V9,pch=20,ylab="Log R ratio",xlab="CHR 5 basepair",main="SNCB_P123H_E06_17_E06")
rect(xleft=176048218,xright = 176048219,ybottom=par("usr")[3], ytop=par("usr")[4], density=10, col = "blue")
abline(h=0, col="blue")
grid()
plot(SNCB_P123H_H11_17_E12$V2,SNCB_P123H_H11_17_E12$V9,pch=20,ylab="Log R ratio",xlab="CHR 5 basepair",main="SNCB_P123H_H11_17_E12")
rect(xleft=176048218,xright = 176048219,ybottom=par("usr")[3], ytop=par("usr")[4], density=10, col = "blue")
abline(h=0, col="blue")
grid()
dev.off()



