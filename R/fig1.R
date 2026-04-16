source("R/plotting.R")
source("R/functions.R")

bc_threshold <- function(alpha,gamma,lambda){
  I = (1/(alpha*gamma+1))^(1/gamma)
  P = 1/(1-I)
  return((alpha/lambda)*(2*P-1))
}


pdf("plots/fig_1e.pdf",width=4.5,height=4)
plot(0,0,type="n",xlim=c(-2.5,2.5),ylim=c(0,6),bty="n",xaxt="n",yaxt="n",
     xlab="B/C",
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


alpha_threshold <- function(bc, gammaA, gammaB, lambda){
  if(bc==1){return(0)}
  G <- function(x){
    IA = (1/(x*gammaA+1))^(1/(gammaA*lambda))
    IB = (1/(x*gammaB+1))^(1/(gammaB*lambda))
    PA = 1/(1-IA)
    PB = 1/(1-IB)
    return((x/lambda)*(PA+PB-1)-(1+bc))
  }
  return(uniroot(G,c(0.001,1000))$root)
}

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

pdf("plots/fig_S1.pdf",width=4.5,height=4.5)
for(i in 1:2){
  par(pty="s")
  plot(0,0,type="n",xlim=c(-2,4),ylim=c(-2,4),bty="n",xlab="gamma_A",ylab="gamma_B",xaxt="n",yaxt="n")
  axis(side=1,at=seq(-2,4,2),labels=c(0.25,1,4,16))
  axis(side=2,at=seq(-2,4,2),labels=c(0.25,1,4,16),las=2)
  as = c()
  if(i == 1){
    for(x in seq(-2,4,0.05)){
      for(y in seq(-2,4,0.05)){
        gammaA = 2**x
        gammaB = 2**y
        a = alpha_threshold(2, gammaA, gammaB, 1)
        rect(x-0.025,y-0.025,x+0.025,y+0.025,col=intensityColor(a,min=0,max=2.5,resolution=10,colorList=brewer.pal(9,"Blues")),border=NA)
      }
    }
    for(x in c(-1,0,1)){
      points(x,x,pch=21,cex=2,bg="white")
    }
  }
  if(i==2){
    for(a in seq(0.25,2,0.25)){
      gammaA = 2**seq(-2,4,0.01)
      gammaB = sapply(gammaA,function(x){gammaB_threshold(2, a, x, 1)})
      x = log2(gammaA)
      y = log2(gammaB)
      x = x[y>=-2]
      y = y[y>=-2]
      points(x,y,type="l",lty=3,lwd=2)
      #text(max(x,na.rm=T),-2,labels=a,xpd=T)
    }
  }
}
dev.off()
