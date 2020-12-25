data{
  int<lower=1> N; // The number of the observations 
  int<lower=1> G; // The number of the levels within the variable " Group"
  int<lower=0,upper=G> Group[N];
  
  int<lower=1> C; // The number of the levels within the variable "CDR"
  int<lower=0,upper=C> CDR[N];  // The index  
  
  vector[N] Age; // The predictor Variable 
  vector[N] nWBV; // The response Variable 
}

parameters{
  
  real<lower=0> sigma_e; // SD 
  // The Demantic or Not ?
  matrix[2,G] u; // vector u[1,G] : changing intercept,vector u[2,G]: changing slope 
  vector<lower=0>[G] sigma_u; // The SD 
  
  matrix[2,C] w; // vector w[1,C] : changing intercept , vector w[2,C]:changing slope 
  vector<lower=0>[C] sigma_w; // the DS
  
  real mu;
  
}

transformed parameters{
  real nWBV_hat[N];
  for ( i in 1:N){
    for( j in 1:G){
      for ( k in 1:C){
    nWBV_hat[i] = mu + u[1,Group[j]] +w[1,CDR[k]] + ( u[2,Group[j]] + w[2,CDR[k]]) * Age[i];
  }
 }
}
}
model{
  // The priors
  
  u[1] ~ normal(0,sigma_u[1]);
  u[2] ~ normal(0,sigma_u[2]);
  
  
  w[1] ~ normal(0,sigma_w[1]);
  w[2] ~ normal(0,sigma_w[2]);
  
  
 // The likelihhod 
  nWBV ~ normal(nWBV_hat,sigma_e);
}


generated quantities{
  real nWBV_rep[N]; // The replicated vector of the existing observation 
  for ( n in 1:N){
    nWBV_rep[n] = normal_rng(nWBV_hat[n],sigma_e);
  }
}