data{
  int<lower=1> N; // The number of the observations 
  int<lower=1> G; // The number of the levels within the covariate "Group"
  
  vector[N] Age;// The Predictor variable 
  vector[N] nWBV; // The response variable 
  
  int<lower=1,upper=G> Group[N]; // The index for the levels
}

parameters{
  vector[2] beta; // beta[1] : Fixed Intercept & beta[2]: Fixed Slope 
  real<lower=0> sigma_e;
  
  vector[G] u; // The changing intercepts within the Group levels as normal 
  real<lower=0> sigma_u; // The SD for the distribution of the changing intercepts 
}

model{
  real mu; 

  u ~ normal(0,sigma_u); // The prior 
 
  for ( i in 1:N){
  mu = beta[1] + u[Group[i]] + beta[2]* Age[i];
  nWBV[i] ~ normal(mu,sigma_e);
}
}