library(bhr)
library(tidyr)
library(data.table)

rm(list = ls())
baseline <- read.table("ms_baseline_oe5.txt")

pheno_list = c("Chronotype", "Daytime", "Duration", "Getup", "Nap", "Snoring", "Insomnia", "OSA")

for(pheno1 in c(1:7)){

    BHR_input_path1<-paste0(pheno_list[pheno1], "_plof.txt")
    BHR_input1 <- as.data.frame(fread(BHR_input_path1))
    BHR_input1 <- na.omit(BHR_input1)
    BHR_input_rare1 <- subset(BHR_input1,BHR_input1$AF<1e-3 & BHR_input1$AF>=1e-5)
    BHR_input_ultrarare1 <- subset(BHR_input1,BHR_input1$AF<1e-5)

    for(pheno2 in c(pheno1+1:8)){

    BHR_input_path2<-paste0(pheno_list[pheno2], "_plof.txt")
    BHR_input2<-as.data.frame(fread(BHR_input_path2))
    BHR_input2 <- na.omit(BHR_input2)

    BHR_input_rare2<-subset(BHR_input2,BHR_input2$AF<1e-3 & BHR_input2$AF>=1e-5)
    BHR_input_ultrarare2<-subset(BHR_input2,BHR_input2$AF<1e-5)

    rg_rare <- BHR(mode = "bivariate", 
                trait1_sumstats = BHR_input_rare1,
                trait2_sumstats = BHR_input_rare2,
                annotations = list(baseline),
                num_null_conditions = 5,
                use_null_conditions_rg = TRUE)
    rg_ur <- BHR(mode = "bivariate", 
                trait1_sumstats = BHR_input_ultrarare1,
                trait2_sumstats = BHR_input_ultrarare2,
                annotations = list(baseline),
                num_null_conditions = 5,
                use_null_conditions_rg = TRUE)

    result_rare = cbind(rg_rare$rg$rg_mixed, rg_rare$rg$rg_mixed_se, "rare", pheno_list[pheno1], pheno_list[pheno2])
    result_ur = cbind(rg_ur$rg$rg_mixed, rg_ur$rg$rg_mixed_se, "ultrarare", pheno_list[pheno1], pheno_list[pheno2])

    result_all = rbind(result_rare, result_ur)
    colnames(result_all) = c("rg_mixed", "rg_mixed_se", "maf", "pheno1", "pheno2")

    write_path<-paste0("result/rg/", pheno_list[pheno1], pheno_list[pheno2], "_rg.txt")
    write.table(result_all, write_path, sep = "\t",row.names = F,quote = F)
    }
}

