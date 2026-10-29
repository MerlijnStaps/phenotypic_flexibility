source("R/plotting.R")


pdf("plots/fig_2b_distributions.pdf",width=4,height=3.5)
for(gamma in c(1,0.5,2)){
  plot(0,0,type="n",xlim=c(0,3),ylim=c(0,.8),bty="l",xaxt="n",yaxt="n",xlab="",ylab="")
  x = seq(0,5,0.01)
  y = 0.5*dgamma(x, shape=1/gamma, rate = 1/gamma)
  polygon(c(x,rev(x)),c(y,rep(0,length(x))),col=add.alpha("gray",0.5),border=NA)
  points(x,y,type="l",lwd=3,col="gray")
}
dev.off()

pdf("plots/fig_2b_time_series.pdf",width=5,height=4)
set.seed(66)
maxt = 50
plot(0,0,type="n",xlim=c(0,maxt),ylim=c(0.5,3.5),bty="n",xaxt="n",yaxt="n",xlab="",ylab="")
for(i in 1:3){
  x = 0
  gamma = c(1, 2, 0.5)[i]
  environment = "A"
  while(x < maxt){
    t = rgamma(n=1, shape=1/gamma, rate=1/gamma)
    rect(x, 4-i-0.3, min(maxt,x+t), 4-i+0.3, col=environment_colors[environment],border=NA)
    x = x+t
    environment = ifelse(environment=="A","B","A")
  }
}
dev.off()


bc_threshold <- function(alpha,gamma,lambda){
  I = (1/(alpha*gamma+1))^(1/gamma)
  P = 1/(1-I)
  return((alpha/lambda)*(2*P-1))
}


pdf("plots/fig_2c.pdf",width=4.5,height=4)
plot(0,0,type="n",xlim=c(-2.5,2.5),ylim=c(0,6),bty="n",xaxt="n",yaxt="n",
     xlab="yA/yB",
     ylab=expression(paste("Observation rate (",alpha,")")))
axis(side=1,at=seq(-2,2,1),labels=c(0.25,0.5,1,2,4),tck=-0.02)
axis(side=2,las=2,at=seq(0,6,2),tck=-0.02)

y = seq(0,6,0.01)
z = sapply(y, function(alpha){bc_threshold(alpha,1,1)})
y = y[log2(z-1) <= 2.5]
z = z[log2(z-1) <= 2.5]
y = y[!is.na(y)]
z = z[!is.na(z)]
x = log2(z-1)
polygon(c(x,rev(x)),c(y,rep(0,length(y))),col=strategy_colors["always A"],border=NA)
polygon(-c(x,rev(x)),c(y,rep(0,length(y))),col=strategy_colors["always B"],border=NA)
polygon(c(rev(-x),x,2.5,-2.5),c(rev(y),y,6,6),col=strategy_colors["naive_flexible"],border=NA)
points(x,y,type="l",lwd=1)
points(-x,y,type="l",lwd=1)

for(gamma in c(0.5,2)){
  y = seq(0,6,0.01)
  z = sapply(y, function(alpha){bc_threshold(alpha,gamma,1)})
  y = y[log2(z-1) <= 2.5]
  z = z[log2(z-1) <= 2.5]
  y = y[!is.na(y)]
  z = z[!is.na(z)]
  x = log2(z-1)
  points(x,y,type="l",lwd=1,lty=2)
  points(-x,y,type="l",lwd=1,lty=2)
}
dev.off()
