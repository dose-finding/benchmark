##### This code can be used to reproduce the results presented in the paper #####
#####   A Benchmark for Dose Finding Studies with Continuous Outcomes.      #####
#####         The code below corresponds to Algorithm 2 in the paper.       #####


#####                         Section 3.2                                   #####
#####   This section evalutes the performance of the design proposed by     #####
#####         Bekele and Shen (2005) for dose finding trials with           #####
####           binary toxicity and continuous efficacy endpoints             #####

#####                   Specification of Scenario                           #####

# Specifying probabilities of toxicity at all doses
# The length of the vector is equal to the number of doses
tox<-c(0.01,0.10,0.25,0.60)    # Scenario 1

# Specifying the Gamma distributions for all doses and the correlation coefficient
lambda<-c(25,70,115,127)       # Scenario 1
tau<-0.10
correlation<-0.25

# Specifying upper toxicity and lower efficacy bounds and probability thresholds in Equation (2.5)
upper.tox<-0.35
lower.eff<-5
theta1<-theta2<-0.5

# Specifying the total sample size and number of simulations
n<-36
# S<-2000                        # Quick computing
S<-1000000                       # Warning! A long computational time due to binary vectors generating (1.5 hours)

# Request library for generaing bivariate normal vector
library("mvtnorm")

#####                   End of Specification of Scenario                    #####


#####                          Benchmark computing                          #####

response.tox<-response.eff<-mat.or.vec(n,length(lambda))
recom<-mat.or.vec(S,length(lambda))
st.sigma<-rbind(c(1,correlation),c(correlation,1))

set.seed(100)
for(z in 1:S){
  for(j in 1:n){
    # Generating patients' profiles
    vect<-rmvnorm(1, mean = c(0,0), sigma = st.sigma)
    vect<-pnorm(vect)
    # Generating vectors of the complete information
    for (i in 1:length(lambda)){
      response.eff[j,i]<-qgamma(vect[1], shape=tau*lambda[i], rate = tau)
      response.tox[j,i]<-as.numeric(vect[2]<tox[i])
    }
  }
  est.eff<-colMeans(response.eff)
  est.tox<-colMeans(response.tox)
  # Checking toxicity and efficacy conditions
  for (i in 1:length(lambda)){
    toxicity.condition<-pbeta(upper.tox,sum(response.tox[,i]),n-sum(response.tox[,i]),lower.tail = F)>theta1
    efficacy.condition<-pnorm(lower.eff,mean=mean(response.eff[,i]),sd=sqrt(var(response.eff[,i])/n))>theta2
    if(toxicity.condition|efficacy.condition){est.eff[i]<-(-Inf)}
  }
  if(all(est.eff==-Inf)){recom[z,]<-0}else{
    # Selecting the target dose
    target.dose<-which.max(est.eff)
    recom[z,target.dose]<-1
  }
}

#####                                Results                                #####
results<-data.frame(matrix(c(round(colMeans(recom),3),1-sum(colMeans(recom))),nrow=1,ncol=5))
colnames(results)<-c("Dose 1", "Dose 2","Dose 3","Dose 4","None")
rownames(results)<-"Selection"
results
