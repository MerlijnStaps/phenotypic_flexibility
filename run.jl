using StatsBase
using Distributions
using DataFrames
using CSV
using ArgParse
include("flexibility.jl")

user_args=ARGS[1:end]
name = user_args[1]
line1 = parse(Int,user_args[2])
line2 = parse(Int,user_args[3])

d = CSV.read("sims/"*name*".csv",DataFrame)
d = d[line1:line2,:]
d.pAA = [-1.0 for _ in 1:nrow(d)]
d.pAB = [-1.0 for _ in 1:nrow(d)]
d.pBA = [-1.0 for _ in 1:nrow(d)]
d.pBB = [-1.0 for _ in 1:nrow(d)]
d.alphaA = [-1.0 for _ in 1:nrow(d)]
d.alphaB = [-1.0 for _ in 1:nrow(d)]
d.fitness = [-1.0 for _ in 1:nrow(d)]

for i in 1:nrow(d)
    println(string(i) * "/" * string(nrow(d)))
    e = Environment(d.gammaA[i], d.gammaB[i], d.lambda[i])
    parameters = Dict("sensing_cost"=>d.sensing_cost[i], "yA"=>d.yA[i], "yB"=>d.yB[i], "s" => d.s[i], "alpha" => d.alpha[i])
    simulationParameters = Dict("populationSize" => d.populationSize[i], "generations" => d.generations[i])#"replicates" => d.replicates[i])
    sim = evolutionarySimulation(e, parameters, simulationParameters, d.alphaAEvolvable[i], d.alphaBEvolvable[i])
    println(sim["winner"])
    println(sim["winner_fitness"])
    d.pAA[i] = sim["winner"].pAA
    d.pAB[i] = sim["winner"].pAB
    d.pBA[i] = sim["winner"].pBA
    d.pBB[i] = sim["winner"].pBB
    d.alphaA[i] = sim["winner"].alphaA
    d.alphaB[i] = sim["winner"].alphaB
    d.fitness[i] = sim["winner_fitness"]
end

mkpath("results/"*name)
CSV.write("results/"*name*"/"*name*"_"*string(line1)*"_"*string(line2)*".csv",d)

