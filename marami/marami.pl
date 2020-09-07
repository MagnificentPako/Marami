:- module(marami,[marami/4]).

:- use_module(library(apply)).
:- use_module(library(ssl)).
:- use_module(library(socket)).
:- use_module(library(url)).

:- use_module('./util').
:- use_module('./raw_server').
:- use_module('./gemini').
:- use_module('./gemtext').
:- use_module('./mime').
:- reexport([ util, raw_server, gemini, gemtext, mime ]).

%!	marami
%
%
marami(Handler, Port, CertFile, KeyFile) :-
    format(string(S), "Starting Marami on port ~w", Port),
    writeln(S),
    create_server(Port, Handler, CertFile, KeyFile).