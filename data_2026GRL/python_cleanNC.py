import netCDF4 as nc
import os

# Define the path to the folder containing the NetCDF files
folder_path = '/disk/v016.b/yfanaj/important_model_or_data/publish/data_2026GRL/'

# List all NetCDF files in the folder
netcdf_files = [f for f in os.listdir(folder_path) if f.startswith('wrf_') and f.endswith('.nc')]

# Function to clean a NetCDF file
def clean_netcdf(file_path):
    with nc.Dataset(file_path, 'r+') as dataset:
        # Get all variable names
        variables = list(dataset.variables.keys())
        
        # Loop through each variable and keep only name, unit, and coordinate
        for var in variables:

            var_obj = dataset.variables[var]
            attrs_to_keep = ['units', 'coordinates', 'description']
            attrs = list(var_obj.ncattrs())
            for dim in var_obj.dimensions:
                if dim == 'XTIME':
                    dataset.renameDimension('XTIME', 'xtime')
                if dim == 'south_north':
                    dataset.renameDimension('south_north', 'lat2d_wrf')
                if dim == 'west_east':
                    dataset.renameDimension('west_east', 'lon2d_wrf')

            for attr in attrs:
                if attr not in attrs_to_keep:
                    var_obj.delncattr(attr)
            if 'coordinates' in var_obj.ncattrs():
                coordinates = var_obj.getncattr('coordinates')
                coordinates = coordinates.replace('XLAT', 'lat2d_wrf').replace('XLONG', 'lon2d_wrf')
                var_obj.setncattr('coordinates', coordinates)
            if 'description' in var_obj.ncattrs():
                description = var_obj.getncattr('description')
                if description.isupper():
                    var_obj.setncattr('description', description.capitalize())
        
            if var == 'lat1d_wrf':
                dataset.renameVariable('lat1d_wrf', 'XLAT_r')
            if var == 'lon1d_wrf':
                dataset.renameVariable('lon1d_wrf', 'XLONG_r')
            
        # Clean global attributes
        global_attrs_to_keep = []#'title', 'institution', 'source', 'references']
        global_attrs = list(dataset.ncattrs())
        for attr in global_attrs:
            dataset.delncattr(attr)
            # Add global attributes
            dataset.setncattr('title', 'WRF simulated heat-related variables under non-irrigation, irrigate but static vegetation, and irrigate with dynamic vegetation')
            dataset.setncattr('institution', 'Hong Kong University of Science and Technology')
            dataset.setncattr('Author', 'Yuwen Fan (yfanaj@connect.ust.hk) and Eun-Soon Im')


# Process each NetCDF file
for netcdf_file in netcdf_files[:]:  # Only process the first 6 files
    print(netcdf_file)
    file_path = os.path.join(folder_path, netcdf_file)
    clean_netcdf(file_path)