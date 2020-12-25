data{
  int<lower=0> N; // The number of the observations
  vector[N] nWBV; // The Response variable
  vector[N] Age; // The predictor variable
  int<lower=0>  G; // The number of the changing levels within Group 
  int<lower = 1,upper=3> Group[N]; // ID for any observation indicating the level that it belongs to
  
}

parameters{
  real<lower=0> sigma; // SD 
  matrix[2,G] u; // The distribution of the random ( changing) intercepts & slope
  vector<lower=0>[G] sigma_u; // The SD of the varying intercepts normal distribution
  real mu;
}

transformed parameters{
  vector[N] nWBV_bar;
  for (i in 1:N){
    for ( k in 1:G){
    nWBV_bar[i] = mu + u[1,Group[k]]+ (u[2,Group[k]]) * Age[i];
  }
}
}

model{
  //  Priors 
  sigma_u[1] ~ cauchy(0,1);
  sigma ~ gamma(1,0.1);
  u[1] ~ normal(0,sigma_u[1]);
  u[2] ~ normal(0,sigma_u[2]);
  
  // Likehood 
  
  nWBV ~ normal(nWBV_bar,sigma);
  
}

generated quantities{
  real nWBV_rep[N]; // The replicated nWBV
  
  for ( j in 1:N){
    nWBV_rep[j] = normal_rng(nWBV_bar[j],sigma);
  }
}