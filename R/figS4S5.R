source("R/plotting.R")
source("R/functions.R")

ds = list()
ds[[1]] = read.table(gzfile("results/gammas_alpha_evolvable_results.csv.gz"),header=T,stringsAsFactors=F,sep=",")
ds[[2]] = read.table(gzfile("results/symmetric_costs_results.csv.gz"),header=T,stringsAsFactors=F,sep=",")

for(i in 1:2){
  ds[[i]] = ds[[i]][order(ds[[i]]$yA,ds[[i]]$lambda,ds[[i]]$gammaA,ds[[i]]$gammaB,ds[[i]]$alpha),]
  ds[[i]]$strategy = sapply(1:nrow(ds[[i]]),function(j){
    call_strategy(ds[[i]]$pAA[j], ds[[i]]$pAB[j], ds[[i]]$pBA[j], ds[[i]]$pBB[j])
  })
  ds[[i]]$strategy[ds[[i]]$fitness <= 0.5*ds[[i]]$yA] = "always A" 
  ds[[i]]$strategy[ds[[i]]$fitness <= 0.5*ds[[i]]$yB] = "always B" 
  ds[[i]]$alphaA[ds[[i]]$fitness <= 0.5*pmax(ds[[i]]$yA,ds[[i]]$yB)] = NA
}

d = rbind(ds[[1]],ds[[2]])

pdf("plots/fig_S4_S5.pdf",width=4,height=4)

par(pty="s")

for(i in 1:2){
  for(c_sensing in c(0.01,0.015,0.02)){
    for(bc in c(0.25,1,4)){
      d1 = d[d$sensing_cost == c_sensing & d$yA == bc & d$alphaBEvolvable == ifelse(i==2,"no","yes"),]
      
      plot(0,0,type="n",xlim=c(-2,4),ylim=c(-2,4),bty="n",xaxt="n",yaxt="n",
           xlab=expression(paste("CV(",tau,"good)")),
           ylab=expression(paste("CV(",tau,"bad)")),
           main=paste(c("yA/yB=",bc,", c_sensing=",c_sensing,", ",ifelse(i==2,"symmetric","asymmetric")),collapse="")
      )
      axis(side=1,at=seq(-2,4,2),labels=c(0.5,1,2,4),tck=-0.025)
      axis(side=2,at=seq(-2,4,2),labels=c(0.5,1,2,4),tck=-0.025,las=2)
      x = log2(d1$gammaA)
      y = log2(d1$gammaB)
      rect(x-0.05,y-0.05,x+0.05,y+0.05,border=NA,col=strategy_colors[d1$strategy])
    }
  }
}
dev.off()

