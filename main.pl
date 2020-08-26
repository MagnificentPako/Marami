:- initialization(main, main).

:- use_module('./marami/marami').

:- [config].
:- [handler].

main :-
    port(Port),
    cert_file(CertFile),
    key_file(KeyFile),
    marami(handler, Port, CertFile, KeyFile).