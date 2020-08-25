:- use_module(library(apply)).
:- use_module(library(ssl)).
:- use_module(library(socket)).
:- use_module(library(url)).

:- initialization(marami, main).

:- [config].
:- [util].
:- [raw_server].
:- [gemini].
:- [gemini_text].
:- [handler].

marami :-
    port(Port),
    cert_file(CertFile),
    key_file(KeyFile),
    format(string(S), "Starting Marami on port ~w", Port),
    writeln(S),
    create_server(Port, handler, CertFile, KeyFile).