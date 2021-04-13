### Goal is to assess potential genetic differences between WGS and genotyping array data


### using WGS and genotyping array data


```
###### INDI genotypes vs WGS data
#
# March 27th 2021 
# Cornelis

----- WGS below

# main goal here is to reformat the WGS, only keep rs-ids to make life easy and to rename the files the same way as the genotype data so we merge easily and use merge-mode function in plink.

# download WGS data from GCP
cd /data/CARD/projects/INDI_genotypes/WGS/

2001UNHS-0021_hg38_genotypes_UNHS.vcf
2001UNHS-0021_hg38_genotypes_UNHS.vcf.gz.tbi

module load plink
# move to plink format and update names to real INDI IDs
plink --vcf 2001UNHS-0021_hg38_genotypes_UNHS.vcf.gz --biallelic-only strict --snps-only \
--geno 0.05 --mac 1 --out INDI_WGS_21 --make-bed --update-ids update_names_WGS_to_INDI.txt
# 6955458 variants and 9 people pass filters and QC.

# keeping only rs-ids
grep "rs" INDI_WGS_21.bim | cut -f 2 > rs_variants_21.txt
plink --bfile INDI_WGS_21 --make-bed --extract rs_variants_21.txt --out INDI_WGS_21_RS_only \
--remove remove.txt 
# 6592399 variants and 8 people pass filters and QC.

# NOW this times 24.... this will create multiple exact copies of the WGS data... so we can compare each clone with the same WGS data
cat SAMPLE_ID2.txt  | while read line
  do
  plink --bfile INDI_WGS_21_RS_only --make-bed --extract ../PLINK/GENO.bim --out INDI_WGS_NEUROCHIP"$line"
done

# update sample names
cat SAMPLE_ID2.txt  | while read line
do 
   grep "$line" SAMPLE_IDv2.txt > update_names.txt
   plink --bfile INDI_WGS_NEUROCHIP"$line" --make-bed --extract ../PLINK/GENO.bim \
   --update-ids update_names.txt --out INDI_WGS_NEUROCHIP_to_merge"$line"
done

# make merge list
ls | grep "X.fam" | sed 's/.fam//g' | grep merge > merge_list.txt
plink --merge-list merge_list.txt --make-bed --out try1
# 254303 variants and 189 people pass filters and QC.

----- GENOTYPES below

# download plink files from TeamDrive CARD
# main goal here is to make sure the IDs are the in the same format as the WGS
path: line-checker-mike
cd /data/CARD/projects/INDI_genotypes/PLINK/

plink --file test_chip_genos --make-bed --out GENO

grep BAK GENO.fam | cut -d " " -f 1,2 > remove.txt

plink --bfile GENO --make-bed --out GENO_v2 --remove remove.txt
# 487374 variants and 185 people pass filters and QC.

plink --bfile GENO_v2 --make-bed --out GENO_v3 --update-ids update_namesv2.txt

----- Merging WGS with GENOTYPES below

# Plotting chromosomes to assess not matching regions

# make plot comparing large regions of mismatches between WGS and day0
### first make sure sample IDs are the same because then if you merge them plink actually compares them
plink --bfile ../WGS/try1 --keep GENO_v3.fam --make-bed --out WGS_to_merge
plink --bfile GENO_v3 --keep WGS_to_merge.fam --make-bed --out GENO_to_merge

# Then start merging with WGS
plink --bfile GENO_to_merge --bmerge WGS_to_merge --out merge1 --make-bed
# 185 people to be merged from WGS_to_merge.fam.
# Of these, 0 are new, while 185 are present in the base dataset.
# flip bad alleles not matching to WGS
plink --bfile GENO_to_merge --flip merge1-merge.missnp --make-bed --out GENO_to_merge2 
# merge again to check allele for allele flips
plink --bfile GENO_to_merge2 --bmerge WGS_to_merge --out merge2 --merge-mode 6 --make-bed
# remove variants that are bad + only keep samples of which WGS is present
plink --bfile GENO_to_merge2 --exclude merge2.missnp --out GENO_to_merge3 --make-bed
# make sure all samples are what they are supposed to be and all sample switches are corrected...
# for example corrections can be:
sed -i 's/XXXXXX/temp/g' FOUNDIN_plink_day0only3.fam 
sed -i 's/XXXXXX/temp2/g' FOUNDIN_plink_day0only3.fam
sed -i 's/temp/XXXXXX/g' FOUNDIN_plink_day0only3.fam 
sed -i 's/temp2/XXXXXX/g' FOUNDIN_plink_day0only3.fam
# then do final merge
# 7 (no merge) Report mismatching nonmissing calls.
# FIRST PASS
plink --bfile GENO_to_merge3 --bmerge WGS_to_merge --out merge_NeuroChip_INDI --merge-mode 7 --make-bed
# 486745 variants and 126 people pass filters and QC.
# this spits out this file -> merge_NeuroX_PPMI_snplis.diff
# with header NEW = GENOMES OLD = NEUROCHIP
# SNP                  FID                  IID      NEW      OLD 
# then remove SNPs that are wrong in all lines
# first remove double space because plink has the inconvenient output with double spaces
sed -i 's/  / /g' merge_NeuroChip_INDI.diff # need to do this x5
## this is the file with the times each variant is error
cut -d " " -f 2 merge_NeuroChip_INDI.diff | sort | uniq -c | sort -nk1 > variant_failure_count.txt
# now create variant list to exclude because of too many mismatches and likely a problem variant
# set here at 61 which is 33% based on N=185
awk '{if ($1 > 61) print $2;}' variant_failure_count.txt > variant_failure_count_EXCLUDE.txt
## this is the file with the times each SAMPLE is error
cut -d " " -f 3 merge_NeuroChip_INDI.diff | sort | uniq -c | sort -nk1 > INDI_failure_count.txt
# most mismatches found N=138087 for this sample: PPMISI53423, but known problem with donor WGS so all good.

# SECOND PASS
# remove bad variants + samples with massive error rates if present...
plink --bfile GENO_to_merge3 --exclude variant_failure_count_EXCLUDE.txt --out GENO_to_merge4 --make-bed
# run merge again
plink --bfile GENO_to_merge4 --bmerge WGS_to_merge --out merge_NeuroChip_INDI_v2 --merge-mode 7 --make-bed
sed -i 's/  / /g' merge_NeuroChip_INDI_v2.diff # need to do this x5

# Then Running comparison plots for all chromosome based on the merge_NeuroChip_PPMI_snplis_V2.diff file

module load R
for chrnum in {1..22};
do
	Rscript --vanilla plot_differences_between_WGS_and_chip.R $chrnum
done


# DONE
```

### results

```
problems in all chromosomes: 
GT19−NN0004297_12X => 84	Cookson_Skarnes_IPSC_Plate1_D11

chr 12 issues:	

GT19−KUCG3_13X => 157	Cookson_Skarnes_IPSC_Plate2_E8
GT19−KUCG3_5X => 149	Cookson_Skarnes_IPSC_Plate2_E7

chr 20 issues:	

GT19−KUCG3_9X  => 153	Cookson_Skarnes_IPSC_Plate2_A8
GT19−KUCG3_17X => 161	Cookson_Skarnes_IPSC_Plate2_A9

chr 22 issues:

GT19−PGP1_13X  => 13	Cookson_Skarnes_IPSC_Plate1_E2
GT19−NN0003932_12X  => 36	Cookson_Skarnes_IPSC_Plate1_D5
GT19−NCRM1_5X  => 53	Cookson_Skarnes_IPSC_Plate1_E7
GT19−KUCG3_7X  => 151	Cookson_Skarnes_IPSC_Plate2_G7
GT19−KOLF2.1_5X  => 173	Cookson_Skarnes_IPSC_Plate2_E10
GT19−KOLF2.1_1X => 169	Cookson_Skarnes_IPSC_Plate2_A10
```





