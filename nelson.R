#-------------------------------------------------------------------------------
#--------------------- Nelson without dispersion parameter ---------------------
#-------------------------------------------------------------------------------


nelson <- function(succ, fail, m, alpha=0.05){
        
        data <- data.frame(succ, fail)
        
        # Adjusting the data if all nk=xk or all xk=0
        if(all(data$succ==0))
        {
                data$succ[1] <- 0.5
                data$fail[1] <- data$fail[1]-0.5
        }
        
        
        if(all(data$fail==0))
        {
                data$fail[1] <- 0.5
                data$succ[1] <- data$succ[1]-0.5
        }
        # 
        
        # estimation of pi
        fit <- glm(cbind(succ, fail)~1, data, 
                   family=quasibinomial(link="identity"))
        
        # Proportion of the actual sample (pi)
        estprop <- coef(fit)[1] 
        names(estprop) <- NULL
        
        # Expected proportion of no success in the future sample
        estq <- 1-estprop
        
        # Variance for pi
        varestprop <- estprop*estq*(1/(sum(rowSums(data))))
        
        # Quantile of the std. normal distribution
        z <- qnorm(alpha/2, 0, 1)
        
        # Expected number of success in the the future sample
        esty <- m*estprop
        
        # Lower boundary of the interval
        lower <- esty + z*sqrt(m*estprop*estq + 
                                       (m^2)*varestprop)
        
        # Upper boundary of the interval
        upper <- esty - z*sqrt(m*estprop*estq +
                                       (m^2)*varestprop)
        
        
        nelson <- data.frame(lower=lower, upper=upper)
        
        return(nelson)
}

























