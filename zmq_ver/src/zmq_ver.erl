-module(zmq_ver).

%% API exports
-export([main/1]).

%%====================================================================
%% API functions
%%====================================================================

%% escript Entry point
main(Args) ->
    io:format("Args: ~p~n", [Args]),
    {ok, Pid} = server:start_link(8123),
    %%io:format("Args: ~p~n", [Pid]),
    erlang:halt(0).

%%====================================================================
%% Internal functions
%%====================================================================
