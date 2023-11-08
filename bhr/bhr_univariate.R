library(bhr)
library(tidyr)
library(data.table)

rm(list = ls())
baseline <- read.table("ms_baseline_oe5.txt")

for(pheno_name in c("Chronotype", "Daytime", "Duration", "Getup", "Insomnia", "Nap", "OSA", "Snoring")){
    for(func in c("_plof", "_missense", "_synonymous")){

BHR_input_path <- paste0(pheno_name,func, ".txt")
BHR_input <- as.data.frame(fread(BHR_input_path))
BHR_input <- na.omit(BHR_input)

BHR_input_rare <- subset(BHR_input,BHR_input$AF<1e-3 & BHR_input$AF>=1e-5)
BHR_input_ultrarare <- subset(BHR_input,BHR_input$AF<1e-5)

pheno_univariate_rare <- BHR(mode = "univariate",
                             trait1_sumstats = BHR_input_rare,
                             annotations = list(baseline))
total_h2 <- pheno_univariate_rare$mixed_model$heritabilities[1,5]
total_h2_se <- pheno_univariate_rare$mixed_model$heritabilities[2,5]
intercept <- pheno_univariate_rare$qc$intercept
intercept_se <- pheno_univariate_rare$qc$intercept_se
lambda_gc <- pheno_univariate_rare$qc$lambda_gc
result <- cbind(pheno_name,total_h2,total_h2_se,intercept,intercept_se,lambda_gc)
result$maf = "rare"

pheno_univariate_ur <- BHR(mode = "univariate",
                           trait1_sumstats = BHR_input_ultrarare,
                           annotations = list(baseline))
total_h2_ur<-pheno_univariate_ur$mixed_model$heritabilities[1,5]
total_h2_se_ur<-pheno_univariate_ur$mixed_model$heritabilities[2,5]
intercept_ur<-pheno_univariate_ur$qc$intercept
intercept_se_ur<-pheno_univariate_ur$qc$intercept_se
lambda_gc_ur<-pheno_univariate_ur$qc$lambda_gc
result_ur<-cbind(pheno_name,total_h2_ur,total_h2_se_ur,intercept_ur,intercept_se_ur,lambda_gc_ur)
result_ur$maf = "ultrarare"

result_all = rbind(result, result_ur)

write_path<-paste0("result/", pheno_name, ".txt")
write.table(result_all, write_path,sep = "\t",row.names = F,quote = F)
    }
}
