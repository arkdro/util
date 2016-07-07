-module(trace).

-export([
         start_mix/1,
         start_mix/3,
         start/1,
         start/2,
         start/3,
         start/4,
         stop/0
        ]).

start(Modules) ->
    Match = [{'_',[],[true,{return_trace}]}],
    start(Modules, Match).

start(Modules, Match) ->
    Opts = [c, timestamp],
    start(Modules, Match, Opts).

start(Modules, Match, Opts) ->
    Processes = all,
    start(Modules, Match, Opts, Processes).

start(Modules, Match, Opts, Processes) ->
    File = prepare_file(),
    Suffix = suffix(),
    Size = 200000000,
    Port = dbg:trace_port(file, {File, wrap, Suffix, Size}),
    dbg:tracer(port, Port),
    dbg:p(Processes, Opts),
    [dbg:tpl(Module, Match) || Module <- Modules].

start_mix(Patterns) ->
    Processes = all,
    Opts = [c, timestamp],
    start_mix(Patterns, Opts, Processes).

start_mix(Patterns, Opts, Processes) ->
    File = prepare_file(),
    Suffix = suffix(),
    Size = 200000000,
    Port = dbg:trace_port(file, {File, wrap, Suffix, Size}),
    dbg:tracer(port, Port),
    dbg:p(Processes, Opts),
    [dbg:tpl(Module, Match) || {Module, Match} <- Patterns].

stop() ->
    dbg:ctpl(),
    dbg:flush_trace_port(),
    dbg:stop_clear().

%% ==========================================================================
%% internal functions
%% ==========================================================================

dir() ->
    filename:join("/tmp", "trc").

base() ->
    "t-".

suffix() ->
    ".trc".

prepare_file() ->
    Dir = dir(),
    Time = get_time(),
    File = lists:flatten(io_lib:format("~s~w-", [base(), Time])),
    Fullname = filename:join(Dir, File),
    filelib:ensure_dir(Fullname),
    Fullname.

get_time() ->
    {MS, S, _} = os:timestamp(),
    MS * 1000000 + S.

