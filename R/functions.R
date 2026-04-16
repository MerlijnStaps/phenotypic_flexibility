call_strategy <- function(pAA, pAB, pBA, pBB){
  if(pAA == 0 & pBA == 0){return("always B")}
  if(pBB == 0 & pAB == 0){return("always A")}
  if(pAA == 1 & pAB == 0 & pBA == 0 & pBB == 1){return("naive_flexible")}
  if(pAA == 1 & pAB > 0 & pBA == 0 & pBB == 1){return("anticipate B")}
  if(pAA == 1 & pAB == 0 & pBA > 0 & pBB == 1){return("anticipate A")}
  if(pAA == 1 & pAB == 0 & pBA == 0 & pBB < 1){return("delay B")}
  if(pAA < 1 & pAB == 0 & pBA == 0 & pBB == 1){return("delay A")}
  return("other")
}