library(tidyverse)  
library(broom)  
library(rdrobust)


df1 <- read.csv("~/perinatal_df.csv", header=TRUE, stringsAsFactors = FALSE)
y_cols = c("volume_CSF", "volume_cGM","volume_WM","volume_VENTRICLES","volume_CEREBELLUM","volume_dGM","volume_BRAINSTEM","volume_HIPPOCAMPI","brain_volume", "TTV","TBV" ,"ICV" , "white_surface_area" ,"white_gyrification_index")



#Normalizing data to max=1 and changing col names
for (y_col in y_cols) {
     max_value <- max(df1[[y_col]], na.rm = TRUE)
     normalized_col <- paste0(y_col, "_max1")
     df1[[normalized_col]] <- df1[[y_col]] / max_value
}
dim(df1)
y_max1 = c("total_CSF_max1","volume_cGM_max1","volume_WM_max1","volume_CEREBELLUM_max1","volume_dGM_max1","volume_BRAINSTEM_max1","volume_HIPPOCAMPI_max1","brain_volume_max1", "TTV_max1","TBV_max1","ICV_max1","white_surface_area_max1","white_gyrification_index_max1")
y_max1 = c("total_CSF_max1" = "Total CSF Volume",
            "volume_cGM_max1" = "Cortical Gray Matter Volume",
            "volume_WM_max1" = "White Matter Volume",
            "volume_CEREBELLUM_max1" = "Cerebellum Volume",
            "volume_dGM_max1" = "Deep Gray Matter Volume",
            "volume_BRAINSTEM_max1" = "Brainstem Volume",
            "volume_HIPPOCAMPI_max1" = "Hippocampi Volume",
            "ICV_max1" = "Intracranial Volume",
            "white_surface_area_max1" = "White Surface Area",
            "white_gyrification_index_max1" = "Gyrification Index")

c = #cut-off value
#Create the plots:
for (y_col in names(y_max1)) {
    p <- ggplot(df1, aes_string(x = "scan_age", y = y_col, color = "participant_type")) +
        geom_vline(xintercept = c) +
        geom_point(size = 1, alpha = 0.5) +
        geom_smooth(method = "lm", formula = y ~ poly(x, 2)) +
        labs(
             x = "Postconceptional Age (in weeks)", 
             y = y_max1[y_col],
             color = "Participant Type") 
    ggsave(filename = paste0("~/max1_plot_", y_max1[y_col], ".png"), 
           plot = p, width = 25, height = 15, units = "cm")
}


results_list <- list()

#Running the regression discontinuity model
for (y_col in y_max1) {
    rd_result <- rdrobust(y = df1[[y_col]], x = df1$scan_age, c = c, p = 2, kernel = "triangular", bwselect="msetwo") #can change kernel, p, etc;
    
    #rd_summary <- summary(rd_result)
    #print(paste("Summary for", y_col))
    #print(rd_summary)
    
    ci_lower <- rd_result$ci[1, 1]
    ci_upper <- rd_result$ci[1, 2]
    coefficient <- rd_result$coef[1, 1]
    standard_error <- rd_result$se[1, 1]
    p_value <- rd_result$pv[1, 1]
    bw_left <- rd_result$bws[1,1]
    bw_right <- rd_result$bws[1,2]
    effect_size = coefficient/standard_error
    
    
    print(paste("[ 95% C.I. ] for", y_col, ":", paste(ci_lower, ci_upper, sep = " , ")))
    print(paste("Bandwidth (left of cutoff) for", y_col, ":", bw_left))
    print(paste("Bandwidth (right of cutoff) for", y_col, ":", bw_right))
    print(paste("Coefficient for", y_col, ":", coefficient))
    print(paste("Standard Error for", y_col, ":", standard_error))
    print(paste("P-value for", y_col, ":", p_value))
    print(paste("Effect Size for", y_col, ":", effect_size))
    print("----------------------------------------------------------")
    
    results_list[[y_col]] <- c(y_col, ci_lower, ci_upper, coefficient, standard_error, bw_left, bw_right,p_value, effect_size)
}

results_df <- do.call(rbind, results_list)
colnames(results_df) <- c("Variable", "CI_Lower", "CI_Upper", "Coefficient", "Standard_Error", "Bandwidth_Left", "Bandwidth_Right", "P_Value", "Effect_size")

write.csv(results_df, "/~/rdrobust_output.csv", row.names = FALSE)

