# Codes for downloading the ERA5 data for running the WRF model
> **Contact person:** Amirhossein Nikfal (https://github.com/anikfal).

## You need to modify the codes below according to your own requirement:

- **`era5_surface.py`**: Code for retrieving ERA5 data for surface data

- **`era5_level.py`**: Code for retrieving ERA5 data for level data

> **Note:** Only modify the dates and time, and geographical domain. Don't toutch the variable names, since they are the standard requird data for running the WRF model. Although you can also change the variable names if you want to get arbitrary data for other applications.

## Prerequisite for running the codes:
You need to install cdsiapi python module and setup the CDS API personal access token. For example, on Linux, you need to set the `~/.cdsapirc` file. Something similar to below:
```
url: https://cds.climate.copernicus.eu/api
key: ????????????????????????????????????
```
For more information, take a look at https://cds.climate.copernicus.eu/how-to-api.