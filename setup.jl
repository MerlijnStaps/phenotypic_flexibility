using StatsBase
using Distributions
using DataFrames
using CSV
using Random

# Evolutionary simulations for Environments I, II, III

env = [1,2,3]
alpha = collect(0.05:0.05:8)
yA = 2 .^ collect(-3:0.05:3)
yB = [1.0]
lambda = [1.0]
sensing_cost = [0]
replicate = [1,2,3,4,5,6,7,8,9,10]
d = DataFrame(collect(Iterators.product(env,alpha,yA,yB,lambda,sensing_cost,replicate)))
rename!(d,[:env,:alpha,:yA,:yB,:lambda,:sensing_cost,:replicate])
d.gammaA = [1,2,0.5][d.env]
d.gammaB = [1,2,0.5][d.env]
d.alphaAEvolvable = ["no" for _ in 1:nrow(d)]
d.alphaBEvolvable = ["no" for _ in 1:nrow(d)]
d.populationSize = [500 for _ in 1:nrow(d)]
d.generations = [1001 for _ in 1:nrow(d)]
d.s = [5.0 for _ in 1:nrow(d)]
Random.seed!(123)
d = d[shuffle(1:nrow(d)), :]
CSV.write("sims/evo1.csv",d)

# Evolutionary simulations with arbitrary environments

gammaA = 2.0.^collect(-2:0.1:6)
gammaB = 2.0.^collect(-2:0.1:6)
alpha = collect(1:1:6)
yA = 2 .^ collect(-2:2.0:2)
yB = [1.0]
lambda = [1.0]
sensing_cost = [0]
replicate = [1,2,3,4,5,6,7,8,9,10]
d = DataFrame(collect(Iterators.product(lambda,gammaA,gammaB,yA,yB,alpha,sensing_cost,replicate)))
rename!(d,[:lambda,:gammaA,:gammaB,:yA,:yB,:alpha,:sensing_cost,:replicate])
d.alphaAEvolvable = ["no" for _ in 1:nrow(d)]
d.alphaBEvolvable = ["no" for _ in 1:nrow(d)]
d.populationSize = [500 for _ in 1:nrow(d)]
d.generations = [1001 for _ in 1:nrow(d)]
d.s = [5.0 for _ in 1:nrow(d)]
CSV.write("sims/evo2.csv",d)

# Evolutionary simulations with evolvable sensing

gammaA = 2.0.^collect(-2:0.1:6)
gammaB = 2.0.^collect(-2:0.1:6)
yA = 2 .^ collect(-2:1.0:2)
yB = [1.0]
lambda = [1.0]
sensing_cost = [0.01,0.0125,0.015,0.0175,0.02]
replicate = [1,2,3,4,5,6,7,8,9,10]
alphaBEvolvable = ["yes","no"]
d = DataFrame(collect(Iterators.product(lambda,gammaA,gammaB,yA,yB,sensing_cost,alphaBEvolvable,replicate)))
rename!(d,[:lambda,:gammaA,:gammaB,:yA,:yB,:sensing_cost,:alphaBEvolvable,:replicate])
d.alpha = [0.1 for _ in 1:nrow(d)]
d.alphaAEvolvable = ["yes" for _ in 1:nrow(d)]
d.populationSize = [500 for _ in 1:nrow(d)]
d.generations = [1001 for _ in 1:nrow(d)]
d.s = [5.0 for _ in 1:nrow(d)]
CSV.write("sims/evo3.csv",d)


# Evolutionary simulations with robustness checks

env = [1,2,3]
alpha = [2,3,4]
yA = [4.0]
yB = [1.0]
lambda = [1.0]
sensing_cost = [0]
replicate = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,
45,46,47,48,49,50]
populationSize = [50, 500, 5000]
s = [1.0, 5.0, 10.0]
d = DataFrame(collect(Iterators.product(env,alpha,yA,yB,lambda,sensing_cost,replicate,populationSize,s)))
rename!(d,[:env,:alpha,:yA,:yB,:lambda,:sensing_cost,:replicate,:populationSize,:s])
d.gammaA = [1,2,0.5][d.env]
d.gammaB = [1,2,0.5][d.env]
d.alphaAEvolvable = ["no" for _ in 1:nrow(d)]
d.alphaBEvolvable = ["no" for _ in 1:nrow(d)]
d.generations = [1001 for _ in 1:nrow(d)]
Random.seed!(123)
d = d[shuffle(1:nrow(d)), :]
CSV.write("sims/evo4.csv",d)
