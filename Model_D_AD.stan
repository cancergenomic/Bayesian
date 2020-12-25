data{
  int<lower=0> N; // The number of the observations
  vector[N] nWBV; // The Response variable
  vector[N] Age; // The predictor variable
  int<lower=0>  G; // The number of the changing levels within Group 
  int<lower = 1,upper=3> Group[N]; // ID for any observation indicating the level that it belongs to
  int<lower=1> C; // The levels of the AD within CDR 
  int<lower=1, upper=C> CDR[N]; // The ID which shows the stage of AD to each observation 
}

parameters{
  real<lower=0> sigma; // SD 
  matrix[2,G] u; // The distribution of the random ( changing) intercepts & slope
  vector<lower=0>[G] sigma_u; // The SD of the varying intercepts normal distribution
  matrix[2,C]w; // The distribution of the random slope and intercept for CDR levels
  vector<lower=0>[C]sigma_w; // SD for w
  real mu;
}

transformed parameters{
  vector[N] nWBV_bar;
  for (i in 1:N){
    for ( k in 1:G){
      for ( l in 1:C){
    nWBV_bar[i] = mu + u[1,Group[k]] + w[1,CDR[l]]+ (u[2,Group[k]] + w[2,CDR[l]]) * Age[i];
  }
}
}
}

model{
  //  Priors 
  sigma_u[1] ~ cauchy(0,1);
  sigma ~ gamma(1,0.1);
  u[1] ~ normal(0,sigma_u[1]);
  u[2] ~ normal(0,sigma_u[2]);
  w[1] ~ normal(0,sigma_w[1]); // The prior for the random intercepts of the CDR levels
  w[2] ~ normal(0,sigma_w[2]); // The prior for the random slope of the CDR levels 
  
  // Likehood 
  
  nWBV ~ normal(nWBV_bar,sigma);
  
}

generated quantities{
  real nWBV_rep[N]; // The replicated nWBV
  
  for ( j in 1:N){
    nWBV_rep[j] = normal_rng(nWBV_bar[j],sigma);
  }
}