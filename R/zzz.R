#---------------------------------------------#
# DO NOT EDIT THIS FILE OR ADD ANYTHING TO IT #
#---------------------------------------------#

.onLoad <- function(...){
	shiny::addResourcePath(
		"img",
		system.file("app/www", package = "capstonePrototype")
	)
  #addResourcePath('datasets', system.file('data', package='datasets'))
}

#---------------------------------------------#
# DO NOT EDIT THIS FILE OR ADD ANYTHING TO IT #
#---------------------------------------------#
