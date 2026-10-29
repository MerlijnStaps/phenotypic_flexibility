source("R/plotting.R")
source("R/functions.R")

d = read.table(gzfile("results/evo4_results.csv.gz"),header=T,stringsAsFactors=F,sep=",")
d = d[order(d$env,d$alpha,d$yA),]



d$strategy = sapply(1:nrow(d),function(i){
  call_strategy(d$pAA[i], d$pAB[i], d$pBA[i], d$pBB[i])
})

d$strategy[d$fitness < 0.5*d$yA] = "always A" 
d$strategy[d$fitness < 0.5*d$yB] = "always B" 



rename <- function(par){
  if(par == "pAA"){return("pA")}
  if(par == "pAB"){return("qA")}
  if(par == "pBA"){return("qB")}
  if(par == "pBB"){return("pB")}
}


pdf("plots/fig_S2.pdf",width=5,height=5)
par(mar=c(4.5,3.5,1,1))
par(mfrow=c(3,3))
for(par in c("pAA","pBB")){
  for(s0 in c(1,5,10)){
    for(N0 in c(50,500,5000)){
      d1 = d[d$alpha == 2 & d$s == s0 & d$populationSize == N0 & d$env == 2,]
      par(mgp=c(2,0.75,0))
      
      hist(d1[,par], breaks=seq(0,1,0.05),ylim=c(0,50),xlab=ifelse(par=="pAA","pA","pB"),col="lavender",xaxt="n",yaxt="n",main=paste(s0,N0))
      axis(side=1,at=c(0,0.5,1))
      axis(side=2,at=c(0,25,50),las=2)
    }
  }
}
dev.off()

