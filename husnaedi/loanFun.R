calcJafnarGreidslur <- function(P_init, r, n){
  P <- P_init
  G <- P_init*(r*(1+r)^n)/((1+r)^n -1)
  resData <- list()
  for(i in 1:n){
    VG <- P*r
    P <- P-(G-VG)
    resData[[i]] <- data.frame(HofudstollEftir = P, greidsla = G, 
                               vaxtaGreidsla = VG, afborgun = G-VG, t = i)
  }
  return(resData %>% bind_rows())
}
calcJafnarAfborganir <- function(P_init, r, n){
  P <- P_init
  resData <- list()
  for(i in 1:n){
    VG <- P*r
    A <- P/(n-i+1)
    P <- P-A
    resData[[i]] <- data.frame(HofudstollEftir = P, greidsla = VG + A, 
                               vaxtaGreidsla = VG, afborgun = A, t = i)
  }
  return(resData %>% bind_rows())
}
calcLoan <- function(input){
  loanValues <- list(
    loanAmount = input$loanAmount,
    loanType = input$loanType,
    loanPayType = input$loanPayType,
    vextir = input$vextir,
    timi = input$timi,
    innborgun = input$innborgun)
  P_init <- loanValues$loanAmount*1000000
  r <- loanValues$vextir/100/12
  n <- loanValues$timi*12
  if(input$loanPayType == "Jafnar greiðslur"){
    res <- calcJafnarGreidslur(P_init = P_init, r = r, n = n)
  }else{
    res <- calcJafnarAfborganir(P_init, r, n)
  }
  return(res)
}