-module(worker).
-export([start/1, send_msg/2, init/1]).

start(ListenSocket) ->
	spawn_monitor(?MODULE, init, [ListenSocket]).

init(ListenSocket) ->
	self() ! enter_accept_state,
	loop({false, ListenSocket }).

send_msg(Socket, Msg) ->
	gen_tcp:send(Socket, Msg).

loop({AcceptSocket, ListenSocket}) ->
	if
	  AcceptSocket =/= false ->
		inet:setopts(AcceptSocket, [{active, once}]);
	  true -> none
	end,
	receive
		enter_accept_state ->
			try
				{ok, Accept} = gen_tcp:accept(ListenSocket),
				gen_tcp:send(Accept, "Welcome to paradise"),
				loop({Accept, ListenSocket})
			catch
				_ -> exit("cant accept Listen Socket")
			end;
		{tcp, Socket, <<"quit", _/binary>>} ->
			gen_tcp:close(Socket);
		{tcp, Socket, Msg} ->
			gen_tcp:send(Socket, Msg),
			loop({AcceptSocket, ListenSocket})
	after 10000 ->
		gen_tcp:close(AcceptSocket),
		exit(timeout)
	end.
