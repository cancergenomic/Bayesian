data{
  
  int<lower=1> N; // The number of the observations
  vector[N] Y; // The Response variable 
  vector<lower=0,upper=1>[N] CANCER; // The Predictor ( Binary) 
  int<lower=1> R; // The number of the MicroRNA 
  int<lower=1> A; // The levels of the age 
  int<lower=1,upper=R> MIRNAID[N]; // The index for the microRNA
  int<lower=1,upper=A> AGE[N]; // The index for the AGE 

}
parameters{
  
  matrix[2,R] w; // The distribution for the microRNA intercept 
  vector<lower=0>[R] sigma_w;
  matrix[2,A] z; // The distribution for the AGE intercept 
  vector<lower=0>[A] sigma_z;
  
  real<lower=0> sigma_e;
  real mu;
}

transformed parameters{
  real Y_hat[N];
  for ( i in 1:N){
    for ( j in 1:R){
      for ( k in 1:A){
    Y_hat[i] = mu +  w[1,MIRNAID[j]] + z[1,AGE[k]] + (w[2,MIRNAID[j]]+z[2,AGE[k]]) * CANCER[i];
    }
  }
 }
}
model{
  // The Priors 
  w[1] ~ normal(0,sigma_w[1]);
  w[2] ~ normal(0,sigma_w[2]);
  z[1] ~ normal(0,sigma_z[1]);
  
  
  // The likelihoods 
  
    Y ~ normal(Y_hat,sigma_e);
  }

