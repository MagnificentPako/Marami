:- use_module(library(pprint)).

main_page([ heading("Marami Test Server")
          , heading("What is Marami", 2)
          , paragraph("Marami is a simple Gemini server written in SWI-Prolog.")
          , paragraph("It supports all the fun stuff, of course.")
          , heading("Examples", 2)
          , link("/dcg", "Page Generation using DCGs")
          , link("/gemini_text", "Generic text/gemini Showcase")
          , link("/pattern/matching", "URL Pattern Matching")
          , link("/input", "Input Status Codes")
          ]).

handler(Data) :-
    is_path(Data, /),
    status(success("text/gemini; lang=en")),
    main_page(Page),
    write_gemini(Page).

handler(Data) :-
    member(url(Url), Data),
    member(path(Path), Url),
    atom_concat('/pattern', Pattern, Path),
    atom_length(Pattern, L),
    L > 0,
    format(string(S), "Matched '~w'", Pattern),
    status(success("text/plain")),
    writeln(S).

handler(Data) :-
    is_path(Data, '/reload'),
    status(redirect(/)),
    make.

handler(Data) :-
    is_path(Data, '/dcg'),
    status(success("text/gemini; lang=en")),
    main_page(Page),
    with_output_to(string(S), print_term(Page, [output(current_output)])),
    write_gemini([ heading("DCG for the main page")
                 , pre(S, "prolog")
                 ]).

handler(Data) :-
    is_path(Data, '/gemini_text'),
    status(success("text/gemini; lang=en")),
    write_gemini([ heading("A Heading")
                 , heading("Followed by a sub-heading", 1)
                 , paragraph("And a paragraph")
                 , heading("Lists", 1)
                 , unordered_list(["List", "Elements", "Such", "Wow"])
                 , quote("A random quote")
                 ]).

handler(Data) :-
    is_path(Data, '/input'),
    member(url(Url), Data),
    \+ member(search(_), Url),
    status(input(1, "Testing sensible input")).

handler(Data) :-
    is_path(Data, '/input'),
    member(url(Url), Data),
    member(search(Search), Url),
    status(success("text/plain")),
    format(string(S), "The input was '~w'", Search),
    writeln(S).

% Redirect bad paths to /
handler(_) :-
    status(redirect(/)).