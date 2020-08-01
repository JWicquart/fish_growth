// generated with brms 2.10.0
functions {
}
data {
  int<lower=1> N;  // number of observations
  int<lower=1> Ni;  // number of ind
  vector[Ni] lcap;  // response variable
  int<lower=1> K_b;  // number of population-level effects
  matrix[Ni, K_b] X_b;  // population-level design matrix
  int<lower=1> K_c;  // number of population-level effects
  matrix[Ni, K_c] X_c;  // population-level design matrix
  // covariate vectors
  vector[Ni] l0p;
  vector[Ni] r0p;
  vector[Ni] rcap;
  int prior_only;  // should the likelihood be ignored?
  
  vector[N] r;
  int id[N];

}
transformed data {
}
parameters {
  vector[K_b] b_b;  // population-level effects
  vector[K_c] b_c;  // population-level effects
  real<lower=0> sigma;  // residual SD
}
transformed parameters {
}
model {
  // initialize linear predictor term
  vector[Ni] nlp_b = X_b * b_b;
  // initialize linear predictor term
  vector[Ni] nlp_c = X_c * b_c;
  // initialize non-linear predictor term
  vector[Ni] mu;
  for (n in 1:Ni) {
    // compute non-linear predictor values
    mu[n] = l0p[n] - (nlp_b[n] * r0p[n] ^ nlp_c[n]) + (nlp_b[n] * rcap[n] ^ nlp_c[n]);
  }
  // priors including all constants
  target += normal_lpdf(b_b | 200, 50);
  target += normal_lpdf(b_c | 1, 0.2);
  target += student_t_lpdf(sigma | 3, 0, 49)
    - 1 * student_t_lccdf(0 | 3, 0, 49);
  // likelihood including all constants
  if (!prior_only) {
    target += normal_lpdf(lcap | mu, sigma);
  }
}
generated quantities {
  vector[Ni] lcap_mu;
  vector[Ni] lcap_rep;
  vector[Ni] a;
  vector[N] l;
  
    // initialize linear predictor term
  vector[Ni] nlp_b = X_b * b_b;
  // initialize linear predictor term
  vector[Ni] nlp_c = X_c * b_c;
  
   for (n in 1:Ni){
     lcap_mu[n] = l0p[n] - (nlp_b[n] * r0p[n] ^ nlp_c[n]) + (nlp_b[n] * rcap[n] ^ nlp_c[n]);
     lcap_rep[n] = normal_rng(lcap_mu[n], sigma);
  }
  

  for (i in 1:Ni){
    a[i] = l0p[i] - nlp_b[i] * r0p[i]^nlp_c[i];
  }

  for (n in 1:N){
    l[n] = a[id[n]] + exp(log(l0p[id[n]] - a[id[n]]) + ((log(lcap[id[n]] - a[id[n]]) - log(l0p[id[n]] - a[id[n]])) * (log(r[n])-log(r0p[id[n]])) / (log(rcap[id[n]]) - log(r0p[id[n]]))));
  }

}



