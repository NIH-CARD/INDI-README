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

contains:
F4SEttehadieh_P1_Genotyping_Report.txt => full report 
F4SEttehadieh_P1_QC_Report.xlsx => QC metrics
Raw_Data/ => with 192 .idats 

- plink files => in folder plink
ibx.bed  ibx.bim	ibx.fam  ibx.log

these are files from Dan, note general plink files + NOTE has to be clustered with other data since the Illumina algorithm needs some more diversity

minor follow-up change => update the names of the plink files....

module load plink
sed -e 's/FUS_R495\*_/FUS_R495X_/g' UPDATE_IBX_names.txt > UPDATE_IBX_namesv2.txt

plink --bfile ibx --update-ids UPDATE_IBX_namesv2.txt --make-bed --out ibx_new_name


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
cut -d " " -f 1 ibx_new_name.fam | grep -v "DELETE" > /data/CARD/projects/INDI_genotypes/PHASE1_pre_KOLF_selection/WGS/phase2_sampleIDs.txt

# NOW this times 95.... this will create multiple exact copies of the WGS data... so we can compare each clone with the same WGS data
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
printf "GT19-KOLF2.1 %.0s\n" {1..95} > KOLF_name1.txt
printf "GT19-KOLF2.1 %.0s\n" {1..95} > KOLF_name2.txt
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
ls | grep "INDI_WGS_NBA_to_merge" | grep fam | sed 's/.fam//g' | grep merge > merge_list_phase2.txt
plink --merge-list merge_list_phase2.txt --make-bed --out WGS_data_format_OK
# 483680 variants and 95 people pass filters and QC.

scp WGS_data_format_OK.*  /data/CARD/projects/INDI_genotypes/PHASE2_post_KOLF_selection/first_data_release_June_2021/plink

----- GENOTYPES below

cd /data/CARD/projects/INDI_genotypes/PHASE2_post_KOLF_selection/first_data_release_June_2021/plink

grep DELETE ibx_new_name.fam | cut -d " " -f 1,2 > remove.txt

plink --bfile ibx_new_name --make-bed --out ibx_new_name_v2 --remove remove.txt \
--extract WGS_data_format_OK.bim

# 483680 variants and 95 people pass filters and QC.

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
# 483678 variants and 95 people pass filters and QC.
# this spits out this file -> merge_NBA_INDI.diff
# with header NEW = GENOMES OLD = NEUROCHIP
# SNP                  FID                  IID      NEW      OLD 
# then remove SNPs that are wrong in all lines
# first remove double space because plink has the inconvenient output with double spaces
sed -i 's/  / /g' merge_NBA_INDI.diff # need to do this x5
## this is the file with the times each variant is error
cut -d " " -f 2 merge_NBA_INDI.diff | sort | uniq -c | sort -nk1 > variant_failure_count.txt
# now create variant list to exclude because of too many mismatches and likely a problem variant
# set here at ~31 which is 33% based on N=95
awk '{if ($1 > 31) print $2;}' variant_failure_count.txt > variant_failure_count_EXCLUDE.txt
## this is the file with the times each SAMPLE is error
cut -d " " -f 3 merge_NBA_INDI.diff | sort | uniq -c | sort -nk1 > INDI_failure_count.txt

# SECOND PASS
# remove bad variants + samples with massive error rates if present...
plink --bfile GENO_to_merge3 --exclude variant_failure_count_EXCLUDE.txt --out GENO_to_merge4 --make-bed
# run merge again
plink --bfile GENO_to_merge4 --bmerge WGS_to_merge --out merge_NBA_INDI_v2 --merge-mode 7 --make-bed
sed -i 's/  / /g' merge_NeuroChip_INDI_v2.diff # need to do this x5

# Then Running comparison plots for all chromosome based on the merge_NBA_INDI_v2.diff file

module load R
for chrnum in {1..23};
do
	Rscript --vanilla plot_differences_between_WGS_and_chip.R $chrnum
done


# DONE


```



## 3. Plot per sample






