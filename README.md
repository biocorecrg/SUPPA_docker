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


