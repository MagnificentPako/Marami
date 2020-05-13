handler([path(["some", Str])|_]) :-
    status(success("text/plain")),
    writeln(Str).

handler([path(["test_failed_status"])|_]) :-
    status(impossible).

handler(Data) :-
    member(raw_path(Path), Data),
    format(string(S), "Not Found: ~w", Path),
    status(permanent_failure(1, S)).

handler(_) :-
    status(permanent_failure("Something went super wrong")).