using StatsBase
using Distributions
using DataFrames
using CSV
using ArgParse

parser = ArgParseSettings()
@add_arg_table parser begin
    "--name"
        arg_type = String
        default = ""
    "--run"
        arg_type = Bool
        default = false
end
args = parse_args(parser)
name = args["name"]

function createSH(name,lines,fileName,h=8,memory=1)
    shfile = open(fileName,"w")
    write(shfile,"#!/bin/bash\n")
    write(shfile,"#SBATCH --nodes=1\n")
    write(shfile,"#SBATCH --ntasks=1\n")
    write(shfile,"#SBATCH --cpus-per-task=1\n")
    write(shfile,"#SBATCH --mem-per-cpu="*string(memory)*"G\n")
    write(shfile,"#SBATCH --time="*string(h)*":00:00\n")
    write(shfile,"#SBATCH --output=output/%x.%j.out\n")
	write(shfile,"\n\n")
	write(shfile,"module purge \n")
	write(shfile,"module load julia/1.11.1 \n\n")
    write(shfile,"julia run.jl "*name*" "*string(minimum(lines))*" "*string(maximum(lines))*"\n")
    close(shfile)
end

d = CSV.read("sims/" * name * ".csv", DataFrame)

## Create results folder
if !isdir("results/"*name)
    mkdir("results/"*name)
end

groupsize = 5000
for i in 1:Int64(ceil(nrow(d)/groupsize))
    lines = repeat([groupsize*(i-1)],groupsize).+collect(1:groupsize)
    lines = intersect(lines,collect(1:nrow(d)))
    shFileName = "sh/"*name*"_"*string(i)*".sh"
    createSH(name,lines,shFileName)
    if args["run"]
        run(`sbatch $shFileName`)
    end
end


