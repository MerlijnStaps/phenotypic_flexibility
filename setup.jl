using StatsBase
using Distributions
using DataFrames
using CSV

env = [1,2,3]
alpha = collect(0.05:0.05:8)
yA = 2 .^ collect(-3:0.05:3)
yB = [1.0]
lambda = [1.0]
sensing_cost = [0,0.01,0.02]
d = DataFrame(collect(Iterators.product(env,alpha,yA,yB,lambda,sensing_cost)))
rename!(d,[:env,:alpha,:yA,:yB,:lambda,:sensing_cost])
d.gammaA = [1,2,0.5][d.env]
d.gammaB = [1,2,0.5][d.env]
d.alphaAEvolvable = ["no" for _ in 1:nrow(d)]
d.alphaBEvolvable = ["no" for _ in 1:nrow(d)]
d.populationSize = [500 for _ in 1:nrow(d)]
d.generations = [1001 for _ in 1:nrow(d)]
d.replicates = [5 for _ in 1:nrow(d)]
d.s = [5.0 for _ in 1:nrow(d)]
CSV.write("sims/fig2.csv",d)

gammaA = 2.0.^collect(-2:0.1:6)
gammaB = 2.0.^collect(-2:0.1:6)
alpha = collect(1:1:6)
yA = 2 .^ collect(-2:2.0:2)
yB = [1.0]
lambda = [1.0]
sensing_cost = [0,0.01,0.02]
d = DataFrame(collect(Iterators.product(lambda,gammaA,gammaB,yA,yB,alpha,sensing_cost)))
rename!(d,[:lambda,:gammaA,:gammaB,:yA,:yB,:alpha,:sensing_cost])
d.alphaAEvolvable = ["no" for _ in 1:nrow(d)]
d.alphaBEvolvable = ["no" for _ in 1:nrow(d)]
d.populationSize = [500 for _ in 1:nrow(d)]
d.generations = [1001 for _ in 1:nrow(d)]
d.replicates = [5 for _ in 1:nrow(d)]
d.s = [5.0 for _ in 1:nrow(d)]
CSV.write("sims/fig3.csv",d)

gammaA = 2.0.^collect(-2:0.1:6)
gammaB = 2.0.^collect(-2:0.1:6)
yA = 2 .^ collect(-2:1.0:2)
yB = [1.0]
lambda = [1.0]
sensing_cost = [0.01,0.0125,0.015,0.0175,0.02]
alphaBEvolvable = ["yes","no"]
d = DataFrame(collect(Iterators.product(lambda,gammaA,gammaB,yA,yB,sensing_cost,alphaBEvolvable)))
rename!(d,[:lambda,:gammaA,:gammaB,:yA,:yB,:sensing_cost,:alphaBEvolvable])
d.alpha = [0.1 for _ in 1:nrow(d)]
d.alphaAEvolvable = ["yes" for _ in 1:nrow(d)]
d.populationSize = [500 for _ in 1:nrow(d)]
d.generations = [1001 for _ in 1:nrow(d)]
d.replicates = [5 for _ in 1:nrow(d)]
d.s = [5.0 for _ in 1:nrow(d)]
CSV.write("sims/figS4.csv",d)

yA = 2 .^ collect(-3:1.0:3)
yB = [1.0]
lambda = [1.0]
gammaA = 2.0.^collect(-2:0.1:6)
sensing_cost = 10.0 .^ collect(-3:0.02:0)
d = DataFrame(collect(Iterators.product(yA,yB,lambda,gammaA,sensing_cost)))
rename!(d,[:yA,:yB,:lambda,:gammaA,:sensing_cost])
d.alpha = [0.1 for _ in 1:nrow(d)]
d.gammaB = d.gammaA
d.alphaAEvolvable = ["yes" for _ in 1:nrow(d)]
d.alphaBEvolvable = ["no" for _ in 1:nrow(d)]
d.populationSize = [500 for _ in 1:nrow(d)]
d.generations = [1001 for _ in 1:nrow(d)]
d.replicates = [5 for _ in 1:nrow(d)]
d.s = [5.0 for _ in 1:nrow(d)]
CSV.write("sims/figS5.csv",d)