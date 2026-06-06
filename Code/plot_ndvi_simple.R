library(ggplot2)

setwd("./WD")

if (!file.exists("v_ndvi_df.rds")) stop("v_ndvi_df.rds not found")

v_ndvi_df <- readRDS("v_ndvi_df.rds")
if (!is.data.frame(v_ndvi_df)) stop("v_ndvi_df.rds does not contain a data frame")

ndvi_long <- stack(v_ndvi_df)
ndvi_long$date <- as.Date(paste0(as.character(ndvi_long$ind), "01"), format = "%Y%m%d")
ndvi_long$date_label <- format(ndvi_long$date, "%Y-%m")

# drop first and last date
all_dates <- unique(ndvi_long$date_label)
if (length(all_dates) > 2) {
  keep_dates <- all_dates[-c(1, length(all_dates))]
  ndvi_long <- ndvi_long[ndvi_long$date_label %in% keep_dates, ]
} else {
  warning("Not enough dates to drop first and last; plotting all dates")
}

ndvi_long$date_f <- factor(ndvi_long$date_label, levels = unique(ndvi_long$date_label))

p <- ggplot(ndvi_long, aes(x = date_f, y = values)) +
  geom_violin(width = 0.7, fill = "#4C78A8", alpha = 0.35, color = "#2F4B7C", trim = TRUE, adjust = 1.8, scale = "width") +
  labs(x = "Date", y = "NDVI", title = "NDVI Violin (excluding first and last date)") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  coord_cartesian(ylim = c(0, 0.6))

ggsave("../Images/ndvi_violin_simple.png", plot = p, width = 10, height = 5, dpi = 300)
message("Saved Images/ndvi_violin_simple.png")

setwd("../")
