## NEW GRS figure

#### authors: Mark Cookson, Caroline Pantazis and Cornelis Blauwendraat
#### date: April 4 2021
#### goal: Make GRS figure of included cell-lines and UKB as reference


```
module load R
cd /data/CARD/projects/INDI_genotypes/GRS_figure
AND 
cd /data/CARD/projects/INDI_genotypes/WGS/

R

# Read in packages
library(tidyverse)
library(RColorBrewer)
library(ggpubr)
library(ggplot2)


GRS_data <- read.table("../WGS/INDI_WGS_WITH_UKB_AD_PD_CONTROLS.txt",header=T)
# GRS_data <- read.table("../WGS/INDI_WGS_WITH_UKB_AD_PD_CONTROLS_ASSUME_HOM_MISSING.txt",header=T)

# make Z-score
meanGRS <- mean(GRS_data$AD_score)
sdGRS <- sd(GRS_data$AD_score)
GRS_data$AD_SCOREZ <- (GRS_data$AD_score - meanGRS)/sdGRS

meanGRS <- mean(GRS_data$PD_score)
sdGRS <- sd(GRS_data$PD_score)
GRS_data$PD_SCOREZ <- (GRS_data$PD_score - meanGRS)/sdGRS

# update phenotypes
GRS_data_AD <- subset(GRS_data, GRS_data$PHENO == "AD" | GRS_data$PHENO == "CONTROL")
GRS_data_AD$PHENO[GRS_data_AD$PHENO == "AD"] <- 2
GRS_data_AD$PHENO[GRS_data_AD$PHENO == "CONTROL"] <- 1

GRS_data_PD <- subset(GRS_data, GRS_data$PHENO == "PD" | GRS_data$PHENO == "CONTROL")
GRS_data_PD$PHENO[GRS_data_PD$PHENO == "PD"] <- 2
GRS_data_PD$PHENO[GRS_data_PD$PHENO == "CONTROL"] <- 1

# subset INDI from data
GRS_INDI <- GRS_data[ which(GRS_data$PHENO=="INDI"),]
samples <- read.csv("WGS_key.csv", header=T)
GRS_INDI$Line_ID <- samples$Line_ID[match(GRS_INDI$FID, samples$WGS_ID)]

# start plotting
#-- AD
AD <- ggplot(data=GRS_data_AD, aes(x=AD_SCOREZ, y=PHENO, fill=PHENO))
AD <- AD + geom_boxplot(alpha=0.5)
AD <- AD + scale_fill_manual(values=c("steelblue","orange"))
AD <- AD + theme_classic()
AD <- AD + theme(legend.position = "none")
AD <- AD + labs(x="Alzheimers Genetic Risk Score", y="")
AD <- AD + xlim(-5,5)
AD
#-- PD
PD <- ggplot(data=GRS_data_PD, aes(y=PD_SCOREZ, x=PHENO, fill=PHENO))
PD <- PD + geom_boxplot(alpha=0.5)
PD <- PD + scale_fill_manual(values=c("steelblue","orange"))
PD <- PD + theme_classic()
PD <- PD + labs(x="", y="Parkinson's Genetic Risk Score")
PD <- PD + theme(legend.position = "none")
PD <- PD + ylim(-5,5)
PD
#-- INDI
d <- ggplot(GRS_INDI, aes(AD_SCOREZ, PD_SCOREZ,  color= Line_ID))
d <- d + geom_point(size=5)
d <- d + scale_color_brewer(palette="Spectral")
d <- d + labs(x="Alzheimers Genetic Risk Score", y="Parkinson's Genetic Risk Score")
d <- d + ggtitle( "AD vs PD GRS")
d <- d + theme_classic()
d <- d + theme(plot.title = element_text(hjust = 0.5), legend.position = c(0.8,0.3))
d <- d + xlim(-5,5)
d <- d + ylim(-5,5)
d

ggarrange( d, AD,   ncol = 1, nrow = 2, heights = c(1,0.5),  align = "hv")

# normal
tiff(file=paste0("GRS_NEW_UKB.tiff"), width=10, height=8, units="in",res=300, pointsize = 8)
ggarrange(PD, d, NULL, AD,ncol = 2, nrow = 2, heights = c(1,0.25), widths= c(0.25,1), align = "hv")
dev.off()

png(file=paste0("GRS_NEW_UKB.png"), width=10, height=8, units="in",res=300, pointsize = 8)
ggarrange(PD, d, NULL, AD,ncol = 2, nrow = 2, heights = c(1,0.25), widths= c(0.25,1), align = "hv")
dev.off()

# OR ASSUME_HOM_MISSING
tiff(file=paste0("GRS_NEW_UKB_ASSUME_HOM_MISSING.tiff"), width=10, height=8, units="in",res=300, pointsize = 8)
ggarrange(PD, d, NULL, AD,ncol = 2, nrow = 2, heights = c(1,0.25), widths= c(0.25,1), align = "hv")
dev.off()

png(file=paste0("GRS_NEW_UKB_ASSUME_HOM_MISSING.png"), width=10, height=8, units="in",res=300, pointsize = 8)
ggarrange(PD, d, NULL, AD,ncol = 2, nrow = 2, heights = c(1,0.25), widths= c(0.25,1), align = "hv")
dev.off()

```
