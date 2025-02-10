library(ggplot2)

df1 <- read.csv("/~/finalized_perinatal_df.csv", header=TRUE, stringsAsFactors = FALSE)

cut_off <- #cut-off value
a <- #bandwidth (bw) output from RDD model for fetal
b <- #bandwidth (bw) output from RDD model for postnatal
shade_start <- cut_off - a 
shade_end <- cut_off + b 

df1$point_color <- ifelse(df1$scan_age >= shade_start & df1$scan_age <= shade_end, "gray", df1$participant_type)
participant_colors <- setNames(c("#F8766D", "#00BFC4"), unique(df1$participant_type))
colors <- c(participant_colors, "gray" = "gray")

p <- ggplot(df1, aes_string(x = "scan_age", y = "gyrification", color = "point_color")) +
    geom_vline(xintercept = cut_off) +
    geom_point(size = 1, alpha = 0.5) +
    labs(title = "Gyrification Index vs. Postconceptional Age", 
         x = "Postconceptional Age (weeks)", 
         y = "Gyrification Index (max = 1)") +
    scale_color_manual(values = colors) +
    theme(legend.position = "none") 

print(p)

ggsave("~/greyed_bw_gyrification.png", plot = p, width = 6, height = 4, bg="white")