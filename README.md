# Caviar

![Caviar logo](./resources/logos/caviar_logo_gray.png)

Caviar (**C**ustom **A**ssemblies **via** **r**eproducible Pipeline): an open source Nextflow-based pipeline for assembly execution, which includes the tools MEGAHIT, Oases, Trinity, rnaSPAdes, Trans-ABySS, SOAPdenovo-Trans, IDBA-tran and IDBA-MT, largely with default execution parameters.

The pipeline requires executable binaries or scripts in the environment variable. This can be set with 

```
env {
    PATH = "/example/path:$PATH"
}

```

in the nextflow.config file.

Adjust the config file `example_resource.config` according to your cluster.

Adjust the config file `example_params.config` with:
`sample_dir` being the path to the merged fasta samples.
`pattern` being regex with the paired mate pattern
pattern = "*_R{1,2}.fastq.gz"
and
result_dir = ""

if available: 
read_length = 
insert_size = 

Caviar requires the binaries `fq2fa`, `idba_tran`, `idba-mt`, `velveth`, `velvetg`, `oases`, `rnaspades.py`, `SOAPdenovo-Trans-127mer`, `Trinity`, `megahit` binaries in the path.

The process `DBG` can be commented out in the `main.nf`.

Miniconda needs to be installed and transabyss in a conda environment named `transabyss`.

Code sources:
`fq2fa`, `idba_tran`
https://github.com/loneknightpy/idba

https://github.com/dzerbino/oases (also clone and build linked velvet version)
https://github.com/voutcn/megahit
https://github.com/ablab/spades
https://github.com/trinityrnaseq/trinityrnaseq
https://bioconda.github.io/recipes/transabyss/README.html
https://github.com/aquaskyline/SOAPdenovo-Trans
https://code.google.com/archive/p/hku-idba-mt/source/default/source


