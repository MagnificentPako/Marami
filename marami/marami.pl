:- use_module(library(apply)).
:- use_module(library(ssl)).
:- use_module(library(socket)).
:- use_module(library(url)).

:- [util].
:- [raw_server].
:- [gemini].
:- [gemini_text].

marami(Handler, Port, CertFile, KeyFile) :-
    format(string(S), "Starting Marami on port ~w", Port),
    writeln(S),
    create_server(Port, Handler, CertFile, KeyFile).