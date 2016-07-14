convert erlang binary trace file to text

The binary file should be written with `dbg:trace_port(file, ...)`

This program uses all available cpus to make the job faster.

The timing for the 200MB binary trace file:

- `dbg:trace_client/1` takes 12 minutes
- `trace_conv:conv_parts/0` takes 5 minutes

PS: if you have 200MB trace, then you might be doing something wrong...
