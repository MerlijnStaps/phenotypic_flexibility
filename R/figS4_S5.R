source("R/plotting.R")
source("R/functions.R")

d = read.table(gzfile("results/figS4_S5_results.csv.gz"),header=T,stringsAsFactors=F,sep=",")
d = d[order(d$yA,d$lambda,d$gammaA,d$gammaB,d$alpha),]
d$strategy = sapply(1:nrow(d),function(j){
  call_strategy(d$pAA[j], d$pAB[j], d$pBA[j], d$pBB[j])
})
d$strategy[d$fitness <= 0.5*d$yA] = "always A" 
d$strategy[d$fitness <= 0.5*d$yB] = "always B" 
d$alphaA[d$fitness <= 0.5*pmax(d$yA,d$yB)] = NA

pdf("plots/fig_S4_S5.pdf",width=4,height=4)

par(pty="s")

for(i in 1:2){
  for(c_sensing in c(0.01,0.015,0.02)){
    for(bc in c(0.25,1,4)){
      d1 = d[d$sensing_cost == c_sensing & d$yA == bc & d$alphaBEvolvable == ifelse(i==2,"no","yes") & d$gammaA <= 16 & d$gammaB <= 16,]
      
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

