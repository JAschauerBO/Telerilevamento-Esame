library(ggplot2)

setwd("./WD")

if (!file.exists("v_ndvi_df.rds")) stop("v_ndvi_df.rds not found")

v_ndvi_df <- readRDS("v_ndvi_df.rds")
if (!is.data.frame(v_ndvi_df)) stop("v_ndvi_df.rds does not contain a data frame")

ndvi_long <- stack(v_ndvi_df)
ndvi_long$date <- as.Date(paste0(as.character(ndvi_long$ind), "01"), format = "%Y%m%d")
ndvi_long <- ndvi_long[order(ndvi_long$date), ]
ndvi_long$date_label <- format(ndvi_long$date, "%Y-%m")

# remove first and last date
all_dates <- unique(ndvi_long$date_label)
if (length(all_dates) > 2) {
  keep_dates <- all_dates[-c(1, length(all_dates))]
  ndvi_long <- ndvi_long[ndvi_long$date_label %in% keep_dates, ]
  ndvi_long$date_f <- factor(ndvi_long$date_label, levels = keep_dates)
} else {
  warning("Not enough dates to drop first and last; plotting all dates")
  ndvi_long$date_f <- factor(ndvi_long$date_label, levels = all_dates)
}

ndvi_plot <- ggplot(ndvi_long, aes(x = date_f, y = values, group = date_f)) +
  geom_violin(width = 0.9, fill = "#4C78A8", alpha = 0.22, color = "#2F4B7C", trim = TRUE, linewidth = 0.3) +
  geom_boxplot(width = 0.2, outlier.shape = NA, fill = "white", color = "#1F1F1F", alpha = 0.9, linewidth = 0.3) +
  scale_x_discrete(labels = levels(ndvi_long$date_f)) +
  labs(
    x = "Date",
    y = "NDVI",
    title = "NDVI Distribution by Date"
  ) +
  coord_cartesian(ylim = c(0, 1)) +
  theme_classic(base_size = 12) +
  theme(
    panel.grid.minor = element_blank(),
    axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1, size = 9),
    axis.title = element_text(face = "bold"),
    plot.title = element_text(face = "bold"),
    plot.margin = margin(10, 12, 10, 10)
  )

print(ndvi_plot)

ggsave("../Images/ndvi_violin_boxplot.png", plot = ndvi_plot, width = 12, height = 6, dpi = 300)
message("Plot saved to Images/ndvi_violin_boxplot.png")

setwd("../")
