-module(filewalker).

-export([start_link/0]).

%% Supervisor callbacks
-export([init/0]).

start_link() ->
    spawn(?MODULE, init, []).

init() ->
    State = [],
    io:fwrite("hello, world\n"),
    {ok, State}.
