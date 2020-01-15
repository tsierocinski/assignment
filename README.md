# Report for the technical assignment from SG
# January 14th, 2020


# Assignment

Incorporate in an SQL database (or other data structure you are familiar with) the dutch Allele Frequency Database GoNL (http://www.nlgenome.nl/).
- Get the SNV and indels data in VCF (it is sufficient to limit the analysis to one chromosome, such as chromosome 22 for example).
- Conceive an SQL database schema, which will permit you to store the variant data, such as genomic position, nucleotide changes, alternative allele count, total number of alleles, variant frequency, a unique variant ID (identifier) and the dbSNP reference (rsid).
- The data scheme should be optimised for queries based on genomic intervals (e.g. find all of the variants present in chromosome 22 between genomic positions n and m).
- Write a program in Python (or another programming language you are more comfortable with) to populate this database from the VCF file from GoNL (SNVs and indels). Exclude variants "Inaccessible".
Please return a structured report along with scripts and materials needed to reproduce your analysis.


# Summary
This repository aims to build a docker container hosting GEMINI [https://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1003153] and the data. This README contains information to build the container and query the hosted database.

## Data
The data downloaded correspond to the SNPs and small INDELS for chromosome 22 in the GoNL Database. For ease of built (I only had an small laptop for the exercise), the database only contains the top 5000 non "inaccessible" variants of the file. To build the database using the entire chomosome see the comments in the Dockerfile.

## Database schema
The database schema can be found here: https://gemini.readthedocs.io/en/latest/content/database_schema.html

# Requirements
- To have Docker CE installed (preferably on a linux/unix host, since the intruction below are in bash): https://docs.docker.com/install/linux/docker-ce/binaries/
- Some diskspace the system, dependencies and database will require about 28Gb.

# Cloning the repository:

```bash
git clone https://github.com/tsierocinski/assignment.git
```

# Build the image

depending on your docker setup you might need administrator privileges on your machine.

This file was tested with Docker version 19.03.5, build 633a0ea838

```bash
cd assignment
# sudo
docker build . -t assignment
```

# Querying the database

Once the image is built, you can run the container and query the SQL database using GEMINI:

```bash
# interactive session
# sudo
docker run -it --rm assignment:latest /bin/bash
# inside the container prompt
gemini query -q "select * from variants limit 20" /data/chr22.db

# or

# sudo 
docker run assignment:latest -c "gemini query -q \"select * from variants limit 20\" /data/chr22.db"

```

# Graphical interface

GEMINI comes with a graphical interface, to start it run

```bash
\#sudo
docker run -it assignment:latest /bin/bash
# container prompt
gemini browser /data/chr22.db --use builtin
```

A web interface is then be available on http://localhost:8088 or replace 'localhost' by your local network ip.


