Projet d’Économétrie des Séries Temporelles
================
AMADOU TIDJANI MOUSSA Ibin Arabi
2026-11-24

# Introduction

Ce projet explore les séries temporelles financières à travers deux axes
majeurs : l’analyse de données réelles (indices boursiers, actions,
devises, cryptomonnaies) et l’étude de données simulées (modèles ARMA).
L’objectif est de comparer les propriétés statistiques des rentabilités
réelles avec celles de processus stochastiques simulés.

# 1. Analyse des données réelles

## 1.1 Chargement des packages et téléchargement des données

Nous utilisons le package `quantmod` pour extraire des données
financières directement depuis Yahoo Finance sur la période allant de
2020 à 2025.

    ## [1] "GSPC"

    ## [1] "XLK"

    ## [1] "AAPL"

    ## [1] "TLT"

    ## [1] "VIX"

    ## [1] "ES=F"

    ## [1] "VFIAX"

    ## [1] "QQQ"

    ## [1] "EURUSD=X"

    ## [1] "BTC-USD"

    ##                     Actif Nb_prix Nb_rendements
    ## SP500               SP500    1507          1506
    ## Secteur_Tech Secteur_Tech    1507          1506
    ## AAPL                 AAPL    1507          1506
    ## TLT                   TLT    1507          1506
    ## VIX                   VIX    1507          1506
    ## ES_Future       ES_Future    1510          1509
    ## VFIAX               VFIAX    1507          1506
    ## QQQ                   QQQ    1507          1506
    ## EURUSD             EURUSD    1562          1561
    ## BTC                   BTC    2192          2191

## 1.2 Visualisation des prix et des rentabilités

Traçons l’évolution des prix et des rentabilités logarithmiques avec
leurs intervalles de confiance à 95%.

<img src="README_files/figure-gfm/visualisation_prix-1.png" alt="" style="display: block; margin: auto;" /><img src="README_files/figure-gfm/visualisation_prix-2.png" alt="" style="display: block; margin: auto;" /><img src="README_files/figure-gfm/visualisation_prix-3.png" alt="" style="display: block; margin: auto;" /><img src="README_files/figure-gfm/visualisation_prix-4.png" alt="" style="display: block; margin: auto;" /><img src="README_files/figure-gfm/visualisation_prix-5.png" alt="" style="display: block; margin: auto;" /><img src="README_files/figure-gfm/visualisation_prix-6.png" alt="" style="display: block; margin: auto;" /><img src="README_files/figure-gfm/visualisation_prix-7.png" alt="" style="display: block; margin: auto;" /><img src="README_files/figure-gfm/visualisation_prix-8.png" alt="" style="display: block; margin: auto;" /><img src="README_files/figure-gfm/visualisation_prix-9.png" alt="" style="display: block; margin: auto;" /><img src="README_files/figure-gfm/visualisation_prix-10.png" alt="" style="display: block; margin: auto;" />

## 1.3 Distribution des rentabilités

Analyse de la forme des distributions (histogrammes, densités et
boxplots).

<img src="README_files/figure-gfm/distribution_rendements-1.png" alt="" style="display: block; margin: auto;" /><img src="README_files/figure-gfm/distribution_rendements-2.png" alt="" style="display: block; margin: auto;" /><img src="README_files/figure-gfm/distribution_rendements-3.png" alt="" style="display: block; margin: auto;" /><img src="README_files/figure-gfm/distribution_rendements-4.png" alt="" style="display: block; margin: auto;" /><img src="README_files/figure-gfm/distribution_rendements-5.png" alt="" style="display: block; margin: auto;" /><img src="README_files/figure-gfm/distribution_rendements-6.png" alt="" style="display: block; margin: auto;" /><img src="README_files/figure-gfm/distribution_rendements-7.png" alt="" style="display: block; margin: auto;" /><img src="README_files/figure-gfm/distribution_rendements-8.png" alt="" style="display: block; margin: auto;" /><img src="README_files/figure-gfm/distribution_rendements-9.png" alt="" style="display: block; margin: auto;" /><img src="README_files/figure-gfm/distribution_rendements-10.png" alt="" style="display: block; margin: auto;" />

## 1.4 Statistiques descriptives

    ##              Moyenne Ecart_type     Min    Max Skewness Kurtosis
    ## SP500         0.0005     0.0132 -0.1277 0.0909  -0.6459  14.6272
    ## Secteur_Tech  0.0008     0.0176 -0.1487 0.1260  -0.2535   8.5179
    ## AAPL          0.0009     0.0200 -0.1377 0.1426   0.0284   6.4367
    ## TLT          -0.0002     0.0108 -0.0690 0.0725   0.0892   4.2632
    ## VIX           0.0001     0.0794 -0.4424 0.5541   1.1810   6.8437
    ## ES_Future     0.0005     0.0132 -0.1096 0.0934  -0.6673  13.5372
    ## VFIAX         0.0006     0.0132 -0.1276 0.0909  -0.6430  14.6196
    ## QQQ           0.0007     0.0160 -0.1276 0.1134  -0.3598   7.1553
    ## EURUSD        0.0000     0.0047 -0.0281 0.0275   0.0303   2.3790
    ## BTC           0.0011     0.0324 -0.4647 0.1718  -1.3472  22.1370

## 1.5 Analyse de la stationnarité et autocorrélations

Les prix sont généralement non stationnaires, tandis que les
rentabilités le sont. Les graphiques ACF/PACF illustrent cette
différence. Nous calculons également l’ACVF et l’ACF manuellement.

<img src="README_files/figure-gfm/stationnarite-1.png" alt="" style="display: block; margin: auto;" /><img src="README_files/figure-gfm/stationnarite-2.png" alt="" style="display: block; margin: auto;" /><img src="README_files/figure-gfm/stationnarite-3.png" alt="" style="display: block; margin: auto;" /><img src="README_files/figure-gfm/stationnarite-4.png" alt="" style="display: block; margin: auto;" /><img src="README_files/figure-gfm/stationnarite-5.png" alt="" style="display: block; margin: auto;" /><img src="README_files/figure-gfm/stationnarite-6.png" alt="" style="display: block; margin: auto;" /><img src="README_files/figure-gfm/stationnarite-7.png" alt="" style="display: block; margin: auto;" /><img src="README_files/figure-gfm/stationnarite-8.png" alt="" style="display: block; margin: auto;" /><img src="README_files/figure-gfm/stationnarite-9.png" alt="" style="display: block; margin: auto;" /><img src="README_files/figure-gfm/stationnarite-10.png" alt="" style="display: block; margin: auto;" /><img src="README_files/figure-gfm/stationnarite-11.png" alt="" style="display: block; margin: auto;" /><img src="README_files/figure-gfm/stationnarite-12.png" alt="" style="display: block; margin: auto;" /><img src="README_files/figure-gfm/stationnarite-13.png" alt="" style="display: block; margin: auto;" /><img src="README_files/figure-gfm/stationnarite-14.png" alt="" style="display: block; margin: auto;" /><img src="README_files/figure-gfm/stationnarite-15.png" alt="" style="display: block; margin: auto;" /><img src="README_files/figure-gfm/stationnarite-16.png" alt="" style="display: block; margin: auto;" /><img src="README_files/figure-gfm/stationnarite-17.png" alt="" style="display: block; margin: auto;" /><img src="README_files/figure-gfm/stationnarite-18.png" alt="" style="display: block; margin: auto;" /><img src="README_files/figure-gfm/stationnarite-19.png" alt="" style="display: block; margin: auto;" /><img src="README_files/figure-gfm/stationnarite-20.png" alt="" style="display: block; margin: auto;" />

    ## 
    ## --- SP500 : ACVF / ACF (calcul manuel) ---
    ## Retard |   ACVF    |    ACF   
    ##    0   | 0.000175 |   1.0000
    ##    1   | -0.000030 |  -0.1697
    ##    2   | 0.000023 |   0.1302
    ##    3   | -0.000009 |  -0.0487
    ##    4   | -0.000012 |  -0.0705
    ##    5   | 0.000012 |   0.0695
    ##    6   | -0.000023 |  -0.1308
    ##    7   | 0.000028 |   0.1582
    ##    8   | -0.000023 |  -0.1291
    ##    9   | 0.000029 |   0.1661
    ##   10   | -0.000011 |  -0.0608

<img src="README_files/figure-gfm/stationnarite-21.png" alt="" style="display: block; margin: auto;" />

    ## 
    ## --- Secteur_Tech : ACVF / ACF (calcul manuel) ---
    ## Retard |   ACVF    |    ACF   
    ##    0   | 0.000309 |   1.0000
    ##    1   | -0.000049 |  -0.1574
    ##    2   | 0.000025 |   0.0820
    ##    3   | -0.000012 |  -0.0390
    ##    4   | -0.000018 |  -0.0590
    ##    5   | 0.000016 |   0.0504
    ##    6   | -0.000028 |  -0.0908
    ##    7   | 0.000032 |   0.1025
    ##    8   | -0.000035 |  -0.1117
    ##    9   | 0.000043 |   0.1400
    ##   10   | -0.000019 |  -0.0622

<img src="README_files/figure-gfm/stationnarite-22.png" alt="" style="display: block; margin: auto;" />

    ## 
    ## --- AAPL : ACVF / ACF (calcul manuel) ---
    ## Retard |   ACVF    |    ACF   
    ##    0   | 0.000400 |   1.0000
    ##    1   | -0.000034 |  -0.0840
    ##    2   | 0.000016 |   0.0409
    ##    3   | -0.000013 |  -0.0326
    ##    4   | -0.000013 |  -0.0315
    ##    5   | 0.000008 |   0.0196
    ##    6   | -0.000022 |  -0.0544
    ##    7   | 0.000020 |   0.0512
    ##    8   | -0.000038 |  -0.0961
    ##    9   | 0.000040 |   0.1012
    ##   10   | -0.000021 |  -0.0517

<img src="README_files/figure-gfm/stationnarite-23.png" alt="" style="display: block; margin: auto;" />

    ## 
    ## --- TLT : ACVF / ACF (calcul manuel) ---
    ## Retard |   ACVF    |    ACF   
    ##    0   | 0.000116 |   1.0000
    ##    1   | -0.000001 |  -0.0122
    ##    2   | -0.000014 |  -0.1178
    ##    3   | -0.000007 |  -0.0600
    ##    4   | 0.000001 |   0.0080
    ##    5   | 0.000007 |   0.0642
    ##    6   | 0.000002 |   0.0158
    ##    7   | -0.000005 |  -0.0446
    ##    8   | -0.000008 |  -0.0680
    ##    9   | 0.000007 |   0.0646
    ##   10   | 0.000003 |   0.0273

<img src="README_files/figure-gfm/stationnarite-24.png" alt="" style="display: block; margin: auto;" />

    ## 
    ## --- VIX : ACVF / ACF (calcul manuel) ---
    ## Retard |   ACVF    |    ACF   
    ##    0   | 0.006297 |   1.0000
    ##    1   | -0.000533 |  -0.0847
    ##    2   | 0.000036 |   0.0057
    ##    3   | -0.000160 |  -0.0255
    ##    4   | -0.000378 |  -0.0600
    ##    5   | -0.000047 |  -0.0075
    ##    6   | -0.000164 |  -0.0261
    ##    7   | -0.000061 |  -0.0097
    ##    8   | -0.000240 |  -0.0380
    ##    9   | 0.000087 |   0.0139
    ##   10   | -0.000123 |  -0.0195

<img src="README_files/figure-gfm/stationnarite-25.png" alt="" style="display: block; margin: auto;" />

    ## 
    ## --- ES_Future : ACVF / ACF (calcul manuel) ---
    ## Retard |   ACVF    |    ACF   
    ##    0   | 0.000173 |   1.0000
    ##    1   | -0.000027 |  -0.1579
    ##    2   | 0.000018 |   0.1033
    ##    3   | -0.000005 |  -0.0269
    ##    4   | -0.000014 |  -0.0817
    ##    5   | 0.000013 |   0.0780
    ##    6   | -0.000026 |  -0.1501
    ##    7   | 0.000029 |   0.1701
    ##    8   | -0.000018 |  -0.1017
    ##    9   | 0.000020 |   0.1181
    ##   10   | -0.000006 |  -0.0350

<img src="README_files/figure-gfm/stationnarite-26.png" alt="" style="display: block; margin: auto;" />

    ## 
    ## --- VFIAX : ACVF / ACF (calcul manuel) ---
    ## Retard |   ACVF    |    ACF   
    ##    0   | 0.000175 |   1.0000
    ##    1   | -0.000030 |  -0.1697
    ##    2   | 0.000023 |   0.1315
    ##    3   | -0.000009 |  -0.0494
    ##    4   | -0.000012 |  -0.0704
    ##    5   | 0.000012 |   0.0687
    ##    6   | -0.000023 |  -0.1297
    ##    7   | 0.000027 |   0.1568
    ##    8   | -0.000023 |  -0.1287
    ##    9   | 0.000029 |   0.1656
    ##   10   | -0.000011 |  -0.0602

<img src="README_files/figure-gfm/stationnarite-27.png" alt="" style="display: block; margin: auto;" />

    ## 
    ## --- QQQ : ACVF / ACF (calcul manuel) ---
    ## Retard |   ACVF    |    ACF   
    ##    0   | 0.000255 |   1.0000
    ##    1   | -0.000035 |  -0.1388
    ##    2   | 0.000020 |   0.0772
    ##    3   | -0.000013 |  -0.0528
    ##    4   | -0.000010 |  -0.0400
    ##    5   | 0.000011 |   0.0417
    ##    6   | -0.000019 |  -0.0737
    ##    7   | 0.000023 |   0.0914
    ##    8   | -0.000026 |  -0.1008
    ##    9   | 0.000036 |   0.1417
    ##   10   | -0.000014 |  -0.0567

<img src="README_files/figure-gfm/stationnarite-28.png" alt="" style="display: block; margin: auto;" />

    ## 
    ## --- EURUSD : ACVF / ACF (calcul manuel) ---
    ## Retard |   ACVF    |    ACF   
    ##    0   | 0.000022 |   1.0000
    ##    1   | 0.000001 |   0.0259
    ##    2   | -0.000000 |  -0.0169
    ##    3   | -0.000001 |  -0.0372
    ##    4   | 0.000000 |   0.0116
    ##    5   | 0.000000 |   0.0028
    ##    6   | -0.000001 |  -0.0563
    ##    7   | -0.000001 |  -0.0249
    ##    8   | 0.000001 |   0.0272
    ##    9   | 0.000000 |   0.0043
    ##   10   | -0.000000 |  -0.0094

<img src="README_files/figure-gfm/stationnarite-29.png" alt="" style="display: block; margin: auto;" />

    ## 
    ## --- BTC : ACVF / ACF (calcul manuel) ---
    ## Retard |   ACVF    |    ACF   
    ##    0   | 0.001048 |   1.0000
    ##    1   | -0.000060 |  -0.0575
    ##    2   | 0.000047 |   0.0447
    ##    3   | -0.000016 |  -0.0157
    ##    4   | 0.000062 |   0.0588
    ##    5   | 0.000001 |   0.0005
    ##    6   | 0.000013 |   0.0120
    ##    7   | -0.000035 |  -0.0335
    ##    8   | -0.000040 |  -0.0382
    ##    9   | 0.000049 |   0.0469
    ##   10   | 0.000012 |   0.0112

<img src="README_files/figure-gfm/stationnarite-30.png" alt="" style="display: block; margin: auto;" />

    ##                     Actif ADF_pval KPSS_pval Stationnaire
    ## SP500               SP500     0.01       0.1          Oui
    ## Secteur_Tech Secteur_Tech     0.01       0.1          Oui
    ## AAPL                 AAPL     0.01       0.1          Oui
    ## TLT                   TLT     0.01       0.1          Oui
    ## VIX                   VIX     0.01       0.1          Oui
    ## ES_Future       ES_Future     0.01       0.1          Oui
    ## VFIAX               VFIAX     0.01       0.1          Oui
    ## QQQ                   QQQ     0.01       0.1          Oui
    ## EURUSD             EURUSD     0.01       0.1          Oui
    ## BTC                   BTC     0.01       0.1          Oui

# 2. Données simulées (Modèles ARMA)

Simulation de processus AR, MA et ARMA pour comparer leurs propriétés
avec les données réelles.

## 2.1 Simulation des trajectoires

## 2.2 Visualisation des simulations

<img src="README_files/figure-gfm/visu_simulation-1.png" alt="" style="display: block; margin: auto;" /><img src="README_files/figure-gfm/visu_simulation-2.png" alt="" style="display: block; margin: auto;" /><img src="README_files/figure-gfm/visu_simulation-3.png" alt="" style="display: block; margin: auto;" /><img src="README_files/figure-gfm/visu_simulation-4.png" alt="" style="display: block; margin: auto;" /><img src="README_files/figure-gfm/visu_simulation-5.png" alt="" style="display: block; margin: auto;" /><img src="README_files/figure-gfm/visu_simulation-6.png" alt="" style="display: block; margin: auto;" /><img src="README_files/figure-gfm/visu_simulation-7.png" alt="" style="display: block; margin: auto;" /><img src="README_files/figure-gfm/visu_simulation-8.png" alt="" style="display: block; margin: auto;" /><img src="README_files/figure-gfm/visu_simulation-9.png" alt="" style="display: block; margin: auto;" /><img src="README_files/figure-gfm/visu_simulation-10.png" alt="" style="display: block; margin: auto;" />

## 2.3 Statistiques et autocorrélations des simulations

    ##        Moyenne Variance
    ## AR1     0.0413   1.4844
    ## AR2     0.0492   1.2474
    ## AR3    -0.0408   1.1619
    ## MA1    -0.0191   1.4370
    ## MA2    -0.0534   1.2853
    ## MA3     0.0710   1.2283
    ## ARMA11 -0.0699   2.7376
    ## ARMA12 -0.0527   2.2447
    ## ARMA21  0.0437   2.0725
    ## ARMA22 -0.0895   1.9303

<img src="README_files/figure-gfm/stats_simulation-1.png" alt="" style="display: block; margin: auto;" /><img src="README_files/figure-gfm/stats_simulation-2.png" alt="" style="display: block; margin: auto;" /><img src="README_files/figure-gfm/stats_simulation-3.png" alt="" style="display: block; margin: auto;" /><img src="README_files/figure-gfm/stats_simulation-4.png" alt="" style="display: block; margin: auto;" /><img src="README_files/figure-gfm/stats_simulation-5.png" alt="" style="display: block; margin: auto;" /><img src="README_files/figure-gfm/stats_simulation-6.png" alt="" style="display: block; margin: auto;" /><img src="README_files/figure-gfm/stats_simulation-7.png" alt="" style="display: block; margin: auto;" /><img src="README_files/figure-gfm/stats_simulation-8.png" alt="" style="display: block; margin: auto;" /><img src="README_files/figure-gfm/stats_simulation-9.png" alt="" style="display: block; margin: auto;" /><img src="README_files/figure-gfm/stats_simulation-10.png" alt="" style="display: block; margin: auto;" /><img src="README_files/figure-gfm/stats_simulation-11.png" alt="" style="display: block; margin: auto;" /><img src="README_files/figure-gfm/stats_simulation-12.png" alt="" style="display: block; margin: auto;" /><img src="README_files/figure-gfm/stats_simulation-13.png" alt="" style="display: block; margin: auto;" /><img src="README_files/figure-gfm/stats_simulation-14.png" alt="" style="display: block; margin: auto;" /><img src="README_files/figure-gfm/stats_simulation-15.png" alt="" style="display: block; margin: auto;" /><img src="README_files/figure-gfm/stats_simulation-16.png" alt="" style="display: block; margin: auto;" /><img src="README_files/figure-gfm/stats_simulation-17.png" alt="" style="display: block; margin: auto;" /><img src="README_files/figure-gfm/stats_simulation-18.png" alt="" style="display: block; margin: auto;" /><img src="README_files/figure-gfm/stats_simulation-19.png" alt="" style="display: block; margin: auto;" /><img src="README_files/figure-gfm/stats_simulation-20.png" alt="" style="display: block; margin: auto;" />

# 3. Comparaison : Données réelles vs Simulées

## 3.1 Synthèse visuelle (Prix vs Rentabilités)

<img src="README_files/figure-gfm/synthese_comparaison-1.png" alt="" style="display: block; margin: auto;" /><img src="README_files/figure-gfm/synthese_comparaison-2.png" alt="" style="display: block; margin: auto;" /><img src="README_files/figure-gfm/synthese_comparaison-3.png" alt="" style="display: block; margin: auto;" /><img src="README_files/figure-gfm/synthese_comparaison-4.png" alt="" style="display: block; margin: auto;" /><img src="README_files/figure-gfm/synthese_comparaison-5.png" alt="" style="display: block; margin: auto;" /><img src="README_files/figure-gfm/synthese_comparaison-6.png" alt="" style="display: block; margin: auto;" /><img src="README_files/figure-gfm/synthese_comparaison-7.png" alt="" style="display: block; margin: auto;" /><img src="README_files/figure-gfm/synthese_comparaison-8.png" alt="" style="display: block; margin: auto;" /><img src="README_files/figure-gfm/synthese_comparaison-9.png" alt="" style="display: block; margin: auto;" /><img src="README_files/figure-gfm/synthese_comparaison-10.png" alt="" style="display: block; margin: auto;" />

## 3.2 Comparaison quantitative (Moments)

Comparaison des moyennes et variances entre les rentabilités des actifs
réels et les séries simulées.

    ##                                Serie   Type  Moyenne Variance
    ## SP500               SP500_rendements   Reel  0.00050  0.00017
    ## Secteur_Tech Secteur_Tech_rendements   Reel  0.00079  0.00031
    ## AAPL                 AAPL_rendements   Reel  0.00088  0.00040
    ## TLT                   TLT_rendements   Reel -0.00018  0.00012
    ## VIX                   VIX_rendements   Reel  0.00009  0.00630
    ## ES_Future       ES_Future_rendements   Reel  0.00050  0.00017
    ## VFIAX               VFIAX_rendements   Reel  0.00056  0.00017
    ## QQQ                   QQQ_rendements   Reel  0.00072  0.00026
    ## EURUSD             EURUSD_rendements   Reel  0.00003  0.00002
    ## BTC                   BTC_rendements   Reel  0.00114  0.00105
    ## AR1                              AR1 Simule  0.04134  1.48438
    ## AR2                              AR2 Simule  0.04921  1.24737
    ## AR3                              AR3 Simule -0.04085  1.16188
    ## MA1                              MA1 Simule -0.01915  1.43696
    ## MA2                              MA2 Simule -0.05345  1.28534
    ## MA3                              MA3 Simule  0.07101  1.22833
    ## ARMA11                        ARMA11 Simule -0.06988  2.73759
    ## ARMA12                        ARMA12 Simule -0.05269  2.24474
    ## ARMA21                        ARMA21 Simule  0.04373  2.07251
    ## ARMA22                        ARMA22 Simule -0.08946  1.93027

# 4. Conclusion et Résultats

Ce projet met en évidence le contraste fondamental entre les prix
financiers et leurs rentabilités, ainsi que la capacité (et les limites)
des modèles ARMA à décrire ces dynamiques.

## 4.1 Synthèse sur les données réelles

L’étude des dix actifs (allant des indices traditionnels aux
cryptomonnaies) a confirmé plusieurs faits stylisés majeurs : \*
**Stationnarité :** Contrairement aux prix (non stationnaires, avec une
décroissance lente de l’ACF), les rentabilités logarithmiques sont
stationnaires. Les tests formels (ADF et KPSS) convergent tous vers ce
résultat. \* **Queues épaisses et asymétrie :** Les rentabilités ne
suivent pas une loi normale. Les kurtosis sont très élevées (jusqu’à
22,14 pour le Bitcoin) et les skewness majoritairement négatives,
indiquant que les chocs baissiers extrêmes sont plus fréquents (et
violents) que les hausses. \* **Agrégation de la volatilité :** On
observe des périodes de calme suivies de périodes de forte volatilité
(comme le choc de la COVID-19 en mars 2020).

## 4.2 Synthèse sur les données simulées

Les dix modèles ARMA simulés (AR, MA, ARMA) ont parfaitement reproduit
les signatures théoriques attendues : \* Pour les processus **AR**,
l’ACF décroît lentement tandis que la PACF s’annule brusquement. \* Pour
les processus **MA**, c’est l’inverse : l’ACF s’annule brusquement et la
PACF décroît. \* Pour les processus **ARMA**, les deux fonctions
décroissent progressivement.

Les variances empiriques des simulations correspondent aux variances
théoriques, validant la robustesse de nos simulations.

## 4.3 Comparaison et limites

La comparaison finale révèle que si les rentabilités réelles se
comportent en grande partie comme un bruit blanc (autocorrélation quasi
nulle, comme les modèles ARMA avec des innovations), les modèles ARMA
simples ne suffisent pas à capturer toute la complexité des marchés.

En effet, les modèles ARMA supposent des innovations gaussiennes
(variance constante). Ils ne peuvent donc pas expliquer les queues
épaisses ni l’agrégation de la volatilité observées sur les données
réelles. Pour modéliser correctement ces phénomènes, il serait
nécessaire de se tourner vers des modèles de volatilité conditionnelle
(de type **GARCH**).
