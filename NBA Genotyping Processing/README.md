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

- plink files:
ibx.bed  ibx.bim	ibx.fam  ibx.log

these are files from Dan, note general plink files + NOTE has to be clustered with other data since the Illumina algorithm needs some more diversity

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



