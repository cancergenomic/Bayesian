data{
  int<lower=0> N; // The number of the observations 
  vector[N] Y; // The response variable as the level of the microRNA expressed
  vector<lower=0, upper=+1>[N] CANCER; // The predictor variable 
}
parameters{
  real beta_1; // The beta[1]: Fixed intercept , beta[2] : Fixed Slope 
  real beta_2; 
  real<lower=0> sigma_e; // Standard Error 
}

model{
    // The likelihood 
  Y ~ normal(beta_1 + CANCER * beta_2,sigma_e);
}

generated quantities{
  real Y_bar[N];
  for ( i in 1:N){
    Y_bar[i] = normal_rng(beta_1 + CANCER[i] * beta_2,sigma_e);
  }
}