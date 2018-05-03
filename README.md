# SUPPA_docker
Docker for running [SUPPA](https://github.com/comprna/SUPPA)

## Build image

    docker build -t suppa .

Build arguments are provided for SUPPA

## Run image

    docker run -d -v ~/myshared:/share --name mysuppa suppa tail -f /dev/null

~/myshared is a shared volume used for convenience for placing input and output files

The command above keeps container running under the name mysuppa

Example running command:

Try to reproduce what is here: https://github.com/comprna/SUPPA/wiki/SUPPA2-tutorial



    cd ~/myshared; git clone https://github.com/comprna/SUPPA_supplementary_data/

    prefetch SRR1513329

    fastq-dump --outdir /home/toniher/tmp/suppa/fastq/ --split-files /home/toniher/ncbi/public/sra/SRR1513329.sra     

    mkdir -p ~/myshared/index

    docker exec mysuppa salmon index -t /share/SUPPA_supplementary_data/annotation/hg19_EnsenmblGenes_sequence_ensenmbl.fasta.gz -i /share/index/Ensembl_hg19_salmon_index
    
    mkdir -p ~/myshared/quant

    docker exec mysuppa salmon quant -i /share/index/Ensembl_hg19_salmon_index -l ISF --gcBias -1 /share/fastq/SRR1513329_1.fastq -2 /share/fastq/SRR1513329_2.fastq -p 4 -o /share/quant/SRR1513329

    docker exec mysuppa python /usr/local/suppa/multipleFieldSelection.py -i /share/quant/SRR1513329/quant.sf -k 1 -f 4 -o /share/iso_tpm.txt

    docker exec mysuppa Rscript /usr/local/suppa/scripts/format_Ensembl_ids.R /share/iso_tpm.txt

    docker exec mysuppa python /usr/local/suppa/suppa.py generateEvents -i /share/SUPPA_supplementary_data/annotation/Homo_sapiens.GRCh37.75.formatted.gtf.gzip -o /share/output/ensembl_hg19.events.ioe -f ioe -e SE SS MX RI FL

    docker exec mysuppa sh -c  "gunzip -c  /share/SUPPA_supplementary_data/annotation/Homo_sapiens.GRCh37.75.formatted.gtf.gz > /share/SUPPA_supplementary_data/annotation/Homo_sapiens.GRCh37.75.formatted.gtf " 

    mkdir -p ~/myshared/events
   
    docker exec mysuppa python /usr/local/suppa/suppa.py generateEvents -i /share/SUPPA_supplementary_data/annotation/Homo_sapiens.GRCh37.75.formatted.gtf -o /share/events/ensembl_hg19.events.ioe -f ioe -e SE SS MX RI FL

    docker exec mysuppa sh -c "cd /share/events/; awk ' FNR==1 && NR!=1 { while (/^<header>/) getline; }  1 {print} ' *.ioe > ensembl_hg19.events.ioe"

    docker exec mysuppa python /usr/local/suppa/suppa.py psiPerEvent -i /share/events/ensembl_hg19.events.ioe -e /share/iso_tpm_formatted.txt -o /share/events/TRA2_events

    mkdir -p ~/myshared/plots

    docker exec mysuppa python /usr/local/suppa/scripts/generate_boxplot_event.py -i /share/events/TRA2_events.psi -e "ENSG00000149554;SE:chr11:125496728-125497502:125497725-125499127:+" -g 1-3,4-6 -c NC,KD -o /share/plots
 
