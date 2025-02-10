library(rdrobust)
library(ggplot2)

df1 <- read.csv("/~/finalized_perinatal_df.csv", header=TRUE, stringsAsFactors = FALSE)

bw_methods <- c("mserd", "msetwo", "msesum", "msecomb1", "msecomb2",
                "cerrd", "certwo", "cersum", "cercomb1", "cercomb2")

c = #cut-off value
for (bw_method in bw_methods) {
    tryCatch({
        rd_result <- rdrobust(y = df1$gyrification, x = df1$scan_age, c = c, p = 2, kernel = "triangular", bwselect = bw_method)
        
        rd_summary <- summary(rd_result)
        print(paste("Summary for", bw_method))
        print(rd_summary)
        
        ci_lower <- rd_result$ci[1, 1]
        ci_upper <- rd_result$ci[1, 2]
        coefficient <- rd_result$coef[1, 1]
        standard_error <- rd_result$se[1, 1]
        p_value <- rd_result$pv[1, 1]
        bw_fetal <- rd_result$h[1, 1]
        bw_postnatal <- rd_result$h[1, 2]
        
        print(paste("[ 95% C.I. ] for", bw_method, ":", paste(ci_lower, ci_upper, sep = " , ")))
        print(paste("Bandwidth for", bw_method, ":", paste(bw_fetal, bw_postnatal, sep = " , ")))
        print(paste("Coefficient for", bw_method, ":", coefficient))
        print(paste("Standard Error for", bw_method, ":", standard_error))
        print(paste("P-value for", bw_method, ":", p_value))
        print("----------------------------------------------------------")
    })
    }
