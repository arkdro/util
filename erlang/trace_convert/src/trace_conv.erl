-module(trace_conv).

-export([
         process_one_part/4,
         conv_parts/0
        ]).

conv_parts() ->
    {ok, [[File]]} = init:get_argument(f),
    conv_parts(File),
    halt(0).

conv_parts(File) ->
    L = get_parts(File),
    L2 = spawn_parts(File, L),
    wait_parts(L2),
    build_output(File, L2),
    clean(L2).

get_parts(File) ->
    N = erlang:system_info(logical_processors_online),
    get_parts(File, N).

get_parts(File, N) ->
    Size = filelib:file_size(File),
    Bounds = [trunc(Size * X / N) || X <- lists:seq(1, N)],
    Fd = prepare_input(File),
    Res = get_parts2(Fd, Bounds),
    ok = file:close(Fd),
    Res.

get_parts2(Fd, Bounds) ->
    Acc = [{cnt, 0},
           {prev_pos, 0},
           {out, [{0, 0}]}],
    {ok, Acc2} = get_parts2(Fd, Bounds, Acc),
    Out = proplists:get_value(out, Acc2),
    Out2 = lists:reverse(Out),
    fill_length(Out2).

get_parts2(Fd, Bounds, Acc) ->
    case handle_one_term(Fd) of
        {ok, eof} ->
            Acc2 = add_dummy_end(Fd, Acc),
            {ok, Acc2};
        {ok, Pos} ->
            {Bounds2, Acc2} = check_bounds(Pos, Bounds, Acc),
            get_parts2(Fd, Bounds2, Acc2);
        {error, _} = Error ->
            {error, {Error, Acc}}
    end.

handle_one_term(Fdi) ->
    Hdr = 5,
    case file:read(Fdi, Hdr) of
        {ok, Bin} ->
            read_term(Fdi, Bin);
        eof ->
            {ok, eof};
        {error, _} = Error ->
            Error
    end.

read_term(Fdi, <<0, Size:32>>) ->
    case file:position(Fdi, {cur, Size}) of
        {ok, Pos} ->
            {ok, Pos};
        eof ->
            {ok, eof};
        {error, _} = Error ->
            Error
    end;
read_term(_Fdi, <<1, _Size:32>>) ->
    {ok, drop}; %% will fail with bad match
read_term(_Fdi, <<_Other, _Size:32>>) ->
    {error, unknown_opcode}.

prepare_input(File) ->
    {ok, Fd} = file:open(File, [read, raw, binary]),
    Fd.

check_bounds(Pos, [H | T] = Bounds, Acc) ->
    PrevPos = proplists:get_value(prev_pos, Acc),
    Acc2 = update_acc(Pos, Acc),
    PrevDelta = abs(H - PrevPos),
    Delta = abs(H - Pos),
    case PrevDelta < Delta of
        true ->
            Acc3 = add_out_bound(Pos, Acc2),
            {T, Acc3};
        false ->
            {Bounds, Acc2}
    end.

update_acc(Pos, Acc) ->
    Cnt = proplists:get_value(cnt, Acc),
    Acc2 = lists:keystore(prev_pos, 1, Acc, {prev_pos, Pos}),
    lists:keystore(cnt, 1, Acc2, {cnt, Cnt + 1}).

add_out_bound(Pos, Acc) ->
    Out = proplists:get_value(out, Acc),
    Cnt = proplists:get_value(cnt, Acc),
    Item = {Cnt, Pos},
    Out2 = [Item | Out],
    lists:keystore(out, 1, Acc, {out, Out2}).

add_dummy_end(Fd, Acc) ->
    {ok, Pos} = file:position(Fd, cur),
    Out = proplists:get_value(out, Acc),
    Item = {0, Pos},
    Out2 = [Item | Out],
    lists:keystore(out, 1, Acc, {out, Out2}).

fill_length(L) ->
    {_, L2} = lists:unzip(L),
    L3 = lists:zip(L2, tl(L2 ++ [-1])),
    L4 = [B-A || {A, B} <- L3],
    Lengths = lists:droplast(L4),
    F = fun({A, B}, C) ->
                {A, B, C}
        end,
    lists:zipwith(F, lists:droplast(L), Lengths).

prepare_input_file(File, I, Offset, Len) ->
    {ok, Fdi} = file:open(File, [read, raw, binary]),
    {ok, Offset} = file:position(Fdi, {bof, Offset}),
    Out_file = prepare_output_filename(File, I),
    {ok, Fdo} = file:open(Out_file, [write, raw, binary]),
    {ok, Len} = file:copy(Fdi, Fdo, Len),
    ok = file:close(Fdi),
    ok = file:close(Fdo),
    Out_file.

prepare_output_filename(File, I) ->
    filename:flatten([File, "-", I]).

wait_for_finish(_Out, Pid) ->
    Ref = monitor(process, Pid),
    receive
        {'DOWN', Ref, _, _, Info} ->
            Info
    end.

spawn_parts(File, L) ->
    [spawn_one_part(File, X) || X <- L].

spawn_one_part(File, {_Cnt, Offset, Len}) ->
    Out_file = prepare_output_text_filename(File, Offset),
    Pid = spawn(?MODULE, process_one_part, [File, Out_file, Offset, Len]),
    timer:sleep(100),
    {Out_file, Pid}.

process_one_part(File, Out_file, Offset, Len) ->
    I = integer_to_list(Offset),
    File2 = prepare_input_file(File, I, Offset, Len),
    Fdo = prepare_output_file(Out_file),
    Pid = (catch dbg:trace_client(file, File2, {fun dbg:dhandler/2, Fdo})),
    wait_for_finish(stub, Pid),
    ok = file:close(Fdo),
    ok = file:delete(File2),
    ok.

prepare_output_file(File) ->
    {ok, Fd} = file:open(File, [write, binary]),
    Fd.

prepare_output_text_filename(File, I) ->
    filename:flatten([prepare_output_text_filename(File),
                      "-",
                      integer_to_list(I)]).

prepare_output_text_filename(File) ->
    filename:flatten([File, ".out"]).

clean(L) ->
    [file:delete(File) || {File, _} <- L].

wait_parts(L) ->
    Refs = [monitor(process, Pid) || {_, Pid} <- L],
    wait_parts_loop(Refs).

wait_parts_loop([]) ->
    ok;
wait_parts_loop(Refs) ->
    receive
        {'DOWN', Ref, _, _, _} ->
            Refs2 = check_one_result(Refs, Ref),
            wait_parts_loop(Refs2)
    end.

check_one_result(Refs, Ref) ->
    case lists:member(Ref, Refs) of
        true ->
            lists:delete(Ref, Refs);
        false ->
            Refs
    end.

build_output(File, L2) ->
    Out = prepare_output_text_filename(File),
    {ok, Fd} = file:open(Out, [write, raw, binary]),
    [add_one_file(Fd, Name) || {Name, _} <- L2],
    ok = file:close(Fd).

add_one_file(Fd, Name) ->
    {ok, _} = file:copy(Name, Fd).

