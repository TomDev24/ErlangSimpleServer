-module(worker).
-compile(export_all).

start(ListenSocket) ->
	spawn_monitor(?MODULE, init, [ListenSocket]).

init(ListenSocket) ->
	self() ! enter_accept_state,
	loop(ListenSocket).

send_msg(Socket, Msg) ->
	gen_tcp:send(Socket, Msg)

loop(ListenSocket) ->
	receive
		enter_accept_state ->
			{ok, AcceptSocket} = gen_tcp:accept(ListenSocket),
			gen_tcp:send(AcceptSocket, "Welcome to paradise"),
			loop(ListenSocket);
		{tcp, Socket, <<"quit", _/binary>>} ->
			gen_tcp:close(Socket);
		{tcp, Socket, Msg} ->
			gen_tcp:send(Socket, Msg),
			loop(ListenSocket)
	end.
