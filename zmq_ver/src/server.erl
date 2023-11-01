-module(server).
-behaviour(gen_server).

-export([start_link/1, init/1, handle_cast/2, terminate/2]).

start_link(Port) ->
	gen_server:start_link(?MODULE, [Port], []).

init([Port]) ->
	application:ensure_started(chumak),
	{ok, Socket} = chumak:socket(pub),
	case chumak:bind(Socket, tcp, "localhost", Port) of
		{ok, _BindPid} ->
			io:format("Binding OK with Pid: ~p\n", [Socket]);
		_ ->
			exit(bind_error)
	end,
       	{ok, Socket}.

handle_cast(welcome, Socket) ->
	ok = chumak:send(Socket, <<"ALL", ":Welcome to the server!">>),
        {noreply, Socket};
handle_cast({User, Msg}, Socket) ->
	ok = chumak:send(Socket, [User, " ", Msg]),
        {noreply, Socket}.

terminate(normal, _Socket) ->
	ok.
