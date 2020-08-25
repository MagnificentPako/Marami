dispatch(AcceptFd, Handler, SSL) :-
    tcp_accept(AcceptFd, Socket, Peer),
    thread_create(process_client(Socket, Peer, Handler, SSL), _, [ detached(true) ]),
    dispatch(AcceptFd, Handler, SSL).

process_client(Socket, _Peer, Handler, SSL) :-
    setup_call_cleanup( tcp_open_socket(Socket, StreamPair)
                      , handle_service(Handler, StreamPair, SSL)
                      , close(StreamPair)).

create_server(Port, Handler, CertFile, KeyFile) :-
    ssl_context(server, SSL, [ certificate_file(CertFile)
                             , key_file(KeyFile)
                             , close_parent(true)
                             ]),
    tcp_socket(Socket),
    tcp_bind(Socket, Port),
    tcp_listen(Socket, 5),
    tcp_open_socket(Socket, AcceptFd, _),
    dispatch(AcceptFd, Handler, SSL).

empty_string(S) :- S = "".

handle_service(Handler, StreamPair, SSL) :-
    stream_pair(StreamPair, InRaw, OutRaw),
    setup_call_cleanup( ssl_negotiate(SSL, InRaw, OutRaw, In, Out)
                      , handle_service_ssl(Handler, In, Out)
                      , close_both(In, Out)).

handle_service_ssl(Handler, In, Out) :-
    read_string(In, "\r\n", "", _, RawUrl),
    parse_url(RawUrl, Url),
    member(path(RawPath), Url),
    split_string(RawPath, "/", "", Path),
    Data = [path(Path), url(Url), raw(Req), raw_url(RawUrl)],
    with_output_to(Out, call(Handler, Data)).

close_both(In, Out) :-
    close(In), close(Out).