```
Working dir => cd /data/CARD/projects/INDI_genotypes/CNV_ALL_KOLF_DATA/

location to put input files in:
/data/CARD/projects/INDI_genotypes/CNV_ALL_KOLF_DATA/input_pennCNV/

PennCNV userguide
http://penncnv.openbioinformatics.org/en/latest/

Header file:
chromosome,position,snpID,snpName,Sample_ID,Allele1,Allele2,BAlleleFreq,LogRRatio

module load penncnv/1.0.5
```



```
Need to generate a PFB file:

SNP	Chr	Position	PFB
rs11127467	2	2994	0.0239656912209889
rs4522651	2	24049	0.0239536056480081

temporary:
cut -d "," -f 1,2,4,8 SETX_L389S_A07.csv | sed -e 's/,/\t/g' | awk '{ print $3 "\t" $1 "\t" $2 "\t" $4 }' > input_pennCNV/temp_NBA.pfb

cut -d "," -f 4,8,9 MAPT_R317W_C09.csv | sed -e 's/,/\t/g' > input_pennCNV/TEST_SAMPLE.txt

sed -i -e 's/snpName/Name/g' TEST_SAMPLE.txt

sed -i -e 's/BAlleleFreq/TEST.B Allele Freq/g' TEST_SAMPLE.txt
sed -i -e 's/LogRRatio/TEST.Log R Ratio/g' TEST_SAMPLE.txt
sed -i -e 's/chromosome/Chr/g' snpposfile.txt
sed -i -e 's/position/Position/g' snpposfile.txt


detect_cnv.pl -test -hmm hhall.hmm -pfb temp_NBA.pfb TEST_SAMPLE.txt -log sampleall.log -out sampleall.rawcnv

visualize_cnv.pl -format plot -signal TEST_SAMPLE.txt sampleall.rawcnv --snpposfile temp_NBA.pfb
```


