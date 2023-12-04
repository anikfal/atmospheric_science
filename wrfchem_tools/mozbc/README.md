**Auxiliary code to make mozbc.inp file**

`set_mozbc_input.sh` is an auxiliary code by which you can make the `mozbc.inp` file to run the `mozbc` utility (without any error!).

Before running `set_mozbc_input.sh`, you need to provide correct paths and names for `WRF_namelist_input_file_path`, `MOZBC_directory_path`, and `WACCM_data_file_name`.

After setting the paths to `namelist.input`, MOZBC directory, and the WACCM data file, you can run `set_mozbc_input.sh` in the MOZBC directory:
`./set_mozbc_input.sh`

If the run is successful, the `mozbc.inp` file will be generated which you can use to run the `mozbc` utility by the command below:
`./mozbc < mozbc.inp > mozbc.out`

If running `mozbc` is successful, your `wrfinput_d01` and `wrfbdy_d01` files will be updated by the boundary values for some available variables in the WACCM file, such as NO, SO2, CO, etc.