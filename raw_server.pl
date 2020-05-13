dispatch(AcceptFd, Handler) :-
    tcp_accept(AcceptFd, Socket, Peer),
    thread_create(process_client(Socket, Peer, Handler), _, [ detached(true) ]),
    dispatch(AcceptFd, Handler).

process_client(Socket, _Peer, Handler) :-
    setup_call_cleanup( tcp_open_socket(Socket, StreamPair)
                      , handle_service(Handler, StreamPair)
                      , close(StreamPair)).

create_server(Port, Handler) :-
    tcp_socket(Socket),
    tcp_bind(Socket, Port),
    tcp_listen(Socket, 5),
    tcp_open_socket(Socket, AcceptFd, _),
    dispatch(AcceptFd, Handler).

empty_string(S) :- S = "".

handle_service(Handler, StreamPair) :-
    stream_pair(StreamPair, In, Out),
    read_string(In, "\r\n", "", _, Req),
    split_string(Req, "?", "", [RawPath|_]),
    split_string(RawPath, "/", "", PathS),
    exclude(empty_string, PathS, Path),
    Data = [path(Path), raw(Req), raw_path(RawPath)],
    with_output_to(Out, call(Handler, Data)).
    