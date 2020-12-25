data{
  int<lower=1> N;
  int<lower=0> G;
  int<lower=1,upper=G> Group[N];
  int<lower=1> C;
  int<lower=1,upper=C> CDR[N];
  int<lower=0> M; // The number of the levels within the Male_Female variable 
  int<lower=0,upper=M> MF[N]; // The index 

  int<lower=1> S; // The number of the levels within the SES variable 
  int<lower=0,upper=S> SES[N]; // The index for the levels within SES variable 
  
  int<lower=1> E; // The number of the education levels within EDUC
  int<lower=0,upper=E> EDUC[N];
  
  vector[N] Age;
  vector[N] nWBV; 
}

parameters{
  
  vector[2] beta; 
  real<lower=0> sigma_e; 
  
  matrix[2,G] u; // The distribution for the Group levels 
  vector<lower=0>[G] sigma_u;
  
  matrix[2,C] w; // The distributions for the CDR levels
  vector<lower=0>[C] sigma_w;
  
  matrix[2,M] v; // The distributions for the Male & Female levels
  vector<lower=0>[M] sigma_v;
  
  matrix[2,S] z; // The distributions for the SES levels
  vector<lower=0>[S] sigma_z;
  
  matrix[2,E] h; // The distributio for the EDUC levels 
  vector<lower=0>[E] sigma_h; 
  
  real mu;
}

transformed parameters{
  
  real nWBV_hat[N];
  
  for ( i in 1:N){
    for( j in 1:G){
      for ( k in 1:C){
        for ( l in 1:M){
          for ( m in 1:S){
            for ( p in 1:S){
    nWBV_hat[i] = mu + u[1,Group[j]] +w[1,CDR[k]] + v[1,MF[l]]+ z[1,SES[m]]+h[1,EDUC[p]] +
    ( u[2,Group[j]] + w[2,CDR[k]] + v[2,MF[l]] +z[2,SES[m]] + h[2,EDUC[p]]) * Age[i];
  }
 }
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
  
  w[1] ~ normal(0,sigma_z[1]);
  w[2] ~ normal(0,sigma_z[2]);
  
 // The likelihood
 
  nWBV ~ normal(nWBV_hat,sigma_e);
}

generated quantities{
  real nWBV_rep[N]; // The replicated vector of the existing observation 
  for ( n in 1:N){
    nWBV_rep[n] = normal_rng(nWBV_hat[n],sigma_e);
  }
}