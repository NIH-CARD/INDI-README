### Goal is to assess the presence of pathogenic variants in the INDI lines...


### using ANNOVAR direct annotation from VCF

```
module load annovar

table_annovar.pl 2001UNHS-0021_hg38_genotypes_UNHS.vcf.gz $ANNOVAR_DATA/hg38 \
--thread 16 -buildver hg38 \
-out INDI_vcf_annotation \
-remove -protocol refGene,avsnp150,clinvar_20200316 \
-operation g,f,f -nastring . -vcfinput

```

### investigation of all variants identified as pathogenic....
```
grep "athogenic" INDI_vcf_annotation.hg38_multianno.txt > pathogenic_variants_INDI.txt
head -1  INDI_vcf_annotation.hg38_multianno.txt > header.txt
cat header.txt pathogenic_variants_INDI.txt > pathogenic_variants_INDI_header.txt

wc -l pathogenic_variants_INDI.txt
# 509

# manual inspection for NDD related traits
Using CLNSIG column:

CLNSIG	COUNT
Conflicting_interpretations_of_pathogenicity	459
Pathogenic	27
Likely_pathogenic	10
Conflicting_interpretations_of_pathogenicity,_other	3
Pathogenic/Likely_pathogenic	2
Pathogenic,_risk_factor	2
Pathogenic,_protective	1
Conflicting_interpretations_of_pathogenicity,_Affects	1
Conflicting_interpretations_of_pathogenicity,_protective	1
Pathogenic,_association,_protective	1
Conflicting_interpretations_of_pathogenicity,_risk_factor	1
Pathogenic,_association	1

Focussing on => Pathogenic and Likely_pathogenic

and selecting neuro related traits:

```
| ExonicFunc.refGene  | AAChange.refGene                              | avsnp150    | CLNALLELEID | CLNDN                                                                |
|---------------------|-----------------------------------------------|-------------|-------------|----------------------------------------------------------------------|
| frameshift deletion | DRD4:NM_000797:exon1:c.233_245del:p.A79Sfs*21 | rs587776842 | 31806       | Autonomic_nervous_system_dysfunction                                 |
| stopgain            | MPDZ:NM_001261406:exon22:c.C3211T:p.R1071X    | rs376078512 | 538633      | Hydrocephalus,_congenital,_2,_with_or_without_brain_or_eye_anomalies |

```
so who carriers this?

NN0003932-C3 and NN0004297-C1 => DRD4:NM_000797:exon1:c.233_245del:p.A79Sfs*21
KUCG3-C1 => MPDZ:NM_001261406:exon22:c.C3211T:p.R1071X

```

```
Now again focussing only on INDI genes... using all variants from pathogenic_variants_INDI_header.txt
checking for overlap with INDI genes from below table...

```

| ExonicFunc.refGene | AAChange.refGene                                                                            | avsnp150    | CLNALLELEID | CLNDN                                                                                                                                                      |
|--------------------|---------------------------------------------------------------------------------------------|-------------|-------------|------------------------------------------------------------------------------------------------------------------------------------------------------------|
| nonsynonymous SNV  | ATM:NM_000051:exon41:c.G6067A:p.G2023R,ATM:NM_001351834:exon42:c.G6067A:p.G2023R            | rs11212587  | 132873      | Ataxia-telangiectasia_syndrome\|Hereditary_cancer-predisposing_syndrome\|not_specified\|not_provided                                                       |
| synonymous SNV     | CACNA1A:NM_001127221:exon20:c.G3387A:p.P1129P,CACNA1A:NM_001127222:exon20:c.G3384A:p.P1128P | rs370541345 | 379395      | not_specified\|not_provided                                                                                                                                |
| nonsynonymous SNV  | POLG:NM_001126131:exon16:c.A2492G:p.Y831C,POLG:NM_002693:exon16:c.A2492G:p.Y831C            | rs41549716  | 28548       | Seizures\|Progressive_sclerosing_poliodystrophy\|Autosomal_dominant_progressive_external_ophthalmoplegia_with_mitochondrial_DNA_deletions_1\|not_specified |
| nonsynonymous SNV  | PRKN:NM_004562:exon3:c.C245A:p.A82E,PRKN:NM_013987:exon3:c.C245A:p.A82E                     | rs55774500  | 22077       | Parkinson_disease_2\|not_specified\|not_provided                                                                                                           |
| nonsynonymous SNV  | SPTBN2:NM_006946:exon18:c.A3722G:p.E1241G                                                   | rs141683210 | 441459      | not_specified\|not_provided                                                                                                                                |

```
so who carriers this?

AAChange.refGene		who		
KOLF2.1:
CACNA1A:NM_001127221:exon20:c.G3387A:p.P1129P		

NN0003932 +	NN0004297:
POLG:NM_001126131:exon16:c.A2492G:p.Y831C	

KUCG3:
PRKN:NM_004562:exon3:c.C245A:p.A82E				

LNGPI1:
ATM:NM_000051:exon41:c.G6067A:p.G2023R	
SPTBN2:NM_006946:exon18:c.A3722G:p.E1241G
POLG:NM_001126131:exon16:c.A2492G:p.Y831C
```

### investigation of LOF variants in INDI genes....
```
INDI Genes... see table at the bottom

grep "stop" INDI_vcf_annotation.hg38_multianno.txt > pass1.txt
grep "frame" INDI_vcf_annotation.hg38_multianno.txt > pass2.txt
grep "splicing" INDI_vcf_annotation.hg38_multianno.txt > pass3.txt
head -1  INDI_vcf_annotation.hg38_multianno.txt > header.txt
cat header.txt pass1.txt pass2.txt pass3.txt > LOF_INDI_header.txt

wc -l LOF_INDI_header.txt
# 2797

7 variants are found in INDI genes...

Major findings:
PGP1 seems to be carrying rs113809142 which is a suggested risk factor for AD https://www.snpedia.com/index.php/Rs113809142 

Other variants either too common or in problematic regions (eg too much variation)

```

| Gene      | Disease                               |
|-----------|---------------------------------------|
| ABCA7     | Alzheimer's disease                   |
| ADAM10    | Alzheimer's disease                   |
| APOE      | Alzheimer's disease                   |
| APP       | Alzheimer's disease                   |
| PSEN1     | Alzheimer's disease                   |
| PSEN2     | Alzheimer's disease                   |
| SORL1     | Alzheimer's disease                   |
| TREM2     | Alzheimer's disease                   |
| ATP13A2   | Dementia with Lewy Bodies/Parkinson's |
| COQ2      | Dementia with Lewy Bodies/Parkinson's |
| DNAJC6    | Dementia with Lewy Bodies/Parkinson's |
| DNMT1     | Dementia with Lewy Bodies/Parkinson's |
| EIF4G1    | Dementia with Lewy Bodies/Parkinson's |
| FBXO7     | Dementia with Lewy Bodies/Parkinson's |
| GBA       | Dementia with Lewy Bodies/Parkinson's |
| GCH1      | Dementia with Lewy Bodies/Parkinson's |
| LRRK2     | Dementia with Lewy Bodies/Parkinson's |
| PANK2     | Dementia with Lewy Bodies/Parkinson's |
| PARK7     | Dementia with Lewy Bodies/Parkinson's |
| PINK1     | Dementia with Lewy Bodies/Parkinson's |
| PRKN      | Dementia with Lewy Bodies/Parkinson's |
| RAB39B    | Dementia with Lewy Bodies/Parkinson's |
| SNCA      | Dementia with Lewy Bodies/Parkinson's |
| SNCB      | Dementia with Lewy Bodies/Parkinson's |
| SYNJ1     | Dementia with Lewy Bodies/Parkinson's |
| VPS13C    | Dementia with Lewy Bodies/Parkinson's |
| VPS35     | Dementia with Lewy Bodies/Parkinson's |
| ANG       | Frontotemporal Dementia/ALS           |
| ANXA11    | Frontotemporal Dementia/ALS           |
| CHCHD10   | Frontotemporal Dementia/ALS           |
| CHMP2B    | Frontotemporal Dementia/ALS           |
| CSF1R     | Frontotemporal Dementia/ALS           |
| DAO       | Frontotemporal Dementia/ALS           |
| DCTN1     | Frontotemporal Dementia/ALS           |
| ERBB4     | Frontotemporal Dementia/ALS           |
| FUS       | Frontotemporal Dementia/ALS           |
| GRN       | Frontotemporal Dementia/ALS           |
| HNRNPA1   | Frontotemporal Dementia/ALS           |
| HNRNPA2B1 | Frontotemporal Dementia/ALS           |
| KIF5A     | Frontotemporal Dementia/ALS           |
| MAPT      | Frontotemporal Dementia/ALS           |
| MATR3     | Frontotemporal Dementia/ALS           |
| OPTN      | Frontotemporal Dementia/ALS           |
| PFN1      | Frontotemporal Dementia/ALS           |
| POLG      | Frontotemporal Dementia/ALS           |
| PRKAR1B   | Frontotemporal Dementia/ALS           |
| SETX      | Frontotemporal Dementia/ALS           |
| SIGMAR1   | Frontotemporal Dementia/ALS           |
| SOD1      | Frontotemporal Dementia/ALS           |
| TARDBP    | Frontotemporal Dementia/ALS           |
| TBK1      | Frontotemporal Dementia/ALS           |
| TIA1      | Frontotemporal Dementia/ALS           |
| TMEM106B  | Frontotemporal dementia/ALS           |
| TUBA4A    | Frontotemporal Dementia/ALS           |
| UBQLN2    | Frontotemporal Dementia/ALS           |
| VAPB      | Frontotemporal Dementia/ALS           |
| VCP       | Frontotemporal Dementia/ALS           |
| ATM       | OTHER                                 |
| CACNA1A   | OTHER                                 |
| CLN5      | OTHER                                 |
| EIF2AK2   | OTHER                                 |
| EIF2B1    | OTHER                                 |
| EIF2B2    | OTHER                                 |
| EIF2B3    | OTHER                                 |
| EIF2B4    | OTHER                                 |
| EIF2B5    | OTHER                                 |
| FXN       | OTHER                                 |
| ITM2B     | OTHER                                 |
| ITPR1     | OTHER                                 |
| KCNA1     | OTHER                                 |
| KCNC3     | OTHER                                 |
| PLA2G6    | OTHER                                 |
| PLEKHG4   | OTHER                                 |
| PRKCG     | OTHER                                 |
| PRNP      | OTHER                                 |
| RNF216    | OTHER                                 |
| SERPINI1  | OTHER                                 |
| SLC1A3    | OTHER                                 |
| SMN1      | OTHER                                 |
| SPG11     | OTHER                                 |
| SPTBN2    | OTHER                                 |
| VPS13D    | OTHER                                 |




