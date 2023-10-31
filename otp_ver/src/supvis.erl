-module(supvis).
-behaviour(supervisor).
-export([start_link/1, init/1, create_worker/0]).

start_link(Port) ->
	supervisor:start_link({local, ?MODULE}, ?MODULE, [Port]).

init([Port]) ->
	{ok, ListenSocket} = gen_tcp:listen(Port, [binary, {active,once}]),
	spawn_link(fun create_workers_pool/0),
	{ok, {{simple_one_for_one, 60, 3600},
	      [{socket,
		{server, start_link, [ListenSocket]},
		temporary, 1000, worker, [server]}
	      ]}}.

create_worker() ->
	supervisor:start_child(?MODULE, []).

create_workers_pool() ->
	[create_worker() || _ <- lists:seq(1,5)].
