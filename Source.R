# ============================================================
# PROJET D'ÉCONOMÉTRIE DES SÉRIES TEMPORELLES
# ============================================================

# 1. CHARGEMENT DES PACKAGES ET TÉLÉCHARGEMENT DES DONNÉES
options(timeout = 300)
library(quantmod)
library(xts)
library(PerformanceAnalytics)
library(tseries)
library(forecast)
library(ggplot2)

# Période d'étude
date_debut <- "2020-01-01"
date_fin   <- "2025-12-31"

# Téléchargement des données (XLK remplace ^SP500-45 pour le secteur tech)
getSymbols("^GSPC", src = "yahoo", from = date_debut, to = date_fin)
getSymbols("XLK", src = "yahoo", from = date_debut, to = date_fin)
getSymbols("AAPL", src = "yahoo", from = date_debut, to = date_fin)
getSymbols("TLT", src = "yahoo", from = date_debut, to = date_fin)
getSymbols("^VIX", src = "yahoo", from = date_debut, to = date_fin)
getSymbols("ES=F", src = "yahoo", from = date_debut, to = date_fin)
getSymbols("VFIAX", src = "yahoo", from = date_debut, to = date_fin)
getSymbols("QQQ", src = "yahoo", from = date_debut, to = date_fin)
getSymbols("EURUSD=X", src = "yahoo", from = date_debut, to = date_fin)
getSymbols("BTC-USD", src = "yahoo", from = date_debut, to = date_fin)

# Transformation des prix en rentabilités
liste_actifs <- list(
  "SP500"        = Ad(GSPC),
  "Secteur_Tech" = Ad(XLK),
  "AAPL"         = Ad(AAPL),
  "TLT"          = Ad(TLT),
  "VIX"          = Ad(VIX),
  "ES_Future"    = Ad(`ES=F`),
  "VFIAX"        = Ad(VFIAX),
  "QQQ"          = Ad(QQQ),
  "EURUSD"       = Ad(`EURUSD=X`),
  "BTC"          = Ad(`BTC-USD`)
)

liste_actifs <- lapply(liste_actifs, na.omit)
liste_rendements <- lapply(liste_actifs, function(x) diff(log(x)))
liste_rendements <- lapply(liste_rendements, na.omit)

# Affichage du nombre d'observations
nb_observations <- data.frame(
  Actif = names(liste_actifs),
  Nb_prix       = sapply(liste_actifs, length),
  Nb_rendements = sapply(liste_rendements, length)
)
print(nb_observations)


# ============================================================
# 2. VISUALISATION DES PRIX ET RENTABILITÉS
# ============================================================

for (nom in names(liste_actifs)) {
  par(mfrow = c(2,1))
  
  plot(index(liste_actifs[[nom]]), coredata(liste_actifs[[nom]]), type = "l",
       main = paste("Prix -", nom), col = "steelblue", xlab = "Date", ylab = "Prix")
  
  plot(index(liste_rendements[[nom]]), coredata(liste_rendements[[nom]]), type = "l",
       main = paste("Rentabilites -", nom), col = "darkred", xlab = "Date", ylab = "Rentabilite")
  
  mean_r <- mean(liste_rendements[[nom]])
  sd_r   <- sd(liste_rendements[[nom]])
  abline(h = mean_r, col = "red", lwd = 2)
  abline(h = mean_r + 1.96 * sd_r, col = "darkred", lty = 2, lwd = 1.5)
  abline(h = mean_r - 1.96 * sd_r, col = "darkred", lty = 2, lwd = 1.5)
  
  par(mfrow = c(1,1))
}


# ============================================================
# 3. DISTRIBUTION DES RENTABILITÉS (HISTOGRAMMES ET BOXPLOTS)
# ============================================================

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


# ============================================================
# 4. STATISTIQUES DESCRIPTIVES
# ============================================================

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


# ============================================================
# 5. STATIONNARITÉ ET AUTOCORRÉLATIONS (ACF/PACF, TESTS)
# ============================================================

# ACF/PACF sur les prix
for (nom in names(liste_actifs)) {
  par(mfrow = c(1,2))
  acf(liste_actifs[[nom]],  main = paste("ACF Prix -", nom))
  pacf(liste_actifs[[nom]], main = paste("PACF Prix -", nom))
  par(mfrow = c(1,1))
}

# ACF/PACF sur les rentabilités
for (nom in names(liste_rendements)) {
  par(mfrow = c(1,2))
  acf(liste_rendements[[nom]],  main = paste("ACF Rentabilites -", nom))
  pacf(liste_rendements[[nom]], main = paste("PACF Rentabilites -", nom))
  par(mfrow = c(1,1))
}

# ACVF/ACF calculées manuellement
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

# Tests ADF + KPSS
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
                            KPSS_pval = round(KPSS_pval, 3)))


# ============================================================
# 6. DONNÉES SIMULÉES (MODÈLES ARMA)
# ============================================================

set.seed(123)
n_obs <- 1000

# Simulation des modèles
sim_AR1 <- arima.sim(n = n_obs, model = list(ar = 0.6))
sim_AR2 <- arima.sim(n = n_obs, model = list(ar = c(0.5, -0.3)))
sim_AR3 <- arima.sim(n = n_obs, model = list(ar = c(0.4, -0.2, 0.15)))

sim_MA1 <- arima.sim(n = n_obs, model = list(ma = 0.7))
sim_MA2 <- arima.sim(n = n_obs, model = list(ma = c(0.5, 0.3)))
sim_MA3 <- arima.sim(n = n_obs, model = list(ma = c(0.4, 0.3, 0.2)))

sim_ARMA11 <- arima.sim(n = n_obs, model = list(ar = 0.6,        ma = 0.4))
sim_ARMA12 <- arima.sim(n = n_obs, model = list(ar = 0.5,        ma = c(0.4, 0.2)))
sim_ARMA21 <- arima.sim(n = n_obs, model = list(ar = c(0.5, -0.3), ma = 0.4))
sim_ARMA22 <- arima.sim(n = n_obs, model = list(ar = c(0.5, -0.3), ma = c(0.4, 0.2)))

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

# Visualisation des trajectoires simulées
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

# Statistiques et distributions des simulations
stats_simulations <- t(sapply(liste_simulations, function(x) {
  c(Moyenne = mean(x), Variance = var(x))
}))
print(round(stats_simulations, 4))

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

# ACF/PACF des simulations
for (nom in names(liste_simulations)) {
  par(mfrow = c(1,2))
  acf(liste_simulations[[nom]],  main = paste("ACF -", nom))
  pacf(liste_simulations[[nom]], main = paste("PACF -", nom))
  par(mfrow = c(1,1))
}


# ============================================================
# 7. COMPARAISON : DONNÉES RÉELLES VS SIMULÉES
# ============================================================

# Synthèse visuelle
for (nom in names(liste_actifs)) {
  par(mfrow = c(2,2))
  
  plot(index(liste_actifs[[nom]]), coredata(liste_actifs[[nom]]), type = "l",
       main = paste("Prix -", nom), col = "steelblue", xlab = "", ylab = "Prix")
  acf(liste_actifs[[nom]], main = paste("ACF Prix -", nom))
  
  plot(index(liste_rendements[[nom]]), coredata(liste_rendements[[nom]]), type = "l",
       main = paste("Rentabilites -", nom), col = "darkred", xlab = "", ylab = "Rentabilite")
  acf(liste_rendements[[nom]], main = paste("ACF Rentabilites -", nom))
  
  par(mfrow = c(1,1))
}

# Comparaison quantitative (Moments)
comparaison_moments <- data.frame(
  Serie    = c(paste0(names(liste_rendements), "_rendements"), names(liste_simulations)),
  Type     = c(rep("Reel", length(liste_rendements)), rep("Simule", length(liste_simulations))),
  Moyenne  = c(sapply(liste_rendements, mean), sapply(liste_simulations, mean)),
  Variance = c(sapply(liste_rendements, var),  sapply(liste_simulations, var))
)

print(round_df2 <- transform(comparaison_moments,
                             Moyenne  = round(Moyenne, 5),
                             Variance = round(Variance, 5)))