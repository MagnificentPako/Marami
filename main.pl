:- initialization(main, main).

:- [marami/marami].
:- [handler].
:- [config].

main :-
    port(Port),
    cert_file(CertFile),
    key_file(KeyFile),
    marami(handler, Port, CertFile, KeyFile).