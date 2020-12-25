data{
  int<lower=1> N; // The number of the observations 
  int<lower=1> G; // The number of the levels within the covariate "Group"
  
  vector[N] Age;// The Predictor variable 
  vector[N] nWBV; // The response variable 
  
  int<lower=1,upper=G> Group[N]; // The index for the levels
}

parameters{
   
  real<lower=0> sigma_e;
  
  matrix[2,G] u; // The changing intercepts within the Group levels as normal 
  vector<lower=0>[G] sigma_u; // The SD for the distribution of the changing intercepts 
   real mu;
}


transformed parameters{
  real nWBV_hat[N];
  for ( i in 1:N){
    for( j in 1:G){
    nWBV_hat[i] = mu + u[1,Group[j]] + ( u[2,Group[j]]) * Age[i];
  }
  }
}

model{
  
  sigma_u[1] ~ cauchy(0,0.5);
  sigma_u[2] ~ cauchy(0,0.5);
  sigma_u[3] ~ cauchy(0,0.5);
  sigma_e ~ cauchy(0,0.5);
  u[1] ~ normal(0,sigma_u[1]); // The prior 
  u[2] ~ normal(0,sigma_u[2]);
 
  // The likelihood 
  nWBV ~ normal(nWBV_hat,sigma_e);
}

generated quantities{
  
  vector[N] nWBV_rep;
  for ( n in 1:N){
    nWBV_rep[n] = normal_rng(nWBV_hat[n],sigma_e);
  }
}
