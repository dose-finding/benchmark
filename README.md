# benchmark
A Benchmark for Dose Finding Studies with Continuous Outcomes

The codes in this repository can be used to reproduce the results in the paper 
A Benchmark for Dose Finding Studies with Continuous Outcomes, Biostatistics, https://doi.org/10.1093/biostatistics/kxy045   

The file "Benchmark for Wang and Ivanova (2015) - Algorithm 1.R" reproduces the results in Table 1, which demonstrate the performance of the benchmark evaluating the design proposed by Wang and Ivanova (2015, Pharm. Stat., 14, 102-107) for trials with a single continuous endpoint. The code also serves as an illustration of Algorithm 1 using the decision criterion given in Equation (2.3).

The file "Benchmark for Bekele and Shen (2005) - Algorithm 2.R" reproduces the results in Table 2, which demonstrate the performance of the benchmark evaluating the design proposed by Bekele and Shen (2005, Biometrics, 61, 344-354) for trials with (correlated) binary toxicity and continuous efficacy endpoints. The code also serves as an illustration of Algorithm 2 using the decision criterion given in Equation (2.5). The code requires the R-package "mvtnorm" for generaing a bivariate normal vector.



            
