#!/bin/bash

pheno=$1

for i in {1..22}; do
  docker run -v /home/dnanexus/:/home/dnanexus/ -w /home/dnanexus/ wzhou88/saige:1.1.6 step2_SPAtests.R \
    --bedFile=/home/dnanexus/sample_qc_final/ukb_wes_chr${i}_sample_qc_final_unrelated.bed \
    --bimFile=/home/dnanexus/sample_qc_final/ukb_wes_chr${i}_sample_qc_final_unrelated.bim \
    --famFile=/home/dnanexus/sample_qc_final/ukb_wes_chr${i}_sample_qc_final_unrelated.fam \
    --SAIGEOutputFile=/home/dnanexus/result/${pheno}/step2/${pheno}_3rd_10PC_chr${i}_bmi.txt \
    --AlleleOrder=alt-first \
    --minMAF=0 \
    --minMAC=0.5 \
    --GMMATmodelFile=/home/dnanexus/result/${pheno}/step1/${pheno}_3rd_10PC_chr${i}_bmi.rda \
    --varianceRatioFile=/home/dnanexus/result/${pheno}/step1/${pheno}_3rd_10PC_chr${i}_bmi.varianceRatio.txt \
    --sparseGRMFile=/home/dnanexus/GRM/UKB_GRM_relatednessCutoff_0.05_5000_randomMarkersUsed_unrelated_3rd_relatednessCutoff_0.05_5000_randomMarkersUsed.sparseGRM.mtx \
    --sparseGRMSampleIDFile=/home/dnanexus/GRM/UKB_GRM_relatednessCutoff_0.05_5000_randomMarkersUsed_unrelated_3rd_relatednessCutoff_0.05_5000_randomMarkersUsed.sparseGRM.mtx.sampleIDs.txt \
    --groupFile=/home/dnanexus/SNPEff/SnpEff_gene_group_chr${i}.txt \
    --annotation_in_groupTest="lof,missense:lof" \
    --maxMAF_in_groupTest=0.00001,0.0001,0.001,0.01 \
    --is_output_markerList_in_groupTest=TRUE \
    --LOCO=FALSE \
    --is_fastTest=FALSE
done
