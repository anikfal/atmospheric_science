# Shell script for downloading the GFS Forecast GRIB data
> **Contact person:** Amirhossein Nikfal (https://github.com/anikfal).

This Shell script downloades GFS Forecast data files for the current day.

You need to modify a few variables in the `gfs_download_manager.sh` file before running the code.

| Variable         | Description                                                    |
|------------------|----------------------------------------------------------------|
| `start_year`      | No need to be changed. It is preset for the current day                                  |
| `start_month`     | No need to be changed. It is preset for the current day                         |
| `start_day`      | No need to be changed. It is preset for the current day                              |
| `total_run_hours` | Total run hours of the WRF model   |
| `gfs_start_hour` | Can be 0, 6, 12, or 18   |
| `gfs_hour_interval` | Can be 3, or 6   |
