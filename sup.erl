-module(sup).
-compile(export_all).

-record(state, {listen_socket,
		workers
	 }).

start(Port) ->
	spawn(?MODULE, init, [Port]).

start_link(Port) ->
	spawn_link(?MODULE, init, [Port]).


init(Port) ->
	{ok, ListenSocket} = gen_tcp:listen(Port, [binary, {active,true}]),
	Workers = orddict:new(),
	WorkersList = [worker:start(ListenSocket) || _ <- lists:seq(1,2)],
	[orddict:store(Ref, Pid, Workers) || {Pid, Ref} <- WorkersList],
	loop(#state{listen_socket=ListenSocket, workers=Workers}).

loop(S) ->
	receive
        	{'DOWN', Ref, process, Pid, _Reason} ->
			io:format("worker went down ~n"),
			%Workers1 = orddict:erase(Ref, S#state.workers),
            		erlang:demonitor(Ref, [flush]),
			{Npid, Nref} = worker:start(S#state.listen_socket),
			Workers = orddict:store(Nref, Npid, S#state.workers),
			loop(S#state{workers=Workers});
		_ ->
			loop(S)
	end.
