library(bhr)
library(tidyr)
library(data.table)

rm(list = ls())
baseline <- read.table("ms_baseline_oe5.txt")

for(pheno_name in c("Chronotype", "Daytime", "Duration", "Getup", "Insomnia", "Nap", "OSA", "Snoring")){

func <- "_plof"

BHR_input_path <- paste0(pheno_name,func, ".txt")
BHR_input <- as.data.frame(fread(BHR_input_path))
BHR_input <- na.omit(BHR_input)

BHR_input_rare <- subset(BHR_input,BHR_input$AF<1e-3 & BHR_input$AF>=1e-5)
BHR_input_ultrarare <- subset(BHR_input,BHR_input$AF<1e-5)

BHR_aggregate<-BHR(mode = "aggregate",
                   ss_list = list(BHR_input_rare, BHR_input_ultrarare),
                   trait_list = list(pheno_name),
                   annotations = list(baseline))
aggregate_h2 <- BHR_aggregate$aggregated_mixed_model_h2
aggregate_h2_se <- BHR_aggregate$aggregated_mixed_model_h2se
result <- cbind(pheno_name,aggregate_h2,aggregate_h2_se)

write_path<-paste0("result/", pheno_name, "_agg.txt")
write.table(result, write_path,sep = "\t",row.names = F,quote = F)
}
