### READ ME ###
updated by Ryan 2015-05-07

This is data from the Climate NA dataset, extracted using the Extent_Polygon that USFWS sent.
I converted the ClimateNA raster to points and then selected points that fell within the Extent 
Polygon. I exported and formatted those in a csv which can then be used in their software (ClimateNA_v5.11).

 - I extracted the 2050 and 2080 scenarios for all seasonal metrics for all RCP8.5 climate models.
 - I also extracted the Future Timeline from 2020-2100 for all metrics (Annual, Monthly, and Seasonal = MSYT at end of csv)
 - I also extracted the Historical Timeline (1901-2012) for all metrics.

 Citation for Data
----------------------------
Hamann, A., T. Wang, D. L. Spittlehouse, T. Q. Murdock. 2013. A comprehensive, high-resolution  database of historical and projected climate surfaces for western North America. Bulletin of the American Meteorological Society, 94(9): 1307-1309. 


 Files ending with:
 "S" = Seasonal Metrics
 "M" = Monthly
 "A" = Annual

 ---------------------------
 Metrics are described below: 
 ----------------------------

Monthly variables:
Tmin: minimum temperature for a given month (°C)
Tmax: maximum temperature for a given month (°C)
PPT:  total precipitation for a given month (mm)

Bioclimatic variables:
MAT:  mean annual temperature (°C)
MCMT: mean temperature of the coldest month (°C)
MWMT: mean temperature of the warmest month (°C)
TD:   difference between MCMT and MWMT, as a measure of continentality (°C)
MAP:  mean annual precipitation (mm)
MSP:  mean summer (May to Sep) precipitation (mm)
AHM:  annual heat moisture index, calculated as (MAT+10)/(MAP/1000)
SHM:  summer heat moisture index, calculated as MWMT/(MSP/1000)

DD.0: degree-days below 0°C (chilling degree days)
DD.5: degree-days above 5°C (growing degree days)
NFFD: the number of frost-free days
bFFP: the julian date on which the frost-free period begins
eFFP: the julian date on which the frost-free period ends
PAS:  precipitation as snow (mm)
EMT:  extreme minimum temperature over 30 years
Eref: Hargreave's reference evaporation
CMD:  Hargreave's climatic moisture index
CMI:  Hogg's climate moisture index
cmiJJA: Hogg's summer (Jun to Aug) climate moisture index

Tave_wt: winter (Dec to Feb) mean temperature (°C)
Tave_sm: summer (Jun to Aug) mean temperature (°C)
PPT_wt:  winter (Dec to Feb) precipitation (mm)
PPT_sm:  summer (Jun to Aug) precipitation (mm)
 
