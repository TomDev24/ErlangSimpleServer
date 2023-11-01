# Simple echo server in Erlang

It includes three versions:

1)Naive "straight on" approach, where we use "raw" Erlang tools like monitor, links etc  
2)Implementation with use of OTP behaviors.  
3)Using ZMQ socket instead of Erlang built in.

## How to build and run zmq_version

Rebar3 is required.

1) `cd zmq_ver`
2) `rebar3 shell`
3)
```
{ok, Pid} = server:start_link(Port).
```
4)Then you can issue commands
```
gen_server:cast(Pid, welcome).
```
5)Open another terminal and execute
```
subscriber:start_link(Port, Username).
```

## How to build and run other versions

0) `cd ` to one of the folders
1) Build `erl -make`
2) Start Erlang shell `erl -pa ebin/`
3) Start server
```erl
sup:start(Port)
```

## Client commands

Use `telnet localhost %PORT%` to connect to server or Erlang shell with commands
```erl
{ok, Socket} = gen_tcp:connect({127,0,0,1}, PORT, []).
gen_tcp:send(Socket, "Hey You").
```
