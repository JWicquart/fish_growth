// generated with brms 2.10.0
functions {
}
data {
  int N; //number of measures
  int<lower=1> Ni;  // number of individuals
  //int Ni; // number of individuals
  //int N_mis; // number of missing values for r0p
  vector[Ni] lcap; //response variable
  vector[Ni] rcap;
  vector[Ni] r0p;  
  real l0p;
  
  vector[N] r;
  int id[N];
  
  //vector[Ni] Y;  // response variable
  //int<lower=1> K_b;  // number of population-level effects
  //matrix[N, K_b] X_b;  // population-level design matrix
  //int<lower=1> K_c;  // number of population-level effects
  //matrix[N, K_c] X_c;  // population-level design matrix
  // covariate vectors
  //vector[Ni] C_1;
  //vector[Ni] C_2;
  //vector[Ni] C_3;
 // int prior_only;  // should the likelihood be ignored?
}
transformed data {
}
parameters {
  real b;  // population-level effects
  real c;  // population-level effects
  real<lower=0> sigma;  // residual SD
}
transformed parameters {
}
model {
  // initialize linear predictor term
  //vector[N] nlp_b = X_b * b_b;
  // initialize linear predictor term
  //vector[N] nlp_c = X_c * b_c;
  // initialize non-linear predictor term
  vector[Ni] mu;
  for (n in 1:Ni) {
    // compute non-linear predictor values
    mu[n] = l0p - (b * r0p[n] ^ c) + (b * rcap[n] ^ c);
  }
  // priors including all constants
  target += normal_lpdf(b | 200, 50);
  target += normal_lpdf(c | 1, 0.2);
  target += student_t_lpdf(sigma | 3, 0, 49)
    - 1 * student_t_lccdf(0 | 3, 0, 49);
  // likelihood including all constants
 // if (!prior_only) {
    target += normal_lpdf(lcap | mu, sigma);
 // }
}
generated quantities {
  
  vector[Ni] lcap_mu;
  vector[Ni] lcap_rep;
  vector[Ni] a;
  vector[N] l;
  
   for (n in 1:Ni){
     lcap_mu[n] = l0p - (b * r0p[n]^c) + (b * rcap[n]^c);
     lcap_rep[n] = normal_rng(lcap_mu[n], sigma);
  }
  

  for (i in 1:Ni){
    a[i] = l0p - b * r0p[i]^c;
  }

  for (n in 1:N){
    l[n] = a[id[n]] + exp(log(l0p - a[id[n]]) + ((log(lcap[id[n]] - a[id[n]]) - log(l0p - a[id[n]])) * (log(r[n])-log(r0p[id[n]])) / (log(rcap[id[n]]) - log(r0p[id[n]]))));
  }

  
  
  
  
  
}




