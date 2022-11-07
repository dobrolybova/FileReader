-module(webserver_app).

-behaviour(application).

-include_lib("kernel/include/logger.hrl").

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
    ok = logger_handler:start(),
	Dispatch = cowboy_router:compile([
		{'_', [
            {"/file/read", file_reader_handler, []}
		]}
	]),
	{ok, _} = cowboy:start_clear(http_listener,
		[{port, 8080}],
		#{env => #{dispatch => Dispatch}}
	),
	webserver_sup:start_link().

stop(_State) ->
    ok.