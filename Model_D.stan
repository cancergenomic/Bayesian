data{
  int<lower=1> N;
  int<lower=0> G;
  int<lower=1,upper=G> Group[N];
  int<lower=1> C;
  int<lower=1,upper=C> CDR[N];
  int<lower=1> M; // The number of the levels within the Male_Female variable 
  int<lower=0,upper=M> MF[N]; // The index 
  vector[N] Age;
  vector[N] nWBV; 
}

parameters{
  
  vector[2] beta; 
  real<lower=0> sigma_e; 
  
  matrix[2,G] u;
  vector<lower=0>[G] sigma_u;
  
  matrix[2,C] w;
  vector<lower=0>[C] sigma_w;
  
  matrix[2,M] v;
  vector<lower=0>[M] sigma_v;
  
  real mu;
}

transformed parameters{
  
  real nWBV_hat[N];
  
  for ( i in 1:N){
    for( j in 1:G){
      for ( k in 1:C){
        for ( l in 1:M){
    nWBV_hat[i] = mu + u[1,Group[j]] +w[1,CDR[k]] + v[1,MF[l]]+
    ( u[2,Group[j]] + w[2,CDR[k]] + v[2,MF[l]]) * Age[i];
  }
 }
}
}
}
model{
  
  // The priors 
  
  u[1] ~ normal(0,sigma_u[1]); // Prior for the intercept 
  u[2] ~ normal(0,sigma_u[2]); // Prior for the slope 
  
  w[1] ~ normal(0,sigma_w[1]);
  w[2] ~ normal(0,sigma_w[2]);
  
  v[1] ~ normal(0,sigma_v[1]);
  
  

  
  nWBV ~ normal(nWBV_hat,sigma_e);
}

generated quantities{
  real nWBV_rep[N]; // The replicated vector of the existing observation 
  for ( n in 1:N){
    nWBV_rep[n] = normal_rng(nWBV_hat[n],sigma_e);
  }
}