### Cluster buster prototype version...

#### Mike Nalls - June 2021

### Working dir
 => /data/CARD/projects/INDI_genotypes/PHASE2_post_KOLF_selection

### How to run

```
python cluster_buster_prototype_cli.py --report_file Genotyping_Report_FILE.txt \
--snp_file snps_of_interest_first_data.txt --out_file OUTPUTFILE_FOLDER
```

### how does underlying data format look like?
```
Genotyping_Report_FILE.txt

  --------> samples with several values (most crucial's are .Theta and .R)
 |
 |
 |
 |
 v
variants from NeuroBoosterArray
```

```
snps_of_interest_first_data.txt
# there are the actual NeuroBoosterArray names... you can find them in the .bim files if needed

Name
Seq_rs387906627
17:44101427-C-T
Seq_rs63750424
rs63750424
exm1563596
seq_rs63750847
Seq_rs121909536_ilmnfwd_ilmnF2BT
```

```
OUTPUTFILE_FOLDER
just a random output folder where ever you want the output to go to
```

### example

```
cd /data/CARD/projects/INDI_genotypes/PHASE2_post_KOLF_selection/cluster_buster/
module load python/3.7
python cluster_buster_prototype_cli.py \
--report_file ../first_data_release_June_2021/F4SEttehadieh_P1_Genotyping_Report.txt  \
--snp_file snps_of_interest_first_data.txt --out_file test_snps/
```

### example outputs

![alt text](http://url/to/img.png)


![alt text](http://url/to/img.png)










