source("R/plotting.R")
source("R/functions.R")

d = read.table(gzfile("results/fig2_S2_results.csv.gz"),header=T,stringsAsFactors=F,sep=",")
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

bc_threshold <- function(alpha,gamma,lambda){
  I = (1/(alpha*gamma+1))^(1/gamma)
  P = 1/(1-I)
  return((alpha/lambda)*(2*P-1))
}

pdf("plots/fig_2.pdf",width=4,height=4)
for(e in 1:3){
  f = subset(d,d$env == e & d$sensing_cost == 0)
  example_environment_plot(f,strategy_colors[f$strategy],main=paste("Environment",paste(rep("I",e),collapse=""),sep=" "))
  y = seq(0,6,0.01)
  z = sapply(y, function(alpha){bc_threshold(alpha,c(1,2,0.5)[e],1)})
  y = y[log2(z-1) <= 2.5]
  z = z[log2(z-1) <= 2.5]
  points(log2(z-1),y,type="l",lwd=2,lty=2)
  points(-log2(z-1),y,type="l",lwd=2,lty=2)
}
dev.off()

pdf("plots/fig_S2.pdf",width=4,height=4)
for(e in 1:3){
  f = subset(d,d$env == e & d$sensing_cost == 0)
  for(par in c("pAA","pAB","pBA","pBB")){
    example_environment_plot(f,intensityColor(f[,par],min=0,max=1),main=paste(c("Environment ",paste(rep("I",e),collapse="")," ",rename(par)),collapse=""))
  }
}
dev.off()

pdf("plots/fig_S2_legend.pdf",width=2,height=3)
plot(0,0,type="n",xlim=c(0,11),ylim=c(0,1),bty="n",xlab="",ylab="",xaxt="n",yaxt="n")
for(i in 0:10){
  rect(i,0,i+1,1,border=NA,col=intensityColor(0.1*i))
}
dev.off()