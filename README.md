# Simple echo server in Erlang

## How to build and run server

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
