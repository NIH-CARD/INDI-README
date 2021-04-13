### Goal is to assess genetic risk profile of INDI lines


### using genetic risk weights from

PD => Nalls et al 2019 excluding UKBiobank data (PMID: [31701892](https://pubmed.ncbi.nlm.nih.gov/31701892/))

AD => Kunkle et al 2019 (PMID: [30820047](https://pubmed.ncbi.nlm.nih.gov/30820047/))



### subsetting data

```
cd /data/CARD/projects/INDI_genotypes/WGS/
module load plink
# convert from vcf to plink
plink --biallelic-only strict --make-bed \
--out INDI_WGS --snps-only --vcf 2001UNHS-0021_hg38_genotypes_UNHS.vcf
# problem with variant names so only keep rs-ids
grep "rs" INDI_WGS.bim > rs_variants_only.txt
plink --bfile INDI_WGS --extract rs_variants_only.txt --make-bed --out INDI_WGS_RS_only

```

### check APOE status and TMEM106B status

##### APOE

```
module load plink
plink --bfile INDI_WGS_RS_only --snps rs429358,rs7412 --out APOE --recodeA
```

For more details check here https://www.snpedia.com/index.php/APOE
There are three relatively common allelic variants of ApoE, as defined by two SNPs, rs429358 and rs7412 known as ApoE-ε2, ApoE-ε3, and ApoE-ε4. 

| WGS_ID     | Line_ID            | rs429358_C | rs7412_T | APOE genotype |
|------------|----------------|------------|----------|-------|
| GT19-38445 | KOLF2-ARID2_A2 | 0          | 0        | E3/E3 |
| GT19-38446 | KUCG3-C1       | 0          | 0        | E3/E3 |
| GT19-38447 | NCRM1-C6       | 1          | 0        | E4/E3 |
| GT19-38448 | NCRM5-C5       | 1          | 0        | E4/E3 |
| GT19-38449 | PGP1-C2        | 0          | 0        | E3/E3 |
| GT19-38450 | LNGPI1-C1      | 0          | 0        | E3/E3 |
| GT19-38451 | NN0003932-C3   | 0          | 0        | E3/E3 |
| GT19-38452 | NN0004297-C1   | 0          | 0        | E3/E3 |


##### TMEM106B

```
module load plink
plink --bfile INDI_WGS_RS_only --snp rs3173615 --out TMEM106B --recodeA
```

For more details check here https://www.snpedia.com/index.php/Rs3173615
The rs3173615(C) allele encodes a threonine (Thr) at codon 185 of the TMEM106B protein; the rs3173615(G) allele encodes a serine (Ser) at this codon. Both alleles are relatively common, varying between populations.

Below Table is the number of G alleles...

| WGS_ID     | Line_ID        | rs3173615_G |
|------------|----------------|-------------|
| GT19-38445 | KOLF2-ARID2_A2 | 1           |
| GT19-38446 | KUCG3-C1       | 0           |
| GT19-38447 | NCRM1-C6       | 1           |
| GT19-38448 | NCRM5-C5       | 1           |
| GT19-38449 | PGP1-C2        | 1           |
| GT19-38450 | LNGPI1-C1      | 1           |
| GT19-38451 | NN0003932-C3   | 0           |
| GT19-38452 | NN0004297-C1   | 0           |

##### MAPT haplotype

```
module load plink
plink --bfile INDI_WGS_RS_only --snp rs1800547 --out MAPT --recodeA
```

For more details check here https://www.snpedia.com/index.php/MAPT
An example of a SNP defining H1-H2 haplotypes is rs1800547; the rs1800547(A) allele is associated with the H1 haplotype, whereas the rs1800547(G) allele defines the H2 haplotype.

Below Table is the number of G alleles...

| WGS_ID     | Line_I         | rs1800547_G | MAPT_haplo |
|------------|----------------|-------------|------------|
| GT19-38445 | KOLF2-ARID2_A2 | 0           | H1/H1      |
| GT19-38446 | KUCG3-C1       | 0           | H1/H1      |
| GT19-38447 | NCRM1-C6       | 1           | H2/H1      |
| GT19-38448 | NCRM5-C5       | 0           | H1/H1      |
| GT19-38449 | PGP1-C2        | 2           | H2/H2      |
| GT19-38450 | LNGPI1-C1      | 0           | H1/H1      |
| GT19-38451 | NN0003932-C3   | 1           | H2/H1      |
| GT19-38452 | NN0004297-C1   | 1           | H2/H1      |



### check genetic risk scores of AD and PD
#### NOTE this is pass 1 out of 2...
#### pass 1 is under the assumption that missing variants from WGS are really missing!

```
First assess how many variants are actually present here...

### AD
plink --bfile INDI_WGS_RS_only \
      --extract /data/CARD/GENERAL/AD_GRS_Kunkle.txt \
      --out AD_GRS_only --make-bed
# 18 variants meaning 3 missing
missing are:
rs75932628 => TREM2 R47H 
rs10808026 => EPHA1 : Intron Variant
rs17125924 => FERMT2 : Intron Variant

### PD
plink --bfile INDI_WGS_RS_only \
      --extract /data/CARD/GENERAL/META5_no_UKBB_GRS.txt \
      --out PD_GRS_only --make-bed
# 75 variants meaning 15 missing
missing are:
rs114138760 => GBA region
rs35749011 => GBA region
rs76763715 => GBA region
rs11557080 => RAB29 locus
rs10797576 => SIPA1L2 locus
rs76116224 => KCNS3 locus
rs1474055 => STK39 locus
rs73038319 => SATB1 locus
rs1867598 => ELOVL7 locus
rs504594 => HLA locus
rs75859381 => RPS12 locus
rs76949143 => GS1-124K5.11 locus
rs117896735 => INPP5F locus
rs34637584 => LRRK2 locus
rs186111791 => CNTN1 locus
rs200564078 => CNOT1 locus
rs61169879 => BRIP1 locus

```

```
### AD:
#Then merge with reference set from UK Biobank

plink --bfile AD_GRS_only --bmerge /data/CARD/UKBIOBANK/GENETIC_RISK_SCORE/AD_GRS_ONLY/UKB.IMPUTED.PRS_AD_KUNKLE_only \
--extract AD_GRS_only.bim --out INDI_UKB_ALL_AD --make-bed

#Then score
plink --bfile INDI_UKB_ALL_AD \
      --score /data/CARD/GENERAL/AD_GRS_Kunkle.txt \
      --out AD_UKB_INDI

### PD:
#Then merge with reference set from UK Biobank

plink --bfile PD_GRS_only --bmerge /data/CARD/UKBIOBANK/GENETIC_RISK_SCORE/PD_GRS_ONLY/PD_GRS_UKBB_EURO_only_temp \
--extract PD_GRS_only.bim --out INDI_UKB_ALL_PD --make-bed

#Then score
plink --bfile INDI_UKB_ALL_PD \
      --score /data/CARD/GENERAL/META5_no_UKBB_GRS.txt \
      --out PD_UKB_INDI

```

```
# extract cases and controls....
cd /data/CARD/projects/INDI_genotypes/WGS/

module load R
R
require("dplyr")
require("ggplot2")
PD <- read.table("/data/CARD/UKBIOBANK/PHENOTYPE_DATA/disease_groups_NEW_2021/parkinson_disease_plink.txt",header=F)
AD <- read.table("/data/CARD/UKBIOBANK/PHENOTYPE_DATA/disease_groups_NEW_2021/alzheimer_disease_plink.txt",header=T)
INDI <- read.table("INDI_WGS_RS_only.fam",header=F)
AD_score <- read.table("AD_UKB_INDI.profile",header=T)
PD_score <- read.table("PD_UKB_INDI.profile",header=T)
controls <- read.table("/data/CARD/UKBIOBANK/ALL_NDD_FREE_CONTROLS_AGE60PLUS.txt",header=T)
# some munging
PD$V2 <- NULL
AD$eid.1 <- NULL
names(PD)[1] <- "FID"
names(AD)[1] <- "FID"
INDI_short <- INDI %>% select(1)
names(INDI_short)[1] <- "FID"
AD_score_short <- AD_score %>% select(1, 6)
PD_score_short <- PD_score %>% select(1, 6)
names(AD_score_short)[2] <- "AD_score"
names(PD_score_short)[2] <- "PD_score"
scores <- merge(AD_score_short,PD_score_short,by="FID")
controls_short <- controls %>% select(1, 8)
controls_short$EUROPEAN <- NULL
# add in phenotypes...
PD2 <- merge(PD,scores,by="FID")
AD2 <- merge(AD,scores,by="FID")
INDI2 <- merge(INDI_short,scores,by="FID")
controls_short2 <- merge(controls_short,scores,by="FID")
PD2$PHENO <- "PD"
AD2$PHENO <- "AD"
INDI2$PHENO <- "INDI"
controls_short2$PHENO <- "CONTROL"
big_merge <- rbind(AD2,PD2,controls_short2,INDI2)
# removing row from INDI files "NIST-reference-sample"
big_mergev2 <- big_merge[-c(101556), ] 
write.table(big_mergev2,file="INDI_WGS_WITH_UKB_AD_PD_CONTROLS.txt",quote=FALSE,row.names=F,sep="\t")

# some plotting
# changing INDI to ZINDI to change order of plotting
big_mergev2$PHENO <- gsub('INDI', 'zINDI', big_mergev2$PHENO)
# convert to Z
meanGRS <- mean(big_mergev2$AD_score)
sdGRS <- sd(big_mergev2$AD_score)
big_mergev2$AD_score_Z <- (big_mergev2$AD_score - meanGRS)/sdGRS
meanGRS <- mean(big_mergev2$PD_score)
sdGRS <- sd(big_mergev2$PD_score)
big_mergev2$PD_score_Z <- (big_mergev2$PD_score - meanGRS)/sdGRS


# final plotting
### AD
p <- ggplot(big_mergev2, aes(x=PHENO, y=AD_score_Z)) + 
  geom_violin(fill="gray")
p + geom_boxplot(width=0.1) + scale_fill_grey() + theme_light() 
ggsave("AD_with_nojitter.png")

p <- ggplot(big_mergev2, aes(x=PHENO, y=AD_score_Z)) + 
  geom_jitter(position=position_jitter(0.2))
p + theme_light()
ggsave("AD_with_jitter.png")

### PD
p <- ggplot(big_mergev2, aes(x=PHENO, y=PD_score_Z)) + 
  geom_violin(fill="gray")
p + geom_boxplot(width=0.1) + scale_fill_grey() + theme_light() 
ggsave("PD_with_nojitter.png")

p <- ggplot(big_mergev2, aes(x=PHENO, y=PD_score_Z)) + 
  geom_jitter(position=position_jitter(0.2))
p + theme_light()
ggsave("PD_with_jitter.png")


```


### check genetic risk scores of AD and PD
#### NOTE this is pass 2 out of 2...
#### pass 2 is under the assumption that missing variants are homozygous reference!

```
First assess how many variants are actually present here...

### AD
plink --bfile INDI_WGS_RS_only \
      --extract /data/CARD/GENERAL/AD_GRS_Kunkle.txt \
      --out AD_GRS_only --make-bed
# 18 variants meaning 3 missing
missing are:
rs75932628 => TREM2 R47H 
rs10808026 => EPHA1 : Intron Variant
rs17125924 => FERMT2 : Intron Variant

### PD
plink --bfile INDI_WGS_RS_only \
      --extract /data/CARD/GENERAL/META5_no_UKBB_GRS.txt \
      --out PD_GRS_only --make-bed
# 75 variants meaning 15 missing
missing are:
rs114138760 => GBA region
rs35749011 => GBA region
rs76763715 => GBA region
rs11557080 => RAB29 locus
rs10797576 => SIPA1L2 locus
rs76116224 => KCNS3 locus
rs1474055 => STK39 locus
rs73038319 => SATB1 locus
rs1867598 => ELOVL7 locus
rs504594 => HLA locus
rs75859381 => RPS12 locus
rs76949143 => GS1-124K5.11 locus
rs117896735 => INPP5F locus
rs34637584 => LRRK2 locus
rs186111791 => CNTN1 locus
rs200564078 => CNOT1 locus
rs61169879 => BRIP1 locus

```

```
### AD:
#Then merge with reference set from UK Biobank

plink --bfile AD_GRS_only --bmerge /data/CARD/UKBIOBANK/GENETIC_RISK_SCORE/AD_GRS_ONLY/UKB.IMPUTED.PRS_AD_KUNKLE_only \
--out INDI_UKB_ALL_AD2 --make-bed

#Then score
plink --bfile INDI_UKB_ALL_AD2 \
      --score /data/CARD/GENERAL/AD_GRS_Kunkle.txt \
      --out AD_UKB_INDI2

### PD:
#Then merge with reference set from UK Biobank

plink --bfile PD_GRS_only --bmerge /data/CARD/UKBIOBANK/GENETIC_RISK_SCORE/PD_GRS_ONLY/PD_GRS_UKBB_EURO_only_temp \
--out INDI_UKB_ALL_PD2 --make-bed

#Then score
plink --bfile INDI_UKB_ALL_PD2 \
      --score /data/CARD/GENERAL/META5_no_UKBB_GRS.txt \
      --out PD_UKB_INDI2

```

Edit the figures in powerpoint (sorry GitHub) and add INDI annotation to it....






```
# extract cases and controls....
cd /data/CARD/projects/INDI_genotypes/WGS/

module load R
R
require("dplyr")
require("ggplot2")
PD <- read.table("/data/CARD/UKBIOBANK/PHENOTYPE_DATA/disease_groups_NEW_2021/parkinson_disease_plink.txt",header=F)
AD <- read.table("/data/CARD/UKBIOBANK/PHENOTYPE_DATA/disease_groups_NEW_2021/alzheimer_disease_plink.txt",header=T)
INDI <- read.table("INDI_WGS_RS_only.fam",header=F)
AD_score <- read.table("AD_UKB_INDI2.profile",header=T)
PD_score <- read.table("PD_UKB_INDI2.profile",header=T)
controls <- read.table("/data/CARD/UKBIOBANK/ALL_NDD_FREE_CONTROLS_AGE60PLUS.txt",header=T)
# some munging
PD$V2 <- NULL
AD$eid.1 <- NULL
names(PD)[1] <- "FID"
names(AD)[1] <- "FID"
INDI_short <- INDI %>% select(1)
names(INDI_short)[1] <- "FID"
AD_score_short <- AD_score %>% select(1, 6)
PD_score_short <- PD_score %>% select(1, 6)
names(AD_score_short)[2] <- "AD_score"
names(PD_score_short)[2] <- "PD_score"
scores <- merge(AD_score_short,PD_score_short,by="FID")
controls_short <- controls %>% select(1, 8)
controls_short$EUROPEAN <- NULL
# add in phenotypes...
PD2 <- merge(PD,scores,by="FID")
AD2 <- merge(AD,scores,by="FID")
INDI2 <- merge(INDI_short,scores,by="FID")
controls_short2 <- merge(controls_short,scores,by="FID")
PD2$PHENO <- "PD"
AD2$PHENO <- "AD"
INDI2$PHENO <- "INDI"
controls_short2$PHENO <- "CONTROL"
big_merge <- rbind(AD2,PD2,controls_short2,INDI2)
# removing row from INDI files "NIST-reference-sample"
big_mergev2 <- big_merge[-c(101556), ] 
write.table(big_mergev2,file="INDI_WGS_WITH_UKB_AD_PD_CONTROLS_ASSUME_HOM_MISSING.txt",quote=FALSE,row.names=F,sep="\t")

# some plotting
# changing INDI to ZINDI to change order of plotting
big_mergev2$PHENO <- gsub('INDI', 'zINDI', big_mergev2$PHENO)
# convert to Z
meanGRS <- mean(big_mergev2$AD_score)
sdGRS <- sd(big_mergev2$AD_score)
big_mergev2$AD_score_Z <- (big_mergev2$AD_score - meanGRS)/sdGRS
meanGRS <- mean(big_mergev2$PD_score)
sdGRS <- sd(big_mergev2$PD_score)
big_mergev2$PD_score_Z <- (big_mergev2$PD_score - meanGRS)/sdGRS


# final plotting
### AD
p <- ggplot(big_mergev2, aes(x=PHENO, y=AD_score_Z)) + 
  geom_violin(fill="gray")
p + geom_boxplot(width=0.1) + scale_fill_grey() + theme_light() 
ggsave("AD_with_nojitter_assume_hom_missing.png")

p <- ggplot(big_mergev2, aes(x=PHENO, y=AD_score_Z)) + 
  geom_jitter(position=position_jitter(0.2))
p + theme_light()
ggsave("AD_with_jitter_assume_hom_missing.png")

### PD
p <- ggplot(big_mergev2, aes(x=PHENO, y=PD_score_Z)) + 
  geom_violin(fill="gray")
p + geom_boxplot(width=0.1) + scale_fill_grey() + theme_light() 
ggsave("PD_with_nojitter_assume_hom_missing.png")

p <- ggplot(big_mergev2, aes(x=PHENO, y=PD_score_Z)) + 
  geom_jitter(position=position_jitter(0.2))
p + theme_light()
ggsave("PD_with_jitter_assume_hom_missing.png")
```

Edit the figures in powerpoint (sorry GitHub) and add INDI annotation to it....



