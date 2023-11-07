#!/bin/bash

pheno=$1

for i in {1..22};
do
    docker run -v /home/dnanexus/:/home/dnanexus/ -w /home/dnanexus/ wzhou88/saige:1.1.6 step1_fitNULLGLMM.R \
        --sparseGRMFile=/home/dnanexus/GRM/UKB_GRM_relatednessCutoff_0.05_5000_randomMarkersUsed_unrelated_3rd_relatednessCutoff_0.05_5000_randomMarkersUsed.sparseGRM.mtx \
        --sparseGRMSampleIDFile=/home/dnanexus/GRM/UKB_GRM_relatednessCutoff_0.05_5000_randomMarkersUsed_unrelated_3rd_relatednessCutoff_0.05_5000_randomMarkersUsed.sparseGRM.mtx.sampleIDs.txt \
        --plinkFile=/home/dnanexus/sample_qc_final/ukb_wes_chr${i}_sample_qc_final_unrelated \
        --useSparseGRMtoFitNULL=FALSE   \
        --useSparseGRMforVarRatio=TRUE \
        --phenoFile=/home/dnanexus/data/${pheno}_bmi.csv \
        --phenoCol=${pheno} \
        --covarColList=sex,age,PC1,PC2,PC3,PC4,PC5,PC6,PC7,PC8,PC9,PC10,bmi \
        --qCovarColList=sex  \
        --sampleIDColinphenoFile=eid \
        --SampleIDIncludeFile=/home/dnanexus/data/british_white_id.txt \
        --isCovariateOffset=FALSE \
        --traitType=quantitative  \
        --invNormalize=TRUE \
        --nThreads=20    \
        --isCateVarianceRatio=TRUE \
        --outputPrefix=/home/dnanexus/result/${pheno}/step1/${pheno}_3th_10PC_chr${i} \
        --IsOverwriteVarianceRatioFile=TRUE
done
