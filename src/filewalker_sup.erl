
-module(filewalker_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

filewalker_child_defn() ->
    Name = filewalker,
    Module = filewalker,
    Function = start_link,
    Args = [],
    Restart = permanent,
    Shutdown = 5000,
    Type = worker,
    Modules = [Module],
    %% Return
    {Name, {Module, Function, Args}, Restart, Shutdown, Type, Modules}.

init([]) ->
    Children = [
        filewalker_child_defn()
    ],
    Ok = ok,
    RestartStrategy = one_for_one,
    MaxRestart = 5,
    MaxTime = 10,
    %% Return
    {
        Ok,
        {
            {RestartStrategy, MaxRestart, MaxTime},
            Children
        }
    }.
