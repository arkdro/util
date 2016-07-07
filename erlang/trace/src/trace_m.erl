-module(trace_m).

-export([
         prepare_matches/1,
         start/1,
         start_matches/1,
         stop/0
        ]).

-include_lib("stdlib/include/ms_transform.hrl").

-record(uinfo, {user :: binary(),
                last :: erlang:timestamp()
               }).

prepare_matches(U) ->
  Mall = dbg:fun2ms(fun(_)-> true, return_trace() end),

  Mredis = dbg:fun2ms(
             fun([User, _]) when User =:= U -> true, return_trace();
                (_) -> message(false)
             end),

  Msend = dbg:fun2ms(
               fun([_, #uinfo{user = User}, _]) when User =:= U -> true, return_trace();
                  (_) -> message(false)
               end),

  Mprep = dbg:fun2ms(
            fun([_, #uinfo{user = User}, _, _, _, _]) when User =:= U -> true, return_trace();
               (_) -> message(false)
            end),
  [Mall, Mredis, Msend, Mprep].

start(User) ->
  Matches = prepare_matches(User),
  start_matches(Matches).

start_matches(Matches) ->
  [Mall, Mredis, Msend, Mprep | _] = Matches,
  Prepared = [
              {{erlcloud_sqs, request, '_'}, Mall},
              {{log, info, '_'}, Mall},
              {srv_redis, Mredis},
              {{users, send, '_'}, Msend},
              {{users, prepare, '_'}, Mprep}
             ],
  trace:start_mix(Prepared).

stop() ->
  trace:stop().

