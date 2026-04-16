
################################################################################
# Plotting basics
################################################################################

library(RColorBrewer)

# Colors

environment_colors = setNames(c("#C6E9AF","#447821"),c("B","A"))
environment_colors["good"] = environment_colors["A"]
environment_colors["bad"] = environment_colors["B"]

strategy_colors = setNames(NA, "other")
strategy_colors["always A"] = "#666666"
strategy_colors["always B"] = "#cccccc"
strategy_colors["naive_flexible"] = "#aaeeff"
strategy_colors["delay A"] = "#b380ff"
strategy_colors["delay B"] = "#ff8080"
strategy_colors["anticipate A"] = "#ffe680"
strategy_colors["anticipate B"] = "#deaa87"

# Functions

add.alpha <- function(cols, alpha) rgb(t(col2rgb(cols)/255), alpha = alpha)

intensityColor <- function(values,min=0,max=1,resolution=1000,colorList=brewer.pal(5,"PuRd")){
  colorsToUse = colorRampPalette(colorList)(resolution)
  normalizedValues = ((values-min)/(max-min))
  bins = seq(0,1,length.out=resolution+1)
  roundedNormalizedValues = sapply(normalizedValues, function(u){sum(bins <= u)})
  return(colorsToUse[pmin(roundedNormalizedValues,resolution)])
}

power2label <- function(x){
  string = paste(c("2^",x),collapse="")
  return(parse(text=string))
}
power10label <- function(x){
  string = paste(c("10^",x),collapse="")
  return(parse(text=string))
}

################################################################################
## Specific plot designs
################################################################################

example_environment_plot <- function(d,colors,main="",dx=0.05,dy=0.05){
  plot(0,0,type="n",xlim=c(-2.5,2.5),ylim=c(0,6),bty="n",xaxt="n",yaxt="n",
       xlab="B/C",
       ylab=expression(paste("Observation rate (",alpha,")")),main=main)
  par(mgp=c(2,0.5,0))
  axis(side=1,at=seq(-2,2,1),labels=c(0.25,0.5,1,2,4),tck=-0.02)
  axis(side=2,las=2,at=seq(0,6,2),tck=-0.02)
  rows_to_use = which(abs(log2(d$B)) <= 2.5 & d$alpha <= 6)
  x = log2(d[rows_to_use,"B"])
  y = d[rows_to_use,"alpha"]
  rect(x-dx/2,y-dy/2,x+dx/2,y+dy/2,col=colors[rows_to_use],border=NA)
}
