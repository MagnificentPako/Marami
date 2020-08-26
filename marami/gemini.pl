:- module(gemini, [status/1]).

status(input(Num, Meta)) :-
    proper_secondary_status(Num),
    write_status(1, Num, Meta).
status(input(Meta)) :- status(input(0, Meta)).

status(success(Num, Meta)) :-
    proper_secondary_status(Num),
    write_status(2, Num, Meta).
status(success(Meta)) :- status(success(0, Meta)).

status(redirect(Num, Meta)) :-
    proper_secondary_status(Num),
    write_status(3, Num, Meta).
status(redirect(Meta)) :- status(redirect(0, Meta)).

status(temporary_failure(Num, Meta)) :-
    proper_secondary_status(Num),
    write_status(4, Num, Meta).
status(temporary_failure(Meta)) :- status(temporary_failure(0, Meta)).

status(permanent_failure(Num, Meta)) :-
    proper_secondary_status(Num),
    write_status(5, Num, Meta).
status(permanent_failure(Meta)) :- status(permanent_failure(0, Meta)).

status(cert_required(Num, Meta)) :-
    proper_secondary_status(Num),
    write_status(6, Num, Meta).
status(cert_required(Meta)) :- status(cert_required(0, Meta)).

status(Status) :- 
    format(string(S), "Internal server error wrong status: ~w", Status),
    write_status(5, 9, S).

proper_secondary_status(N) :-
    number(N),
    between(0, 9, N).

write_status(Status, Sec, Meta) :-
    format(string(S), "~w~w ~w\r\n", [Status, Sec, Meta]),
    write(S).