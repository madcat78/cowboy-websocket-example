%%%-------------------------------------------------------------------
%% @doc ws public API
%% @end
%%%-------------------------------------------------------------------

-module(ws_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->
    case os:getenv("PORT") of
        false ->
            {_Status, Port} = application:get_env(ws, port);
        Other ->
            Port = Other
    end,        
    {_Status2, SInterval} = application:get_env(ws, stats_interval),

    Dispatch = cowboy_router:compile([
        {'_', [
            {"/", cowboy_static, {priv_file, ws, "index.html"}},
            {"/websocket", ws_handler, [{stats_interval, list_to_integer(SInterval)}]}
%            {"/[...]", cowboy_static, {priv_dir, ws, "", [{mimetypes, cow_mimetypes, all}]}}
        ]}
    ]),
    {ok, _} = cowboy:start_clear(http, [{port, list_to_integer(Port)}], #{
        env => #{dispatch => Dispatch}
    }),

    ws_sup:start_link().

%%--------------------------------------------------------------------
stop(_State) ->
    ok.

%%====================================================================
%% Internal functions
%%====================================================================
