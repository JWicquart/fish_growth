theme_perso <- function(base_size = 12, base_family = Famille){
  theme_bw(base_size = base_size, base_family = font_choose) %+replace%
    theme(
      axis.title = element_text(size = 14),
      axis.text=element_text(size=12),
      legend.key=element_rect(colour=NA, fill =NA),
      panel.grid = element_line(colour="#E8ECF1", size=0.5),
      panel.border = element_rect(fill = NA, colour = "black", size=1),
      panel.background = element_rect(fill = "white", colour = "black"),
      strip.background = element_rect(fill = NA)
    )
}
