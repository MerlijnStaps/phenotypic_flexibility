source("R/plotting.R")

d = read.table(gzfile("results/fig3_results.csv.gz"),header=T,stringsAsFactors=F,sep=",")
d = d[order(d$yA,d$lambda,d$gammaA,d$gammaB,d$alpha),]
d = d[d$gammaA <= 16 & d$gammaB <= 16,]
d$strategy = sapply(1:nrow(d),function(i){
  call_strategy(d$pAA[i], d$pAB[i], d$pBA[i], d$pBB[i])
})

alphas = sort(unique(d$alpha))

gammaB_threshold <- function(bc, alpha, gammaA, lambda){
  G <- function(x){
    IA = (1/(alpha*gammaA+1))^(1/(gammaA*lambda))
    IB = (1/(alpha*x+1))^(1/(x*lambda))
    PA = 1/(1-IA)
    PB = 1/(1-IB)
    return((alpha/lambda)*(PA+PB-1)-(1+bc))
  }
  if(G(0.001)*G(1000) < 0){
    return(uniroot(G,c(0.001,1000))$root)
  }
  return(NA)
}

pdf("plots/fig_3_S3.pdf",width=5,height=5)
par(pty="s")
for(bc in c(0.25,1,4)){
  for(a in alphas){
    plot(0,0,type="n",xlim=c(-2,4),ylim=c(-2,4),bty="n",xlab="gamma_A",ylab="gamma_B",main=paste(bc,a,sep=" "))
    f = subset(d,d$yA == bc & d$alpha == a)
    x = log2(f$gammaA)
    y = log2(f$gammaB)
    rect(x-0.05,y-0.05,x+0.05,y+0.05,border=NA,col=strategy_colors[f$strategy])
    gammaA = 2**seq(-2,4,0.01)
    gammaB = sapply(gammaA, function(x){gammaB_threshold(max(bc,1/bc),a,x,1)})
    gammaA = gammaA[gammaB > 0.25]
    gammaB = gammaB[gammaB > 0.25]
    points(log2(gammaA),log2(gammaB),type="l",lwd=2,lty=3)
  }
}
dev.off()
