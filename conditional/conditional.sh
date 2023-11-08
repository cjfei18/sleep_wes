#---------1.extract.sh--------------------------------------------
#!/bin/bash

chr=$1
gene=$2
frombp=$3
tobp=$4
path1='/home1/sleep_condition/plink_file'
plink \
     --bfile /home1/UKB_gene_v3_imp_qc/UKB_gene_v3_imp_qc_chr${chr} \
     --chr ${chr} \
     --from-bp ${frombp} \
     --to-bp ${tobp} \
     --maf 0.005 \
     --make-bed \
     --out ${path1}/${gene}_common_maf0.005

#---------2.gwas.sh-----------------------------------------------
#!/bin/bash

trait=$1
gene=$2
path1='/home1/sleep_condition/plink_file'
path2='/home1/sleep_condition/gwas/data'

plink2 \
     --bfile ${path1}/${gene}_common_maf0.005 \
     --glm hide-covar \
     --covar ${path2}/covar_${trait}.txt \
     --covar-variance-standardize \
     --pheno ${path2}/${trait}_pheno.txt \
     --geno 0.1 \
     --hwe 1e-50 midp \
     --out ./res/${gene}_${trait}_gwas_result

#---------3.clump.sh----------------------------------------------
#!/bin/bash

trait=$1
chr=$2
gene=$3

plink \
     --bfile /home1/UKB_gene_v3_imp_qc/UKB_gene_v3_imp_qc_chr${chr} \
     --clump ./${gene}_${trait}_gwas_result.${trait}.glm.linear \
     --clump-field P \
     --clump-p1 1e-5 \
     --clump-r2 0.01 \
     --clump-snp-field ID \
     --out ./${gene}_${trait}.clump

#---------4.saige.sh----------------------------------------------
# See step1 and step2 for gene based test. Add common variants as covariates.
