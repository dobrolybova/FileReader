-module(file_reader_handler).

-behaviour(cowboy_handler).

-include_lib("kernel/include/logger.hrl").

-export([init/2]).

-define(TEST_FILE, "test_file.txt").

read_file()->
    TimeOut = 10,
    Self = self(),
    Pid = spawn(fun()-> 
                    {Res, Data} = file:read_file(?TEST_FILE),
                    Self ! {self(), {Res, Data}} end),
    logger:notice("Pid ~p", [Pid]),
    receive
        {_PidSpawned, {ok, _Data}} -> 
            {200, <<"The file was read successfully!\n">>};
        {_PidSpawned, {error, _Reason}} -> 
            {503, <<"Overloaded\n">>}
    after
        TimeOut -> 
            erlang:exit(Pid, kill),
            {503, <<"Overloaded\n">>}
    end.


init(Req0=#{path := <<"/file/read">>}, State) ->
    logger:notice("Try to read file"),
    {Status, Body} = read_file(),
    Req = cowboy_req:reply(Status,
        #{<<"content-type">> => <<"text/plain">>},
        Body,
        Req0),
    {ok, Req, State}.