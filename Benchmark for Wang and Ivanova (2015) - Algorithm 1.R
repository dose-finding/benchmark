##### This code can be used to reproduce the results presented in the paper #####
#####   A Benchmark for Dose Finding Studies with Continuous Outcomes.      #####
#####         The code below corresponds to Algorithm 1 in the paper.       #####


#####                         Section 3.1                                   #####
#####   This section evalutes the performance of the design proposed by     #####
#####  Wang and Ivanova (2015) for dose finding trials with cont. outcomes  #####

#####                   Specification of Scenarios                          #####

# Specifying means for the (Normal) distribution of outcomes at all doses
# The length of the vector is equal to the number of doses
mu<-c(0.1,0.2,0.3,0.4,0.5,0.6)  

# Specifying standard deviations for the (Normal) distribution of outcomes at all doses
# The length of the vector is equal to the number of doses
sigma<-rep(0.2^2,6)              # Equal variances case
# sigma<-seq(1,6,1)^2*0.1^2      # Unequal variances case

# Target toxicity level
target<-0.1                      # The target in Scenario 1

# Specifying the value of \epsilon for the decision rule (2.3)
epsilon<-0.01

# Specifying number of patients N
n<-36

# Specifying number of simulations S
# S<-2000                        # Quick computing
S<-1000000                    # Warning! A long computational time (6 minutes)

#####                   End of Specification of Scenarios                   #####


#####                          Benchmark computing                          #####
response<-mat.or.vec(n,length(mu))
recom<-mat.or.vec(S,length(mu))
prob<-var<-mat.or.vec(1,6)

set.seed(100)
for(z in 1:S){
  # Generating vectors of the complete information
  for(j in 1:n){response[j,]<-sqrt(sigma)*qnorm(runif(1,0,1))+mu}    
  est<-colMeans(response)
  # Computing the probabilities given in Equation (2.3)
  for (i in 1:6){var[i]<-var(response[,i])
    prob[i]<-pnorm(target+epsilon, mean = est[i], sd= sqrt(var[i]/n))-pnorm(target-epsilon, mean = est[i], sd = sqrt(var[i]/n))
  }
  # Choose the dose corresponding to the maximum probability
  target.dose<-which.max(prob)
  recom[z,target.dose]<-1
}

#####                                Results                                #####
results<-data.frame(matrix(round(colMeans(recom),2),nrow=1,ncol=6))
colnames(results)<-c("Dose 1", "Dose 2","Dose 3","Dose 4","Dose 5","Dose 6")
rownames(results)<-"Selection"
results
