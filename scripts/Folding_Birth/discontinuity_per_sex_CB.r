library(tidyverse)  
library(broom)  
library(rdrobust)

df1 <- read.csv("/~/finalized_perinatal_df.csv", header=TRUE, stringsAsFactors = FALSE)

y_max1 <- c("volume_CSF_max1","volume_cGM_max1","volume_WM_max1","volume_VENTRICLES_max1",
            "volume_CEREBELLUM_max1","volume_dGM_max1","volume_BRAINSTEM_max1",
            "volume_HIPPOCAMPI_max1","brain_volume_max1", "TTV_max1","TBV_max1",
            "ICV_max1","white_surface_area_max1","white_gyrification_index_max1")

c <- #cut-off value

for (sex in c("male", "female")) {
    df_subset <- df1[df1$sex == sex, ]
    
    for (y_col in y_max1) {
        p <- ggplot(df_subset, aes_string(x = "scan_age", y = y_col, color = "participant_type")) +
            geom_vline(xintercept = c) +
            geom_point(size = 1, alpha = 0.5) +
            geom_smooth(method = "lm", formula = y ~ poly(x, 2)) + 
            labs(title = paste(y_col, "vs. Scan_age :", toupper(sex)), y = y_col)
        
        ggsave(filename = paste0("/~/", sex, "_max1_", y_col, ".png"), 
               plot = p, width = 25, height = 15, units = "cm")
    }
    
    for (y_col in y_max1) {
        rd_result <- rdrobust(y = df_subset[[y_col]], x = df_subset$scan_age, c = c, 
                              p = 2, kernel = "triangular", bwselect = "msetwo")
        
        ci_lower <- rd_result$ci[1, 1]
        ci_upper <- rd_result$ci[1, 2]
        coefficient <- rd_result$coef[1, 1]
        standard_error <- rd_result$se[1, 1]
        p_value <- rd_result$pv[1, 1]
        
        print(paste("[ 95% C.I. ] for", y_col, "(", sex, "):", paste(ci_lower, ci_upper, sep = " , ")))
        print(paste("Coefficient for", y_col, "(", sex, "):", coefficient))
        print(paste("Standard Error for", y_col, "(", sex, "):", standard_error))
        print(paste("P-value for", y_col, "(", sex, "):", p_value))
        print("----------------------------------------------------------")
    }
}
