FROM ubuntu:bionic

# INSTALLING SYSTEM DEPENDENCIES
RUN apt-get update && apt-get install -y python2.7 git wget gcc g++ zlib1g-dev libbz2-dev liblzma-dev libcurl4-openssl-dev make 
RUN wget https://raw.github.com/arq5x/gemini/master/gemini/scripts/gemini_install.py
RUN python2.7 gemini_install.py /usr/local /usr/local/share/gemini
ENV PATH "$PATH:/usr/local/:/usr/local/bin/:/usr/local/share/gemini/data/"

# INSTALLING HTSLIB
RUN cd /usr/bin/ && wget https://github.com/samtools/htslib/releases/download/1.10.2/htslib-1.10.2.tar.bz2
RUN cd /usr/bin/ && tar -vxjf htslib-1.10.2.tar.bz2 && cd htslib-1.10.2 && make && make install
RUN cd /usr/bin/ && wget https://github.com/samtools/bcftools/releases/download/1.10.2/bcftools-1.10.2.tar.bz2 && tar -vxjf bcftools-1.10.2.tar.bz2 && cd bcftools-1.10.2 && make && make install

# DOWNLOADING THE DATA
RUN mkdir -p /data
RUN cd /data/ && wget https://molgenis26.target.rug.nl/downloads/gonl_public/variants/release5/gonl.chr22.snps_indels.r5.vcf.gz
RUN cd /data/ && wget https://molgenis26.target.rug.nl/downloads/gonl_public/variants/release5/gonl.chr22.snps_indels.r5.vcf.gz.tbi
RUN cd /data/ && wget https://molgenis26.target.rug.nl/downloads/gonl_public/variants/release5/gonl.chr22.snps_indels.r5.vcf.gz.md5

#SAMPLING THE DATAFILE FOR NON "Inacessible" and only the top 5000 lines of the vcf file (header included)
#PLEASE REMOVE '| head -5000' FOR THE FULL SET
RUN cd /data/ && zcat gonl.chr22.snps_indels.r5.vcf.gz | grep -v "Inaccessible" | head -5000 > /data/chr22NoInacessible.vcf

# LOADING THE FILE INTO GEMINI'S DATABASE
# NUMBER OF CORES WAS SET HERE TO 4 - CHANGE ACCORDINGLY TO SUIT YOUR SETUP
RUN cd /data/ && gemini load --cores 4 -v chr22NoInacessible.vcf chr22.db

#no entrypoint for now just run from command line to start
#ENTRYPOINT gemini browser /data/chr22.db --use builtin
