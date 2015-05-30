function(){
	tabPanel("Background Info",
		p(style="text-align:justify",'This web application uses data from BIOCLIM, Climate NA, and CMIP5 datasets. Standard error bars have been included for each variable set. Keep in mind that BIOCLIM and CMIP5 data represent temporal variability of these GCM data, whereas ClimateNA represents spatial variability within the refuge for these GCM data. 

BIOCLIM has been downscaled at a ?? scale and was derived from PRISM data (see weblinks below).
ClimateNA uses an elevational driven downscaling with PRISM, and is based on CMIP5 GCM models.
CMIP5 has been downscaled to a 4km scale.
		  
		This is part of a collaborative project with the Southwest Climate Science Group, UC Davis (JMIE) and USFWS. This data is subject to change and is only meant for visualization and comparison purposes. The plots are downloadable if you right click in or on the plot and "save image". '),
		br(),

		#HTML('<div style="clear: left;"><img src="https://watershed.ucdavis.edu/files/cwsheader_0.png" style="float: left; margin-right:5px; height=20%;"/></div>'),
		strong('Author'),
		p('Ryan Peek and Eric Holmes',br(),
			a('Center for Watershed Sciences', href="http://watershed.ucdavis.edu/", target="_blank")
		),
		br(),

		div(class="span4",
        strong('Code'),
        p('Source code available:',
          a("Here", href="https://github.com/ryan-ucd/climate-extraction",target="_blank")),
        br()
      ),

    div(class="span4",
				strong('References'),
				p(HTML('<ul>'),
				  HTML('<li>'),a('BIOCLIM', href="http://www.worldclim.org/bioclim", target="_blank"),HTML('</li>'),
				  HTML('<li>'),a('Climate NA', href="http://adaptwest.databasin.org/pages/adaptwest-climatena", target="_blank"),HTML('</li>'),
          HTML('<li>'),a('CMIP5 Downscaled', href="http://gdo-dcp.ucllnl.org/downscaled_cmip_projections/dcpInterface.html#About", target="_blank"),HTML('</li>'),
				  HTML('</ul>'),
				  br(),
          HTML('<li>'),strong("Additional resources"),HTML('</li>'),
					HTML('<ul>'),
				  HTML('<li>'),a('Coded in R', href="http://www.r-project.org/", target="_blank"),HTML('</li>'),
				  HTML('<li>'),a('Built with the Shiny package', href="http://www.rstudio.com/shiny/", target="_blank"),HTML('</li>'),
					HTML('<li>'),a('ggplot2', href="http://cran.r-project.org/web/packages/ggplot2/index.html", target="_blank"),HTML('</li>'),
				  HTML('</ul>'))
		)
	)
}

