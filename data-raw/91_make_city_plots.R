
# create a plot for zurich
bb_zh <- osmdata::getbb("zurich")
osm_zh <- get_osm_data(bb_zh)
# colors reshuffled from the qual6 paleTte of zuericolors https://github.com/StatistikStadtZuerich/zuericolors
pal <- rev(c("#3431DE", "#1D942E", "#DB247D", "#FBB900", "#23C3F1", "#FF720C"))

plot_zh <- plot_zurich(osm_zh, pal)

# create a plot for winterthur
bb_wi <- osmdata::getbb("winterthur")
osm_wi <- get_osm_data(bb_wi)

pal <- MetBrewer::met.brewer(name="Homer2", n=6, type = "discrete")
plot_wi <- plot_winterthur(osm_wi, pal)

#create plot for Basel
bb_bs <- osmdata::getbb("basel")
osm_bs <- get_osm_data(bb_bs)

pal <- MetBrewer::met.brewer(name="Pillement", n=6, type = "discrete")
plot_bs <- plot_basel(osm_bs, pal)

# save the plots
ggplot2::ggsave(file.path("inst", "app", "www", "basel1.png"), plot = plot_bs, dpi=200)
ggplot2::ggsave(file.path("inst", "app", "www", "winti1.png"), plot = plot_wi, dpi=200)
ggplot2::ggsave(file.path("inst", "app", "www", "zurich1.png"), plot = plot_zh, dpi=200)

