FROM ubuntu:bionic

RUN apt-get update && apt-get install -y python2.7 git wget gcc g++ zlib1g-dev libbz2-dev liblzma-dev libcurl4-openssl-dev make 
RUN wget https://raw.github.com/arq5x/gemini/master/gemini/scripts/gemini_install.py
RUN python2.7 gemini_install.py /usr/local /usr/local/share/gemini
#RUN mkdir -p /tmp && cd /tmp && git clone https://github.com/arq5x/gemini.git
#RUN apt-get update && apt-get install -y python-setuptools
#RUN cd /tmp/gemini/ && python3.6 setup.py install
ENV PATH "$PATH:/usr/local/bin/:/usr/local/share/gemini/data/"

# INSTALLING HTSLIB
RUN cd /usr/bin/ && wget https://github.com/samtools/htslib/releases/download/1.10.2/htslib-1.10.2.tar.bz2
RUN cd /usr/bin/ && tar -vxjf htslib-1.10.2.tar.bz2 && cd htslib-1.10.2 && make && make install
RUN cd /usr/bin/ && wget https://github.com/samtools/bcftools/releases/download/1.10.2/bcftools-1.10.2.tar.bz2 && tar -vxjf bcftools-1.10.2.tar.bz2 && cd bcftools-1.10.2 && make && make install

RUN mkdir -p /data
RUN cd /data/ && wget https://molgenis26.target.rug.nl/downloads/gonl_public/variants/release5/gonl.chr22.snps_indels.r5.vcf.gz
RUN cd /data/ && wget https://molgenis26.target.rug.nl/downloads/gonl_public/variants/release5/gonl.chr22.snps_indels.r5.vcf.gz.tbi
RUN cd /data/ && wget https://molgenis26.target.rug.nl/downloads/gonl_public/variants/release5/gonl.chr22.snps_indels.r5.vcf.gz.md5
#FIXME rm 5000 limit
RUN cd /data/ && zcat gonl.chr22.snps_indels.r5.vcf.gz | grep -v "Inaccessible" | head -5000 > /data/chr22NoInacessible.vcf

RUN cd /data/ && gemini load --cores 4 -v chr22NoInacessible.vcf chr22.db

#EXPOSE 8088

RUN apt-get update && apt-get install -y python-pip python-dev libffi-dev libssl-dev libxml2-dev libxslt1-dev libjpeg8-dev zlib1g-dev libcrypto++6 libssl-dev
RUN pip install puzzle
#EXPOSE 5000

# INSTALLING HTSLIB
#RUN cd /usr/bin/ && wget https://github.com/samtools/htslib/releases/download/1.10.2/htslib-1.10.2.tar.bz2
#RUN cd /usr/bin/ && tar -vxjf htslib-1.10.2.tar.bz2 && cd htslib-1.10.2 && make && make install
#RUN cd /usr/bin/ && wget https://github.com/samtools/bcftools/releases/download/1.10.2/bcftools-1.10.2.tar.bz2 && tar -vxjf bcftools-1.10.2.tar.bz2 && cd bcftools-1.10.2 && make && make install

#no entrypoint for now just run command line to start
#ENTRYPOINT gemini browser /data/chr22.db --use builtin
ENTRYPOINT puzzle load /data/chr22.db && puzzle view
