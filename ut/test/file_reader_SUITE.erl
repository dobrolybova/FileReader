-module(file_reader_SUITE).

-export([all/0,
         init_per_suite/1,
         init_per_testcase/2,
         end_per_testcase/2,
         end_per_suite/1,
         read_file_200_ok_test/1,
         read_file_503_overloaded_nomem_test/1,
         read_file_503_overloaded_out_of_time_test/1
        ]).

-include_lib("common_test/include/ct.hrl").
-include_lib("eunit/include/eunit.hrl").

all() ->
    [
        read_file_200_ok_test,
        read_file_503_overloaded_nomem_test,
        read_file_503_overloaded_out_of_time_test
    ].

init_per_suite(Config) ->
    {ok, App_Start_List} = start([webserver]),
    inets:start(),
    [{app_start_list, App_Start_List}|Config].

init_per_testcase(_, Config) ->
    meck:new(file, [unstick, passthrough]),
    Config.

end_per_testcase(_, Config) ->
    Config.

end_per_suite(Config) ->
    inets:stop(),
    stop(?config(app_start_list, Config)),
    Config.

start(Apps) ->
    {ok, do_start(_To_start = Apps, _Started = [])}.

do_start([], Started) ->
    Started;
do_start([App|Apps], Started) ->
    case application:start(App) of
    ok ->
        do_start(Apps, [App|Started]);
    {error, {not_started, Dep}} ->
        do_start([Dep|[App|Apps]], Started)
    end.

stop(Apps) ->
    _ = [ application:stop(App) || App <- Apps ],
    ok.

read_file_200_ok_test(_Config) ->
    meck:expect(file, read_file, fun(_File) -> {ok, <<>>} end),
    {ok, {{_Version, 200, _ReasonPhrase}, _Headers, Body}} =
        httpc:request(get, {"http://localhost:8080/file/read", []}, [], []),
    Body = "The file was read successfully!\n".

read_file_503_overloaded_nomem_test(_Config) ->
    meck:expect(file, read_file, fun(_File) -> {error, enomem} end),
    {ok, {{_Version, 503, _ReasonPhrase}, _Headers, Body}} =
        httpc:request(get, {"http://localhost:8080/file/read", []}, [], []),
    Body = "Overloaded\n".

read_file_503_overloaded_out_of_time_test(_Config) ->
    meck:expect(file, read_file, fun(_File) -> timer:sleep(15) end),
    {ok, {{_Version, 503, _ReasonPhrase}, _Headers, Body}} =
        httpc:request(get, {"http://localhost:8080/file/read", []}, [], []),
    Body = "Overloaded\n".