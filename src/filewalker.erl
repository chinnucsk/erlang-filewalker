-module(filewalker).

-export([start_link/0]).

%% Supervisor callbacks
-export([init/0]).

-include_lib("kernel/include/file.hrl").

start_link() ->
    spawn(?MODULE, init, []).

init() ->
    State = [],
    walk("/"),
    {ok, State}.


walk(Dir) ->
    %% Initial
    walk([Dir], []).


walk([], []) ->
    %% Done
    {ok};

walk([Dir|DirsLeft], []) ->
    %% Process Next Directory
    case file:list_dir(Dir) of 
        {ok, NodeNames} ->
            {ok, Nodes} = append_dir_to_list_of_filenames(Dir, NodeNames),
            walk(DirsLeft, Nodes);
        {error, _Error} ->
            walk(DirsLeft, [])
    end;

walk(Dirs, [Node|NodesLeft]) ->
    %% Process Next File
    case node_type(Node) of
        regular ->
            io:fwrite("File ~s~n", [Node]),
            walk(Dirs, NodesLeft);
        directory ->
            io:fwrite("Dir  ~s~n", [Node]),
            walk(Dirs ++ [Node ++ "/"], NodesLeft);
        _ ->
            walk(Dirs, NodesLeft)
    end.


append_dir_to_list_of_filenames(Dir, Filenames) ->
    %% Initial
    append_dir_to_list_of_filenames(Dir, Filenames, []).


append_dir_to_list_of_filenames(_Dir, [], Files) ->
    %% Done
    {ok, Files};
   
append_dir_to_list_of_filenames(Dir, [H|T], Files) ->
    %% Recurse
    append_dir_to_list_of_filenames(Dir, T, Files ++ [Dir ++ H]).


node_type(Node) ->
    case file:read_file_info(Node) of
        {ok, NodeInfo} ->
            NodeInfo#file_info.type;
        {error, Error} ->
            Error
    end.
