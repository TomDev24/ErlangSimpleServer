-module(server).
-behaviour(gen_server).

-export([start_monitor/1, start_link/1, init/1, handle_cast/2, handle_info/2,
         terminate/2]).

start_link(ListenSocket) ->
	gen_server:start_link(?MODULE, [ListenSocket], []).

start_monitor(ListenSocket) ->
	gen_server:start_monitor(?MODULE, [ListenSocket], []).

init([ListenSocket]) ->
	gen_server:cast(self(), enter_accept_state),
       	{ok, {false, ListenSocket}}.

send(Socket, Msg) ->
	gen_tcp:send(Socket, Msg),
	inet:setopts(Socket, [{active, once}]).

handle_cast(enter_accept_state, S={_, ListenSocket}) ->
	try
		{ok, Accept} = gen_tcp:accept(ListenSocket),
		supvis:create_worker(),
		send(Accept, "Welcome to paradise"),
        	{noreply, {Accept, ListenSocket}}
	catch
		_ -> {stop, cant_accept_listen_socket, S}
	end.

handle_info({tcp, Socket, <<"quit", _/binary>>}, S) ->
	{stop, normal, S};
handle_info({tcp, Socket, Msg}, S) ->
	send(Socket, Msg),
        {noreply, S, 10000};
handle_info(Msg, S) ->
	io:format("unknown message: ~p~n",[Msg]),
	{noreply, S}.

terminate(normal, {AcceptSocket, _}) ->
	gen_tcp:close(AcceptSocket),
	ok;
terminate(cant_accept_listen_socket, _State) ->
	ok.

