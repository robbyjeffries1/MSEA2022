

#---------------------------------------------------------------------------
#
#  DEMAND, SUPPLY, EQUILIBRIUM, AND SURPLUS
#
#  Source:  https://rpubs.com/omy000/571884
#
#---------------------------------------------------------------------------
  
  #------------------------------------------------------------------
  #
  # This example illustrates that R does math as well as statistics
  #
  #------------------------------------------------------------------


  # Load libraries

    install.packages("mosaic")  # Only if it has not already been installed

    library(dplyr)      # Necessary for mutate
    library(tidyverse)  # Necessary for pivot_longer
    library(mosaic)     # Necessary for finding surpluses
    library(tidyverse)


  # I was unable to download mosaicCald from CRAN so I downloaded it from GitHub instead
   
    library(devtools)

    install_github("ProjectMOSAIC/mosaicCalc")
    library(mosaicCalc)


# Step 1:  Simulate data and create demand and supply curves

  # Inverse demand cuve:  lnP =  8.5 - 0.82lnQ  
  # Inverse supply curve: lnP = -2.0 + 1.70lnQ

    table <- tibble(Q = seq(20,100,5))       # tibbles are streamlined data frames (tibbles are better for working in tidyverse than df's)
    table <- table %>% mutate(lnQ = log(Q),  # mutate preserves existing variables, overwrites existing variables, and adds new variables
                              logP_demand =  8.5 - 0.82*lnQ,
                              logP_supply = -2.0 + 1.70*lnQ,
                              Demand = exp(logP_demand),
                              Supply = exp(logP_supply))
    table


# Step 2:  Plot the demand and supply curves
    
  table %>% select(Q, Demand, Supply) %>% 
    pivot_longer(-Q, names_to = "Legend", values_to = "P") %>% 
    ggplot(aes(x = Q, y = P, color = Legend)) + geom_line(size = 1.25) + ggtitle("Market for Economic Analysts") +
      theme(axis.line = element_line(colour = "black", size = 1, linetype = "solid"))
  

# Step 3:  Solve for the market equilibrium
   
  demand <- makeFun(exp(8.5 - 0.82*log(x)) ~ x)  # makeFun creates simple functions; part of mosaic package
  supply <- makeFun(exp(-2 + 1.7*log(x)) ~ x)  
  

  # First, first find the equilibrium quantity (QD = DS) 
  
    q1 <- findZeros(supply(x)-demand(x) ~ x, x.lim=range(60,80))  # Finds the zeroes of a function over a range of values (compare to unitroot)
    q1 <- q1$x
    
    q1
    
  
  # Second, find the equilibrium price by plugging Q* into either D or S
    
    p1 <- supply(q1)  # USe supply to solve for P*
    
    p1
    
    
  # Third, update the plot by adding the equilibrium to it
    
    Q <- 20:100
    
    ggplot() +
      stat_function(aes(x = Q, color = "Demand"), size = 1.25, fun = demand) +   
        # stat_function is used lay a function on top of a plot; it computes and draws a function as a continuous curve
      stat_function(aes(x = Q, color = "Supply"), size = 1.25, fun = supply) + 
      labs(x="Quantity", y = "Price", color = NULL) +
      annotate("point", x = q1, y = p1, color = "grey30") +
      annotate("segment", x = q1, xend = q1, y = 20, yend = p1,
               linetype = "dashed", color = "grey30") +
      annotate("segment", x = 20, xend = q1, y = p1, yend = p1,
               linetype = "dashed", color = "grey30") +
      annotate("text", x = 66, y = 10, label = q1, parse = TRUE) +
      annotate("text", x = 25, y = 170, label = p1, parse = TRUE)+
      ggtitle("Market for Economic Analysts") +
      theme(axis.line = element_line(colour = "black", size = 1, linetype = "solid"))

    
# Step 4:  Find consumer and producer surplus at the equilibrium
    
  # The numerical values of the surpluses are found using the following relationships:
  #   Consumer surplus = [integral|q0q1 D(x)dx] - [p1*(q1-q0)]
  #   Producer surplus = [p1*(q1-q0)] - [integral|q0q1 S(x)dx]
  #   NOTE:  For this example q0 = 20
    
  # Integration is performed using antiD(); it is part of the package mosaic 
    
    D <- antiD(demand(x)~x)  # 'antiD()'finds the anti-derivative (integral)
    S <- antiD(supply(x)~x)
    
    # Consumer surplus
    
      (D(q1)-D(20)) - p1*(q1-20)
    
    # Producer surplus
    
      p1*(q1-20) - (S(q1)-S(20))
      
    # Total surplus (total gains from market exchange)
    
      (D(q1)-D(20)) - p1*(q1-20) + p1*(q1-20) - (S(q1)-S(20))
      
      
    # Total surplus can also be found by taking the integral under the demand curve and then subtracting the integral under the supply curve
      
      (D(q1)-D(20))-(S(q1)-S(20))
    
    
# Step 5:  Plot the surpluses
      
  z <- seq(20, q1, 0.01)

  ggplot() +
    stat_function(aes(x=Q, color = "Demand"), size = 1.25, fun = demand) +
    stat_function(aes(x=Q, color = "Supply"), size = 1.25, fun = supply) + 
    labs(x="Quantity", y="Price", color=NULL, fill=NULL) +
    annotate("point", x = q1, y = p1, color = "grey30") +
    annotate("segment", x = q1, xend = q1, y = 20, yend = p1,
             linetype = "dashed", color = "grey30") +
    annotate("segment", x = 20, xend = q1, y = p1, yend = p1,
             linetype = "dashed", color = "grey30") +
    geom_ribbon(aes(x = z, ymin = supply(z), ymax = p1,
                    fill = "Producer surplus"), alpha = 0.25) +
    geom_ribbon(aes(x = z, ymin = p1, ymax = demand(z),
                    fill = "Consumer surplus"), alpha = 0.25) + 
    ggthemes::theme_economist()