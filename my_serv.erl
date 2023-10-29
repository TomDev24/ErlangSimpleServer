-module(my_serv).
-compile(export_all).
-record(state, {listen_socket,
		accept_socket
	 }).

start() ->
	spawn(?MODULE, init, []).

start_link() ->
	spawn_link(?MODULE, init, []).

init() ->
	{ok, Listen} = gen_tcp:listen(8123, [{active,true}]),
	self() ! enter_accept_state,
	loop(#state{listen_socket = Listen}).

handshake(S) ->
	gen_tcp:accept(S#state.listen_socket).

loop(S) ->
	receive
		enter_accept_state ->
			{ok, Socket} = handshake(S),
			gen_tcp:send(Socket, "Welcome to paradise"),
			loop(S#state{accept_socket=Socket})
	end.
