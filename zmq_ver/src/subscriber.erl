-module(subscriber).
-export([start_link/2, init/2]).

start_link(Port, User_id) ->
	spawn_link(?MODULE, init, [Port, User_id]).

init(Port, User_id) ->
	application:ensure_started(chumak),
	{ok, Socket} = chumak:socket(sub),
	chumak:subscribe(Socket, <<"ALL">>),
	chumak:subscribe(Socket, User_id),
	case chumak:connect(Socket, tcp, "localhost", Port) of
		{ok, _BindPid} ->
			io:format("Binding OK with Pid: ~p\n", [Socket]);
		_ ->
			exit(connect_error)
	end,
	loop(Socket).

loop(Socket) ->
	{ok, Data} = chumak:recv(Socket),
	io:format("Message: ~p\n", [Data]),
	loop(Socket).
