:- use_module(library(apply)).
:- use_module(library(socket)).

:- initialization(marami, main).

:- [config].
:- [raw_server].
:- [gemini].
:- [handler].

marami :-
    port(Port),
    format(string(S), "Starting Marami on port ~w", Port),
    writeln(S),
    create_server(Port, handler).