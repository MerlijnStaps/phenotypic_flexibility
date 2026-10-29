mutable struct Environment
    gammaA::Float64
    gammaB::Float64
    lambda::Float64
end

mutable struct Strategy # with alpha evolvable
    pAA::Float64
    pAB::Float64
    pBA::Float64
    pBB::Float64
    alphaA::Float64
    alphaB::Float64
end

function gammaLaplaceTransform(s, gamma, lambda)
    return((s*gamma/lambda+1.0)^(-1.0/gamma))
end

function calculateFitness(environment, strategy, parameters)
    alphaA = strategy.alphaA
    alphaB = strategy.alphaB
    alpha = max(1.0,max(alphaA,alphaB))
    pAA = strategy.pAA * (alphaA/alpha)
    pAB = strategy.pAB * (alphaA/alpha)
    pBA = strategy.pBA * (alphaB/alpha)
    pBB = strategy.pBB * (alphaB/alpha)
    rA = alpha*(pAA + pAB)
    rB = alpha*(pBA + pBB)
    yA = parameters["yA"]
    yB = parameters["yB"]
    if rA == 0 && rB == 0
        PA = 0.5
        PB = 0.5
    elseif rA > 0 && rB == 0
        sA = pAA/(pAA + pAB)
        PA = sA
        PB = 1-sA
    elseif rA == 0 && rB > 0
        sB = pBB/(pBA + pBB)
        PA = 1-sB 
        PB = sB
    elseif rA > 0 && rB > 0
        sA = pAA/(pAA + pAB)
        sB = pBB/(pBA + pBB)
        lambda = environment.lambda
        function fA(s)
            gammaLaplaceTransform(s,environment.gammaA,lambda)
        end
        function fB(s)
            gammaLaplaceTransform(s,environment.gammaB,lambda)
        end      
        PA = sA - (lambda/rA)*(sA+sB-1.0)*(1.0-fA(rA))*(1.0-fB(rB))/(1.0-fA(rA)*fB(rB))
        PB = sB - (lambda/rB)*(sA+sB-1.0)*(1.0-fA(rA))*(1.0-fB(rB))/(1.0-fA(rA)*fB(rB))
    end
    F = 0.5*yA*PA + 0.5*yB*PB - parameters["sensing_cost"] * (0.5*alphaA + 0.5*alphaB) * (0.5*yA + 0.5*yB)
    return(F)
end

function mutate!(x, dist; lower = 0.0, upper = 1.0, mutationProbability = 1.0)
    if rand() < mutationProbability
        x = x + rand(dist)
        x = min(x,upper)
        x = max(x,lower)
    end
    return(x)
end

function mutateStrategy!(strategy;mutationProbability=0.05,mutationSize=0.25,alphaAEvolvable="no",alphaBEvolvable="no")
    strategy.pAA = round(mutate!(strategy.pAA, Normal(0, mutationSize), mutationProbability = mutationProbability),digits=5)
    strategy.pAB = round(mutate!(strategy.pAB, Normal(0, mutationSize), mutationProbability = mutationProbability),digits=5)
    strategy.pBA = round(mutate!(strategy.pBA, Normal(0, mutationSize), mutationProbability = mutationProbability),digits=5)
    strategy.pBB = round(mutate!(strategy.pBB, Normal(0, mutationSize), mutationProbability = mutationProbability),digits=5)
    if alphaAEvolvable == "yes"
        strategy.alphaA = mutate!(strategy.alphaA, Normal(0, 2.5), lower = 0.0, upper = 100.0, mutationProbability = mutationProbability)
        if alphaBEvolvable == "no"
            strategy.alphaB = strategy.alphaA
        end
    end
    if alphaBEvolvable == "yes"
        strategy.alphaB = mutate!(strategy.alphaB, Normal(0, 2.5), lower = 0.0, upper = 100.0, mutationProbability = mutationProbability)
    end
end

function evolutionarySimulation(environment, parameters, simulationParameters, alphaAEvolvable = "no", alphaBEvolvable = "no")
    n = simulationParameters["populationSize"]
    population = [Strategy(rand(),rand(),rand(),rand(),parameters["alpha"],parameters["alpha"]) for _ in 1:n]
    g = simulationParameters["generations"]
    for t in 1:g
        for s in population
            mutateStrategy!(s,alphaAEvolvable = alphaAEvolvable, alphaBEvolvable = alphaBEvolvable)
        end
        fitnesses = [calculateFitness(environment, s, parameters) for s in population]
        weights = map(x -> exp(log(10.0) * parameters["s"] * x/(parameters["yA"]+parameters["yB"])), fitnesses)
        population = [deepcopy(sample(population,StatsBase.Weights(weights))) for i in 1:n]
    end
    fitnesses = [calculateFitness(environment, s, parameters) for s in population]
    winner = population[findmax(fitnesses)[2]]
    return(Dict("population" => population, "winner" => winner, "fitnesses" => fitnesses, "winner_fitness" => findmax(fitnesses)[1]))
end
