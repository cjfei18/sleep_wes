#!/bin/bash

pheno=$1

for i in {1..22}; do
  docker run -v /home/dnanexus/:/home/dnanexus/ -w /home/dnanexus/ wzhou88/saige:1.1.6 step2_SPAtests.R \
    --bedFile=/home/dnanexus/sample_qc_final/ukb_wes_chr${i}_sample_qc_final_unrelated.bed \
    --bimFile=/home/dnanexus/sample_qc_final/ukb_wes_chr${i}_sample_qc_final_unrelated.bim \
    --famFile=/home/dnanexus/sample_qc_final/ukb_wes_chr${i}_sample_qc_final_unrelated.fam \
    --SAIGEOutputFile=/home/dnanexus/result/${pheno}/step2_single/${pheno}_3rd_10PC_chr${i}_bmi.txt \
    --AlleleOrder=alt-first \
    --minMAF=0 \
    --minMAC=20 \
    --GMMATmodelFile=/home/dnanexus/result/${pheno}/step1/${pheno}_3rd_10PC_chr${i}_bmi.rda \
    --varianceRatioFile=/home/dnanexus/result/${pheno}/step1/${pheno}_3rd_10PC_chr${i}_bmi.varianceRatio.txt \
    --sparseGRMFile=/home/dnanexus/GRM/UKB_GRM_relatednessCutoff_0.05_5000_randomMarkersUsed_unrelated_3rd_relatednessCutoff_0.05_5000_randomMarkersUsed.sparseGRM.mtx \
    --sparseGRMSampleIDFile=/home/dnanexus/GRM/UKB_GRM_relatednessCutoff_0.05_5000_randomMarkersUsed_unrelated_3rd_relatednessCutoff_0.05_5000_randomMarkersUsed.sparseGRM.mtx.sampleIDs.txt \
    --is_output_moreDetails=TRUE \
    --LOCO=FALSE \
    --is_fastTest=TRUE
done
