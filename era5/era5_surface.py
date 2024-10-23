import cdsapi

c = cdsapi.Client()

dataset = "reanalysis-era5-single-levels"
request = {
    "product_type": ["reanalysis"],
    "variable": [
        "10m_u_component_of_wind",
        "10m_v_component_of_wind",
        "2m_dewpoint_temperature",
        "2m_temperature",
        "mean_sea_level_pressure",
        "sea_surface_temperature",
        "surface_pressure",
        "total_precipitation",
        "skin_temperature",
        "surface_latent_heat_flux",
        "top_net_solar_radiation_clear_sky",
        "snow_depth",
        "soil_temperature_level_1",
        "soil_temperature_level_2",
        "soil_temperature_level_3",
        "soil_temperature_level_4",
        "soil_type",
        "volumetric_soil_water_layer_1",
        "volumetric_soil_water_layer_2",
        "volumetric_soil_water_layer_3",
        "volumetric_soil_water_layer_4",
        "leaf_area_index_high_vegetation",
        "geopotential",
        "land_sea_mask",
        "sea_ice_cover"
    ],
    "year": ["2022"],
    "month": ["03"],
    'day': [
        '13', '14', '15',
    ],
    'time': [
        '00:00', '03:00', '06:00',
        '09:00', '12:00', '15:00',
        '18:00', '21:00',
    ],
    "data_format": "grib",
    "download_format": "unarchived",
    'area': [
        45, 35, 20,
        70, #North, West, South, East
    ],
}
target = "single.grib"

c.retrieve(dataset, request, target)