# Simple echo server in Erlang

It includes two version:
1)Naive "straight on" approach, where we use "raw" Erlang tools like monitor, links etc
2)Implementation with use of OTP behaviors.

## How to build and run server

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
