:- module(util, [ is_path/2
                , repeat/3
                ]).

%!	write_lines
%
%
write_lines(Lines) :-
    atomic_list_concat(Lines, "\r\n", S),
    writeln(S).

%!	repeat
%
%
repeat(Str,1,Str).
repeat(Str,Num,Res):-
    Num1 is Num-1,
    repeat(Str,Num1,Res1),
    string_concat(Str, Res1, Res).

%!	is_path
%
%
is_path(Data, Path) :-
    member(url(Url), Data),
    member(path(Path), Url). 