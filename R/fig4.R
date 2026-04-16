source("R/plotting.R")
source("R/functions.R")

adapted_probability <- function(alpha,lambda,gammaA,gammaB){
  return(1 + lambda/(alpha*(-1 + 1/(1 - (gammaA/lambda)**(1/gammaA)*(alpha + lambda/gammaA)**(1/gammaA)) + 1/(1 - (gammaB/lambda)**(1/gammaB)*(alpha + lambda/gammaB)**(1/gammaB)))))
}

PA <- function(alphaA, alphaB, lambda, gammaA, gammaB){
  1 + lambda/(alphaA*(-1 + 1/(1 - (gammaA/lambda)**(1/gammaA)*(alphaA + lambda/gammaA)**(1/gammaA)) + 1/(1 - (gammaB/lambda)**(1/gammaB)*(alphaB + lambda/gammaB)**(1/gammaB))))
}

PB <- function(alphaA, alphaB, lambda, gammaA, gammaB){
  1 + lambda/(alphaB*(-1 + 1/(1 - (gammaA/lambda)**(1/gammaA)*(alphaA + lambda/gammaA)**(1/gammaA)) + 1/(1 - (gammaB/lambda)**(1/gammaB)*(alphaB + lambda/gammaB)**(1/gammaB))))
}

naive_fitness_asymmetric <- function(alphaA, alphaB, lambda, gammaA, gammaB, yA, yB, sensing_cost = 0){
  PAvalue = PA(alphaA, alphaB, lambda, gammaA, gammaB)
  PBvalue = PB(alphaA, alphaB, lambda, gammaA, gammaB)
  fitness = 0.5*PAvalue*yA + 0.5*PBvalue*yB - sensing_cost * (0.5*alphaA + 0.5*alphaB) * (0.5*yA + 0.5*yB)
  return(fitness)
}

naive_fitness <- function(alpha,lambda,gammaA,gammaB,yA,yB,sensing_cost=0){
  P = adapted_probability(alpha,lambda,gammaA,gammaB)
  fitness = 0.5*(yA+yB)*P - sensing_cost * alpha * 0.5*(yA+yB)
  return(fitness)
}

optimal_alpha <- function(lambda,gammaA,gammaB,yA,yB,sensing_cost=0,min=10**-5,max=25){
  optim = nlminb(1,function(x){-naive_fitness(x,lambda,gammaA,gammaB,yA,yB,sensing_cost)},lower=min,upper=max)
  return(setNames(c(optim$par,-optim$objective),c("alpha","fitness")))
}

optimal_alpha_asymmetric <- function(lambda,gammaA,gammaB,yA,yB,sensing_cost=0,min=10**-5,max=25){
  optim = nlminb(c(1,1),function(x){-naive_fitness_asymmetric(x[1],x[2],lambda,gammaA,gammaB,yA,yB,sensing_cost)},lower=min,upper=max)
  return(setNames(c(optim$par[1],optim$par[2],-optim$objective),c("alphaA","alphaB","fitness")))
}


pdf("plots/fig_4a.pdf",width=3.5,height=4.5)
for(yA in c(1,4)){
  yB = 1
  lambda = 1
  
  plot(0,0,type="n",xlim=c(-2,4),ylim=c(0,10),bty="n",
       xlab=expression(paste("CV(",tau,")")), ylab=expression(paste("Optimal observation rate ",alpha,"")),xaxt="n",yaxt="n")
  axis(side=1,at=seq(-2,4,2),labels=c(0.5,1,2,4),tck=-0.02)
  axis(side=2,las=2,at=seq(0,10,2),tck=-0.02)
  
  c1s = c(0.01,0.02,0.05,0.1,0.5)#10**seq(-2,0,0.2)
  colors = colorRampPalette(brewer.pal(9,"YlOrBr")[3:9])(5)
  for(i in 1:length(c1s)){
    gammas = 2**seq(-2,4,0.1)
    c1 = c1s[i]
    optimal_alphas = sapply(gammas,function(g){
      optimal_alpha(lambda,g,g,yA,yB,c1,min=10**-5)
    })
    is = which(optimal_alphas[2,] > max(0.5*yA,0.5*yB))
    js = which(optimal_alphas[2,] < max(0.5*yA,0.5*yB))
    optimal_alphas[1,js] = 0
    points(log2(gammas),optimal_alphas[1,],type="l",lwd=5,col=add.alpha(colors[i],0.7))
    #points(log2(gammas)[js],rep(0,length(js)),type="l",lwd=3,col=colors[i])
    text(log2(gammas)[length(gammas)]+0.1,optimal_alphas[1,length(gammas)],round(c1,3),xpd=T,adj=0)
  }
}
dev.off()



pdf("plots/fig_4b.pdf",width=3,height=3)
par(pty="s")

for(yA in c(1,4)){
  yB = 1
  lambda = 1
  c1 = 0.02
  
  d = expand.grid(gammaA = 2**seq(-2,4,0.1),gammaB=2**seq(-2,4,0.1))
  optimal_alphas = lapply(1:nrow(d),function(i){
    optimal_alpha_asymmetric(lambda,d$gammaA[i],d$gammaB[i],yA,yB,sensing_cost= c1,max=50)
  })
  d$alphaA = sapply(optimal_alphas,function(x){x["alphaA"]})
  d$alphaB = sapply(optimal_alphas,function(x){x["alphaB"]})
  d$fitness = sapply(optimal_alphas,function(x){x["fitness"]})
  
  for(i in 1:2){
    plot(0,0,type="n",xlim=c(-2,4),ylim=c(-2,4),bty="n",xaxt="n",yaxt="n",
         xlab=expression(paste("CV(",tau,"good)")),
         ylab=expression(paste("CV(",tau,"bad)"))
    )
    axis(side=1,at=seq(-2,4,2),labels=c(0.5,1,2,4),tck=-0.05)
    axis(side=2,at=seq(-2,4,2),labels=c(0.5,1,2,4),tck=-0.05,las=2)
    x = log2(d$gammaA)
    y = log2(d$gammaB)
    if(i==1){
      rect(x-0.05,y-0.05,x+0.05,y+0.05,border=NA,col=intensityColor(0.5*(d$alphaA+d$alphaB),min=0,max=8,resolution=15,colorList=brewer.pal(9,"BuPu")))
    }
    if(i==2){
      rect(x-0.05,y-0.05,x+0.05,y+0.05,border=NA,col=intensityColor(atan(d$alphaA-d$alphaB),min=-1.5,max=1.5,resolution=ifelse(yA==4,30,15),colorList=brewer.pal(9,"PRGn")))
    }
  }
}

plot(0,0,type="n",xlim=c(0,1),ylim=c(0,3))
for(i in 1:100){
  rect(0.01*(i-1),2,0.01*i,3,border=NA,col=intensityColor(0.01*8*i,min=0,max=8,resolution=15,colorList=brewer.pal(9,"BuPu")))
}
for(i in 1:100){
  rect(0.01*(i-1),0,0.01*i,1,border=NA,col=intensityColor(atan(-5+0.1*i),min=-1.5,max=1.5,resolution=30,colorList=brewer.pal(9,"PRGn")))
}
dev.off()


