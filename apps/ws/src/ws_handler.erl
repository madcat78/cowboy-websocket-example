-module(ws_handler).

-export([init/2]).
-export([websocket_init/1]).
-export([websocket_handle/2]).
-export([websocket_info/2]).
-export([terminate/3]).
-export([ws_send/2]).


init(Req, State) ->
    io:format("websocket connection initiated~n~p~n~nstate: ~p~n", [Req, State]),
    {cowboy_websocket, Req, State}.

websocket_init([{stats_interval, SInterval}]) ->
    ws_send(self(), SInterval),
    {ok, [{stats_interval, SInterval}]}.


websocket_handle(Data, State) ->
    io:format("websocket data from client: ~p~n", [Data]),
    {ok, State}.

websocket_info({timeout, _Ref, Msg}, [{stats_interval, SInterval}]) ->
    ws_send(self(), SInterval),
    {reply, {text, Msg}, [{stats_interval, SInterval}]};
websocket_info(_Info, State) ->
    {ok, State}.

ws_send(Pid, SInterval) ->
    Data = memsup:get_system_memory_data(),
    {cowboy, _CowboyD, CowboyV} = lists:keyfind(cowboy, 1, application:which_applications()),
    Data_jsonb = jiffy:encode({Data ++ [{otp_release, list_to_integer(erlang:system_info(otp_release))}] ++ [{cowboy_version, list_to_binary(CowboyV)}] ++ [{system_time, erlang:system_time()}] ++ [{pid, list_to_binary(pid_to_list(self()))}]}),
    erlang:start_timer(SInterval, Pid, Data_jsonb).


terminate(_Reason, Req, _State) ->
    io:format("websocket connection terminated~n~p~n", [maps:get(peer, Req)]),
    ok.
