data{
  int<lower=1> N; // The number of the observations 
  int<lower=1> G; // The number of the levels within the covariate "Group"
  
  vector[N] Age;// The Predictor variable 
  vector[N] nWBV; // The response variable 
  
  int<lower=1,upper=G> Group[N]; // The index for the levels
}

parameters{
  vector[G] u; // The changing intercepts forms a vector 
  real<lower=0> sigma_u; // The SD 
  real<lower=0> sigma_e; 
  real<lower=0> mu;
}

transformed parameters{
  vector[N] nWBV_bar; 
  
  for ( i in 1:N){
    nWBV_bar[i] = mu + u[Group[i]];
  }
}

model{
    sigma_u ~ cauchy(0,2.5);
    sigma_e ~ gamma(2,0.1);
    u ~ normal(0,sigma_u);
    
    // The likelihoods 
    
    nWBV ~ normal(nWBV_bar,sigma_e);
}

generated quantities{
  real nWBV_rep[N]; // The replicated vector of the existing observation 
  for ( n in 1:N){
    nWBV_rep[n] = normal_rng(nWBV_bar[n],sigma_e);
    
  }
}