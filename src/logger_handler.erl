-module(logger_handler).

-export([start/0]).

start() ->
    ok = logger:set_primary_config(level, notice),
    Config = #{config => #{file => "./info.log"}, level => info},
    ok = logger:add_handler(file_reader_handler,logger_std_h,Config).
