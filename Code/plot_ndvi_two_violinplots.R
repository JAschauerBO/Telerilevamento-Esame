library(ggplot2)

setwd("./WD")

if (!file.exists("v_ndvi_df.rds")) stop("v_ndvi_df.rds not found")

v_ndvi_df <- readRDS("v_ndvi_df.rds")
if (!is.data.frame(v_ndvi_df)) stop("v_ndvi_df.rds does not contain a data frame")

ndvi_long <- stack(v_ndvi_df)
ndvi_long$date <- as.Date(paste0(as.character(ndvi_long$ind), "01"), format = "%Y%m%d")
ndvi_long$date_label <- format(ndvi_long$date, "%Y-%m")

# drop first and last date for the "normal" plot
all_dates <- unique(ndvi_long$date_label)
if (length(all_dates) > 2) {
  keep_dates <- all_dates[-c(1, length(all_dates))]
  ndvi_normal <- ndvi_long[ndvi_long$date_label %in% keep_dates, ]
} else {
  warning("Not enough dates to drop first and last; plotting all dates")
  ndvi_normal <- ndvi_long
}
ndvi_normal$date_f <- factor(ndvi_normal$date_label, levels = unique(ndvi_normal$date_label))

# Plot 2: wide violinplot for 2023-2025 only
ndvi_wide <- ndvi_long[ndvi_long$date_label %in% c("2023-08", "2024-08", "2025-08"), ]
ndvi_wide$date_f <- factor(ndvi_wide$date_label, levels = c("2023-08", "2024-08", "2025-08"))

p_wide <- ggplot(ndvi_wide, aes(x = date_f, y = values)) +
  geom_violin(width = 1.2, fill = "#4C78A8", alpha = 0.35, color = "#2F4B7C", trim = TRUE, adjust = 2.5, scale = "width") +
  labs(x = "Date", y = "NDVI", title = "NDVI Violin Plot (wide, 2023-2025)") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  coord_cartesian(ylim = c(0, 0.6))

plot(p_wide)
ggsave("../Images/ndvi_violin_wide_2023_2025.png", plot = p_wide, width = 8, height = 5, dpi = 300)

message("Saved Images/ndvi_violin_normal.png and Images/ndvi_violin_wide_2023_2025.png")

setwd("../")
