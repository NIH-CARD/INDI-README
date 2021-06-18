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
module load plink/2.3-alpha
module load bcftools
# split multiallelics, but wonder why they are even in there?
bcftools norm -m- consensus_variants_3common.vcf > consensus_variants_3common_split_multi.vcf

plink2 --vcf consensus_variants_3common_split_multi.vcf --make-bed --out KOLF_PLINK

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



## 2. Comparison with WGS

```
mkdir comparison_with_WGS
cd comparison_with_WGS

module load plink
plink --bfile ../plink/ibx_new_name --bmerge ../../KOLF_GENOME/KOLF_PLINK --make-bed --out test

-flip etc...

```



## 3. Plot per sample






