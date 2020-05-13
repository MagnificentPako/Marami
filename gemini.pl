status(input(Num, Meta)) :-
    proper_secondary_status(Num),
    write_status(1, Num, Meta).
status(input(Meta)) :- status(input(0, Meta)).

status(success(Num, Meta)) :-
    proper_secondary_status(Num),
    write_status(2, Num, Meta).
status(success(Meta)) :- status(success(0, Meta)).

status(permanent_failure(Num, Meta)) :-
    proper_secondary_status(Num),
    write_status(5, Num, Meta).
status(permanent_failure(Meta)) :- status(permanent_failure(0, Meta)).

status(Status) :- 
    format(string(S), "Internal server error wrong status: ~w", Status),
    write_status(5, 9, S).

proper_secondary_status(N) :-
    number(N),
    between(0, 9, N).

write_status(Status, Sec, Meta) :-
    format(string(S), "~w~w ~w\r\n", [Status, Sec, Meta]),
    write(S).