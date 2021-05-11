# pollinatoryield

This package includes a function for estimating a non-inflected dependence of yield on visitation rate for several crops and some their respective varieties. The non-inflected curves are given by the equation `yield = a + b * (1 - exp(-c * visit_rate))`, where `a` represents the yield without pollinators, `b` is the maximum yield attained for the crop, and `c` is a shape parameter that depends on the visits in 100 flowers during 1 hour for full fertilization (see `?shape_par_exp_decay`).

\(%F(n)=\left\{\begin{matrix}
100\left ( \frac{1}{ovu} \sum _{k=0}^n H(k-1)svd(eff)^k \right ) & n<m\\ 
100 & n\geq m
\end{matrix}\right.\)

This version is still in development. So, please, report bugs, etc.

To install the package run:

```{r}
install.packages("devtools")
require(devtools)
install_github("AlfonsoAllen/pollinatoryield")
library(pollinatoryield)
```

To plot the non-inflicted curves for a given crop and their varieties, just run:

```{r}
model_eval_visitation_rate(Crop = `Crop name`, visit_rate = `number`)
```
where `Crop` is latin name of the crop (e.g. "Vaccinium corymbosum", "Fragaria x ananassa Duch.", etc.), and `visit_rate` is the visitation rate measured in the center of a given field (see `?model_eval_visitation_rate`). The curves also show the optimal visitation rate (i.e., the target visitation rate that produces 99 % of maximum yield, considering that the eff floral visitors need to ). All the information that we use to plot the curves is stored in a data frame that can be accessed by running

```{r}
demo_table
```

Finally, here is an example.
```{r}
model_eval_visitation_rate(Crop = "Rubus idaeus", visit_rate = 15)
```
![](Example/example_visitation.png)
