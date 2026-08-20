source("R/plotting.R")

pdf("plots/fig_1a.pdf",width=4,height=3.5)
plot(0,0,type="n",xlim=c(0,4),ylim=c(0,1.5),bty="l",xaxt="n",yaxt="n",xlab="",ylab="")
x = seq(0,5,0.01)
y = 0.5*dgamma(x, shape=1/0.5, rate = 1/0.5) + 1*dgamma(x, shape=1/0.1, rate=0.6/0.1)
polygon(c(x,rev(x)),c(y,rep(0,length(x))),col=add.alpha(environment_colors["A"],0.5),border=NA)
points(x,y,type="l",lwd=3,col=environment_colors["A"])

plot(0,0,type="n",xlim=c(0,4),ylim=c(0,1.5),bty="l",xaxt="n",yaxt="n",xlab="",ylab="")
x = seq(0,5,0.01)
y = 1*dgamma(x, shape=1/0.5, rate = 1/0.5) + 0.5*dgamma(x, shape=1/0.05, rate=0.4/0.05)
polygon(c(x,rev(x)),c(y,rep(0,length(x))),col=add.alpha(environment_colors["B"],0.5),border=NA)
points(x,y,type="l",lwd=3,col=environment_colors["B"])
dev.off()


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
