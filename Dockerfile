FROM rocker/geospatial:4.2.2-ubuntugis
RUN /rocker_scripts/install_tidyverse.sh
#RUN apt-get install libudunits2-dev libgdal-dev libgeos-dev libproj-dev libsqlite0-dev

RUN install2.r rsconnect bslib data.table fable fabletools feasts ggdist ggtext glue
RUN install2.r htmltools janitor lubridate magrittr markdown scales shiny
RUN install2.r shinycssloaders shinyWidgets thematic tsibble remotes
CMD Rscript "remotes::install_github('r-spatial/sf')"
WORKDIR /home/capstonePrototype
COPY app.R app.R
COPY R R
COPY DESCRIPTION DESCRIPTION
COPY NAMESPACE NAMESPACE
COPY inst inst
COPY data data
COPY .Rbuildignore .Rbuildignore
COPY dev/deploy.R dev/deploy.R
CMD Rscript dev/deploy.R
