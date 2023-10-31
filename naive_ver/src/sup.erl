-module(sup).
-export([start/1, start_link/1, init/1]).

-record(state, {listen_socket,
		workers
	 }).

start(Port) ->
	spawn(?MODULE, init, [Port]).

start_link(Port) ->
	spawn_link(?MODULE, init, [Port]).

init(Port) ->
	{ok, ListenSocket} = gen_tcp:listen(Port, [binary, {active,false}]),
	Workers = orddict:new(),
	WorkersList = [worker:start(ListenSocket) || _ <- lists:seq(1,5)],
	[orddict:store(Ref, Pid, Workers) || {Pid, Ref} <- WorkersList],
	loop(#state{listen_socket=ListenSocket, workers=Workers}).

loop(S) ->
	receive
        	{'DOWN', Ref, process, _Pid, _Reason} ->
			Workers = orddict:erase(Ref, S#state.workers),
            		erlang:demonitor(Ref, [flush]),
			self() ! create_worker,
			loop(S#state{workers=Workers});
		create_worker ->
			{Pid, Ref} = worker:start(S#state.listen_socket),
			Workers = orddict:store(Ref, Pid, S#state.workers),
			loop(S#state{workers=Workers});
		_ ->
			loop(S)
	end.
