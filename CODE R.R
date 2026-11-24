# ============================================================
# PROJET D'ECONOMÉTRIE DES SÉRIES TEMPORELLES
# ============================================================

# ============================================================
# 1. DONNÉES RÉELLES
# ============================================================

# 1.1 Chargement des packages
library(quantmod)
library(xts)
library(PerformanceAnalytics)
library(tseries)
library(forecast)
library(ggplot2)

# 1.2 Période d'étude
date_debut <- "2020-01-01"
date_fin   <- "2025-12-31"

# 1.3 Téléchargement des données

# Indice S&P 500 (indice boursier americain de référence)
getSymbols("^GSPC", src = "yahoo",
           from = date_debut, to = date_fin)

# Secteur Technologie de l'indice S&P 500 (S&P 500 Information Technology)
getSymbols("^SP500-45", src = "yahoo",
           from = date_debut, to = date_fin)

# Action Apple Inc. (titre individuel technologique)
getSymbols("AAPL", src = "yahoo",
           from = date_debut, to = date_fin)

# ETF iShares 20+ Year Treasury Bond (obligations d'Etat americaines long terme)
getSymbols("TLT", src = "yahoo",
           from = date_debut, to = date_fin)

# Indice de volatilite CBOE (indice de la peur / VIX)
getSymbols("^VIX", src = "yahoo",
           from = date_debut, to = date_fin)

# Contrat a terme sur l'E-mini S&P 500 (future)
getSymbols("ES=F", src = "yahoo",
           from = date_debut, to = date_fin)

# Fonds indiciel Vanguard 500 Index Fund Admiral Shares (mutual fund S&P 500)
getSymbols("VFIAX", src = "yahoo",
           from = date_debut, to = date_fin)

# ETF Invesco QQQ Trust (indice Nasdaq-100)
getSymbols("QQQ", src = "yahoo",
           from = date_debut, to = date_fin)

# Taux de change EUR/USD (parite euro-dollar)
getSymbols("EURUSD=X", src = "yahoo",
           from = date_debut, to = date_fin)

# Cryptomonnaie Bitcoin en USD (BTC/USD)
getSymbols("BTC-USD", src = "yahoo",
           from = date_debut, to = date_fin)

# 1.4 Transformation des prix en rentabilités

# Extraction des prix ajustes de cloture
liste_actifs <- list(
  "SP500"        = Ad(GSPC),
  "Secteur_Tech" = Ad(`SP500-45`),
  "AAPL"         = Ad(AAPL),
  "TLT"          = Ad(TLT),
  "VIX"          = Ad(VIX),
  "ES_Future"    = Ad(`ES=F`),
  "VFIAX"        = Ad(VFIAX),
  "QQQ"          = Ad(QQQ),
  "EURUSD"       = Ad(`EURUSD=X`),
  "BTC"          = Ad(`BTC-USD`)
)

# Suppression des valeurs manquantes
liste_actifs <- lapply(liste_actifs, na.omit)

# Calcul des rentabilites logarithmiques
liste_rendements <- lapply(liste_actifs, function(x) diff(log(x)))
liste_rendements <- lapply(liste_rendements, na.omit)

# Verification du nombre d'observations restantes par actif
nb_observations <- data.frame(
  Actif = names(liste_actifs),
  Nb_prix       = sapply(liste_actifs, length),
  Nb_rendements = sapply(liste_rendements, length)
)
print(nb_observations)

# Traçage des prix et rentabilites pour chaque actif (avec bandes IC 95%)
for (nom in names(liste_actifs)) {
  par(mfrow = c(2,1))
  
  plot(liste_actifs[[nom]], main = paste("Prix -", nom), col = "steelblue")
  
  plot(liste_rendements[[nom]], main = paste("Rentabilites -", nom), col = "darkred")
  mean_r <- mean(liste_rendements[[nom]])
  sd_r   <- sd(liste_rendements[[nom]])
  abline(h = mean_r, col = "red", lwd = 2)
  abline(h = mean_r + 1.96 * sd_r, col = "darkred", lty = 2, lwd = 1.5)
  abline(h = mean_r - 1.96 * sd_r, col = "darkred", lty = 2, lwd = 1.5)
  
  par(mfrow = c(1,1))
}

# 1.4bis Histogrammes, densites et boxplots des rentabilites
for (nom in names(liste_rendements)) {
  x <- as.numeric(liste_rendements[[nom]])
  
  par(mfrow = c(1,2))
  
  dens <- density(x)
  ymax <- max(hist(x, plot = FALSE)$density, dens$y) * 1.15
  hist(x, prob = TRUE, main = paste("Distribution -", nom),
       xlab = "Log-rentabilite", col = "lightblue", border = "black", ylim = c(0, ymax))
  lines(dens, col = "red", lwd = 2)
  
  boxplot(x, main = paste("Boxplot -", nom), ylab = "Log-rentabilite",
          col = "lightblue", horizontal = TRUE)
  
  par(mfrow = c(1,1))
}

# 1.5 Statistiques descriptives

# Fonction de statistiques descriptives
stats_descriptives <- function(x) {
  c(
    Moyenne    = mean(x),
    Ecart_type = sd(x),
    Min        = min(x),
    Max        = max(x),
    Skewness   = PerformanceAnalytics::skewness(x),
    Kurtosis   = PerformanceAnalytics::kurtosis(x)
  )
}

tableau_stats <- t(sapply(liste_rendements, stats_descriptives))
print(round(tableau_stats, 4))

# 1.6 Analyse visuelle de la stationnarité

# ACF/PACF sur les prix (non stationnaire, decroissance lente de l'ACF)
for (nom in names(liste_actifs)) {
  par(mfrow = c(1,2))
  acf(liste_actifs[[nom]],  main = paste("ACF Prix -", nom))
  pacf(liste_actifs[[nom]], main = paste("PACF Prix -", nom))
  par(mfrow = c(1,1))
}

# ACF/PACF sur les rentabilites (stationnaire, decroissance rapide)
for (nom in names(liste_rendements)) {
  par(mfrow = c(1,2))
  acf(liste_rendements[[nom]],  main = paste("ACF Rentabilites -", nom))
  pacf(liste_rendements[[nom]], main = paste("PACF Rentabilites -", nom))
  par(mfrow = c(1,1))
}

# 1.6bis ACVF/ACF calculees manuellement (formule explicite) + autocorrelogramme avec IC
for (nom in names(liste_rendements)) {
  x <- as.numeric(liste_rendements[[nom]])
  n <- length(x)
  x_centre <- x - mean(x)
  variance_x <- sum(x_centre^2) / n
  
  lag_max <- 10
  acvf <- numeric(lag_max + 1)
  acf_vals <- numeric(lag_max + 1)
  acvf[1] <- variance_x
  acf_vals[1] <- 1.0
  for (k in 1:lag_max) {
    gamma_k <- sum(x_centre[1:(n - k)] * x_centre[(k + 1):n]) / n
    acvf[k + 1] <- gamma_k
    acf_vals[k + 1] <- gamma_k / variance_x
  }
  
  cat("\n---", nom, ": ACVF / ACF (calcul manuel) ---\n")
  cat("Retard |   ACVF    |    ACF   \n")
  for (k in 0:lag_max) {
    cat(sprintf("  %2d   | %8.6f | %8.4f\n", k, acvf[k+1], acf_vals[k+1]))
  }
  
  ci_95 <- 1.96 / sqrt(n)
  plot(0:lag_max, acf_vals, type = "h", lwd = 2, col = "blue",
       main = paste("Autocorrelogramme (manuel) -", nom),
       xlab = "k", ylab = expression(gamma[k]),
       ylim = c(min(-1, min(acf_vals) - 0.1), max(1, max(acf_vals) + 0.1)))
  abline(h = 0, col = "black", lwd = 1)
  abline(h = ci_95, col = "red", lty = 2, lwd = 1.5)
  abline(h = -ci_95, col = "red", lty = 2, lwd = 1.5)
  legend("topright", legend = c("ACF", "IC 95%"), col = c("blue", "red"),
         lty = c(1, 2), lwd = c(2, 1.5), bg = "white", cex = 0.8)
}

# (Complement) Tableau recapitulatif ADF + KPSS
tableau_tests <- data.frame(
  Actif    = names(liste_rendements),
  ADF_pval  = sapply(liste_rendements, function(x) adf.test(x)$p.value),
  KPSS_pval = sapply(liste_rendements, function(x) kpss.test(x)$p.value)
)

tableau_tests$Stationnaire <- ifelse(
  tableau_tests$ADF_pval < 0.05 & tableau_tests$KPSS_pval > 0.05,
  "Oui", "A verifier"
)

print(round_df <- transform(tableau_tests,
                            ADF_pval = round(ADF_pval, 3),
                            KPSS_pval = round(KPSS_pval, 3)
))


# ============================================================
# 2. DONNEES SIMULÉES
# ============================================================

set.seed(123)  # reproductibilité
n_obs <- 1000


# 2.1 Simulation des modèles ARMA stationnaires


# --- AR ---
sim_AR1 <- arima.sim(n = n_obs, model = list(ar = 0.6))
sim_AR2 <- arima.sim(n = n_obs, model = list(ar = c(0.5, -0.3)))
sim_AR3 <- arima.sim(n = n_obs, model = list(ar = c(0.4, -0.2, 0.15)))

# --- MA ---
sim_MA1 <- arima.sim(n = n_obs, model = list(ma = 0.7))
sim_MA2 <- arima.sim(n = n_obs, model = list(ma = c(0.5, 0.3)))
sim_MA3 <- arima.sim(n = n_obs, model = list(ma = c(0.4, 0.3, 0.2)))

# --- ARMA ---
sim_ARMA11 <- arima.sim(n = n_obs, model = list(ar = 0.6,        ma = 0.4))
sim_ARMA12 <- arima.sim(n = n_obs, model = list(ar = 0.5,        ma = c(0.4, 0.2)))
sim_ARMA21 <- arima.sim(n = n_obs, model = list(ar = c(0.5, -0.3), ma = 0.4))
sim_ARMA22 <- arima.sim(n = n_obs, model = list(ar = c(0.5, -0.3), ma = c(0.4, 0.2)))

# Regrouper dans une liste pour automatiser la suite
liste_simulations <- list(
  "AR1"     = sim_AR1,
  "AR2"     = sim_AR2,
  "AR3"     = sim_AR3,
  "MA1"     = sim_MA1,
  "MA2"     = sim_MA2,
  "MA3"     = sim_MA3,
  "ARMA11"  = sim_ARMA11,
  "ARMA12"  = sim_ARMA12,
  "ARMA21"  = sim_ARMA21,
  "ARMA22"  = sim_ARMA22
)

# 2.2 Tracer les trajectoires simulées (avec bandes IC 95%)

for (nom in names(liste_simulations)) {
  x <- liste_simulations[[nom]]
  mean_x <- mean(x)
  sd_x <- sd(x)
  
  plot(x, main = paste("Trajectoire simulee -", nom),
       col = "steelblue", ylab = "Valeur", xlab = "Temps")
  abline(h = mean_x, col = "red", lwd = 2)
  abline(h = mean_x + 1.96 * sd_x, col = "darkred", lty = 2, lwd = 1.5)
  abline(h = mean_x - 1.96 * sd_x, col = "darkred", lty = 2, lwd = 1.5)
}

# 2.3 Propriétés statistiques (moyenne, variance, autocorrelations)

stats_simulations <- t(sapply(liste_simulations, function(x) {
  c(Moyenne = mean(x), Variance = var(x))
}))
print(round(stats_simulations, 4))

# 2.3bis Histogrammes, densites et boxplots des series simulees
for (nom in names(liste_simulations)) {
  x <- as.numeric(liste_simulations[[nom]])
  
  par(mfrow = c(1,2))
  
  dens <- density(x)
  ymax <- max(hist(x, plot = FALSE)$density, dens$y) * 1.15
  hist(x, prob = TRUE, main = paste("Distribution -", nom),
       xlab = "Valeur", col = "lightblue", border = "black", ylim = c(0, ymax))
  lines(dens, col = "red", lwd = 2)
  
  boxplot(x, main = paste("Boxplot -", nom), ylab = "Valeur",
          col = "lightblue", horizontal = TRUE)
  
  par(mfrow = c(1,1))
}

# 2.4 Correlogrammes et analyse de stationnarité

for (nom in names(liste_simulations)) {
  par(mfrow = c(1,2))
  acf(liste_simulations[[nom]],  main = paste("ACF -", nom))
  pacf(liste_simulations[[nom]], main = paste("PACF -", nom))
  par(mfrow = c(1,1))
}

# 2.4bis ACVF/ACF calculees manuellement + autocorrelogramme avec IC
for (nom in names(liste_simulations)) {
  x <- as.numeric(liste_simulations[[nom]])
  n <- length(x)
  x_centre <- x - mean(x)
  variance_x <- sum(x_centre^2) / n
  
  lag_max <- 10
  acvf <- numeric(lag_max + 1)
  acf_vals <- numeric(lag_max + 1)
  acvf[1] <- variance_x
  acf_vals[1] <- 1.0
  for (k in 1:lag_max) {
    gamma_k <- sum(x_centre[1:(n - k)] * x_centre[(k + 1):n]) / n
    acvf[k + 1] <- gamma_k
    acf_vals[k + 1] <- gamma_k / variance_x
  }
  
  cat("\n---", nom, ": ACVF / ACF (calcul manuel) ---\n")
  cat("Retard |   ACVF    |    ACF   \n")
  for (k in 0:lag_max) {
    cat(sprintf("  %2d   | %8.6f | %8.4f\n", k, acvf[k+1], acf_vals[k+1]))
  }
  
  ci_95 <- 1.96 / sqrt(n)
  plot(0:lag_max, acf_vals, type = "h", lwd = 2, col = "blue",
       main = paste("Autocorrelogramme (manuel) -", nom),
       xlab = "k", ylab = expression(gamma[k]),
       ylim = c(min(-1, min(acf_vals) - 0.1), max(1, max(acf_vals) + 0.1)))
  abline(h = 0, col = "black", lwd = 1)
  abline(h = ci_95, col = "red", lty = 2, lwd = 1.5)
  abline(h = -ci_95, col = "red", lty = 2, lwd = 1.5)
  legend("topright", legend = c("ACF", "IC 95%"), col = c("blue", "red"),
         lty = c(1, 2), lwd = c(2, 1.5), bg = "white", cex = 0.8)
}

# ============================================================
# 3 Comparaison
# ============================================================

# 3.a Synthese comparative : Prix vs Rentabilites 

for (nom in names(liste_actifs)) {
  par(mfrow = c(2,2))
  plot(liste_actifs[[nom]],     main = paste("Prix -", nom),       col = "steelblue")
  acf(liste_actifs[[nom]],      main = paste("ACF Prix -", nom))
  plot(liste_rendements[[nom]], main = paste("Rentabilites -", nom), col = "darkred")
  acf(liste_rendements[[nom]],  main = paste("ACF Rentabilites -", nom))
  par(mfrow = c(1,1))
}

# 3.b Comparaison rentabilites reelles vs series simulees 

# Comparaison visuelle : chaque actif vs la simulation ARMA(1,1) (a titre d'exemple de reference)
for (nom in names(liste_rendements)) {
  par(mfrow = c(2,2))
  plot(liste_rendements[[nom]], main = paste("Rentabilites reelles -", nom), col = "darkred")
  acf(liste_rendements[[nom]],  main = paste("ACF Rentabilites -", nom))
  plot(sim_ARMA11, main = "Simulation ARMA(1,1)", col = "steelblue")
  acf(sim_ARMA11,  main = "ACF ARMA(1,1) simule")
  par(mfrow = c(1,1))
}

# Comparaison quantitative des moments : 10 actifs (rentabilites) + 10 simulations
comparaison_moments <- data.frame(
  Serie    = c(paste0(names(liste_rendements), "_rendements"), names(liste_simulations)),
  Type     = c(rep("Reel", length(liste_rendements)), rep("Simule", length(liste_simulations))),
  Moyenne  = c(sapply(liste_rendements, mean), sapply(liste_simulations, mean)),
  Variance = c(sapply(liste_rendements, var),  sapply(liste_simulations, var))
)

print(round_df2 <- transform(comparaison_moments,
                             Moyenne  = round(Moyenne, 5),
                             Variance = round(Variance, 5)
))
