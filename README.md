# Phenotypic flexibility

[![DOI](https://zenodo.org/badge/657317785.svg)](https://zenodo.org/doi/10.5281/zenodo.12795781)

Model for phenotypic flexibility in which durations of conditions are gamma distributed.


## System requirements

The code was produced on Julia v1.11.1. 

Module uses the following packages:

```console
StatsBase
Distributions
DataFrames
CSV
ArgParse
```

## Simulations

The code for the simulations can be found in `flexibility.jl`. 

The script `setup.jl` creates CSV files with parameter settings for the simulations, which are stored in the folder `sims`.

The script `run.jl` can be used to run simulations as follows:

```console
$ julia run.jl fig2 100 123
```

This will run simulations with parameters from lines 100 through 123 from `sims/fig2.csv`.

## Figures

The outputs of the simulations can be found in the folder `results`. The R scripts to generate the figures can be found in the folder `R`. 
