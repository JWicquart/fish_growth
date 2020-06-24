data{
  int N;
  int Ni; // number of individuals
  int N_mis; // number of missing values for r0p
  vector[Ni] rcap;
  vector[Ni] lcap;
  real l0p;
  int id[N];

  int known[Ni-N_mis];
  int missing[N_mis];
  int known2[N-N_mis];
  int missing2[N_mis];

  vector[N-N_mis] r; //radius

  vector[Ni-N_mis] r0p; // vector of other r0's in case unknown
}

parameters{
  real<lower = 0> b;
  real<lower = 0> c;
  real<lower = 0> sigma;
  vector<lower = 0, upper = 0.02>[N_mis] r0p_mis;
  real<lower = 0, upper = 0.02> r0p_mu;
  real<lower = 0> r0p_sd;
}

transformed parameters{
  vector[Ni] r0p_imp; // r0p with imputed values for missing values
  vector[N] r_imp;
  r0p_imp[known] = r0p;
  r0p_imp[missing] = r0p_mis;
  r_imp[known2] = r;
  r_imp[missing2] = r0p_mis;
}

model{
  vector[Ni] mu;

  r0p ~ normal(r0p_mu, r0p_sd);
  r0p_mis ~  normal(r0p_mu, r0p_sd);

  r0p_mu ~ normal(0.005, 0.00025);

  // priors
  target += cauchy_lpdf(sigma | 0, 5);
  target += cauchy_lpdf(r0p_sd | 0, 5);

  b ~ normal(200, 50);
  c ~ normal(1, 0.2);

  for (n in 1:Ni){
     mu[n] = l0p - (b * r0p_imp[n]^c) + (b * rcap[n]^c);
     lcap[n] ~ normal(mu[n], sigma);
  }
}

generated quantities{
  vector[Ni] a;
  vector[N] l;

  for (i in 1:Ni){
    a[i] = l0p - b * r0p_imp[i]^c;
  }

  for (n in 1:N){
    l[n] = a[id[n]] + exp(log(l0p - a[id[n]]) + ((log(lcap[id[n]] - a[id[n]]) - log(l0p - a[id[n]])) * (log(r_imp[n])-log(r0p_imp[id[n]])) / (log(rcap[id[n]]) - log(r0p_imp[id[n]]))));
  }

}
