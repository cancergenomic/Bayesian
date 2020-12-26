data{
  
  int<lower=1> N; // The number of the observations
  vector[N] Y; // The Response variable 
  vector<lower=0,upper=1>[N] CANCER; // The Predictor ( Binary) 
  int<lower=1> R; // The number of the MicroRNA 
  int<lower=1,upper=R> MIRNAID[N]; // The index for the microRNA

}
parameters{
  vector[2] beta;
  vector[R] w; // The distribution for the microRNA intercept 
  real<lower=0> sigma_e;
  real<lower=0> sigma_w;
  real mu;

}
transformed parameters{
  real Y_hat[N];
  for( i in 1:N){
    for ( j in 1:R){
    Y_hat[i]= mu + w[MIRNAID[j]] ;
  }
  }
  
}
model{
  
  w ~ normal(0,sigma_w);
  Y ~ normal(Y_hat,sigma_e);
  }
