# pollinatoryield
This package includes a function for estimating a non-inflected dependence of yield on visitation rate for several crops and some their respective varieties. The non-inflected curves are given by the equation `yield = a + b * (1 - exp(-c * visit_rate))`, where `a` represents the yield without pollinators, `b` is the maximum yield attained for the crop, and `c` is a shape parameter that depends on the visits in 100 flowers during 1 hour for full fertilization (see `?shape_par_exp_decay`).

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
eval_visitation_rate(Crop ="Crops_name", visit_rate = "Number")
```
where `Crop` is non-latin name of the crop (e.g. "Apple", "Blueberry", etc.), and `visit_rate` is the visitation rate measured in the center of a given field (see `?eval_visitation_rate`). The curves also show the optimal visitation rate (i.e., the lower limit of the visitation rate that produces 99 % of maximum yield). All the information that we use to plot the curves is stored in a data frame that can be accessed by running

```{r}
demo_table
```

Finally, here is an example.
```{r}
demo_table
```
![](Example/Apple_example.jpg)
