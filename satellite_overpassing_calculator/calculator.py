#This code calculates the overpassing times of a specific satellite over a specific geographical area.
#Contact person: Amirhossein Nikfal <https://github.com/anikfal>

from pyorbital.orbital import Orbital
from datetime import datetime, timedelta
import yaml, os

with open('input.yaml', 'r') as yaml_file:
    inputFile = yaml.safe_load(yaml_file)
with open('satellite_names.yaml', 'r') as yaml_file:
    satNameFile = yaml.safe_load(yaml_file)
satIndex = inputFile["satellite_information"]["sat_name_index"]
if satIndex > 76:
    print("Warning: Satellite name index must be between 1 to 76. Please look inside <satellite_names.yaml>.")
    print("exiting ..")
    exit()
data_time_interval = inputFile["satellite_information"]["data_time_interval"]
start_year = inputFile["look_up_time_range"]["start_year"]
start_month = inputFile["look_up_time_range"]["start_month"]
start_day = inputFile["look_up_time_range"]["start_day"]
start_hour = inputFile["look_up_time_range"]["start_hour"]
end_year = inputFile["look_up_time_range"]["end_year"]
end_month = inputFile["look_up_time_range"]["end_month"]
end_day = inputFile["look_up_time_range"]["end_day"]
end_hour = inputFile["look_up_time_range"]["end_hour"]
north_latitude = inputFile["look_up_geographical_domain"]["north_latitude"]
south_latitude = inputFile["look_up_geographical_domain"]["south_latitude"]
west_longitude = inputFile["look_up_geographical_domain"]["west_longitude"]
east_longitude = inputFile["look_up_geographical_domain"]["east_longitude"]
STARTTIME = datetime(start_year, start_month, start_day, start_hour, 0, 0)
ENDTIME = datetime(end_year, end_month, end_day, end_hour, 0, 0)
TIMEDIFF = ENDTIME - STARTTIME
hours_diff = int(TIMEDIFF.total_seconds() / 3600)

print("  1) Looking for the best", satNameFile[satIndex], "footprints over the geographical domain ...")
orb = Orbital(satNameFile[satIndex])
good_time = []
for hourstep in range(hours_diff):
    for minute in range(0, 60, data_time_interval):
        mytime = datetime(start_year, start_month, start_day, start_hour, minute, 0) + timedelta(hours=hourstep)
        print(mytime)
        var = str(orb.get_lonlatalt(mytime)).split(',')
        lon1 = var[0]
        lon = float(lon1[1:])
        lat1 = var[1]
        lat = float(lat1[1:])
        if lat<40 and lat>4 and lon>34 and lon<74 :
                print("      FOUND lat lon: " + str(lat) + " " + str(lon) + str(mytime))
                good_time.append(mytime.strftime("%Y")+str('{:03d}'.format(mytime.timetuple().tm_yday))+"_"+mytime.strftime("%H%M")) #Year + day of year

filepath = "overpassing_times_" + satNameFile[satIndex] + ".txt"
if os.path.exists(filepath):
    os.remove(filepath)
print("  2) Writing the found times " + str(good_time) + " in file")
timefile = open(filepath, "a+")
for timeindex in range(len(good_time)):
    timefile.write("%s\n" %good_time[timeindex])