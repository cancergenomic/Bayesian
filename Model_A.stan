data{
  int<lower=1> N; // The number of the observations 
  vector[N] Age; 
  vector[N] nWBV;
}

parameters{
  
  vector[2] beta; // beta[1]: Fixed Intercept & beta[2]: Fixed Slope 
  real<lower=0> sigma_e;
}

model{
  
  nWBV ~ normal(beta[1] + beta[2] * Age,sigma_e);
}

generated quantities{
  real nWBV_rep[N];
  for (n in 1:N){
    nWBV_rep[n] = normal_rng(beta[1] + beta[2] *Age[n],sigma_e);
  }
}