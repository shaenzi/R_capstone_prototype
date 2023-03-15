FROM rocker/tidyverse:4.2.2
RUN apt-get -y update && apt-get install -y  libudunits2-dev libgdal-dev libgeos-dev libproj-dev
RUN install2.r rsconnect bslib data.table fable fabletools feasts ggdist ggtext glue
RUN install2.r htmltools janitor lubridate magrittr markdown scales sf shiny
RUN install2.r shinycssloaders shinyWidgets thematic tsibble
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
