# Phenotypic flexibility

Simulation code for "Temporal patterns of environmental change can explain the evolution of diverse flexible strategies". 

Authors: Merlijn Staps (Washington University in St. Louis), Deborah M. Gordon (Stanford University), Corina E. Tarnita (Princeton University)

Corresponding author: Merlijn Staps (merlijnstaps@gmail.com).

Abstract: "Flexibility, also called reversible plasticity, is a ubiquitous response to variable environments in which organisms reversibly change their behavior of morphology. The timing of flexible adjustments varies. Some organisms anticipate changes in conditions before they occur; for example, snowshoe hares molt into a white winter coat before snowfall. Others delay their responses, for example, breadcrumb sponges decrease their skeletal stiffness only long after a decrease in wave energy. To theoretically investigate the sources of variation in the timing of flexible responses, we develop a framework for the evolution of flexibility in which the durations of environmental conditions can have arbitrary statistics. This framework captures environments with diverse dynamics, including regular environments where changes occur periodically, history-independent environments that change at a constant rate, and clustered environments that alternate between periods of stasis and bursts of frequent change. We find that the temporal pattern of environmental change has profound consequences for the evolution of flexibility, even among environments that change at the same rate. Clustered environments are most conducive to the evolution of flexibility and, relative to regular environments, favor flexibility already under less frequent or more costly sensing. Anticipation and delays are adaptive under some environmental dynamics: regular environments can select for anticipation and clustered environments can select for delays. Altogether, our model helps to explain naturally occurring variation in flexible responses and provides a general framework for studying the consequences of diverse temporal patterns of environmental change."

This repository includes code to run the various evolutionary simulations and recreate the figures from the paper. 

## Simulations

The simulation code was produced on Julia v1.11.1. The dependencies can be found in ``Project.toml`` and installed using 

```console
$ julia --project=. -e 'using Pkg; Pkg.instantiate()'
```

The code for the simulations can be found in `flexibility.jl`. 

The script `setup.jl` creates CSV files with parameter settings for the simulations, which are stored in the folder `sims`.

The script `run.jl` can be used to run simulations as follows:

```console
$ julia --project=. run.jl evo1 100 123
```

This will run simulations with parameters from lines 100 through 123 from `sims/evo1.csv`, and store the outputs in the folder `results/evo1`. 

## Figures

The outputs of the simulations can be found in the folder `results`. 

The code to produce the figures was written in R (v4.3.2). The R scripts to generate the figures can be found in the folder `R`. The only dependency is:

```console
RColorBrewer 1.1.3
```
