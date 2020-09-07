:- use_module(library(pprint)).
:- use_module('./marami/marami').

main_page([ heading("Marami Test Server")
          , heading("What is Marami", 2)
          , "Marami is a simple Gemini server written in SWI-Prolog."
          , blank
          , "It supports all the fun stuff, of course."
          , blank
          , heading("Examples", 2)
          , link("/dcg", "Page Generation using DCGs")
          , link("/gemini_text", "Generic text/gemini Showcase")
          , link("/pattern/matching", "URL Pattern Matching")
          , link("/input", "Input Status Codes")
          , link("/reload", "Reload ")
          ]).

% Doesn't do much other than displaying the main page. Nothing to see here.
handler(Data) :-
    is_path(Data, /),
    status(success("text/gemini; lang=en")),
    main_page(Page),
    write_gemtext(Page).

% Just some basic atom splitting right now; My intention is to make matching 
% agains the path segments possible soon. Here's what that might look like:
%
% member(segments(["foo", Bar, "baz"]), Data), string_length(Bar, 5).
% to match only paths like /foo/abcde/baz
handler(Data) :-
    member(url(Url), Data),
    member(path(Path), Url),
    atom_concat('/pattern', Pattern, Path),
    atom_length(Pattern, L),
    L > 0,
    format(string(S), "Matched '~w'", Pattern),
    status(success("text/plain")),
    writeln(S).

% Making use of (SWI) Prolog's make/0 to consult all source files that have been
% changed. Hot-reloading built right into the language!
handler(Data) :-
    is_path(Data, '/reload'),
    status(redirect(/)),
    make.

% Double the flex: Marami generates text/gemini from a DCG representation and 
% can also prettyprint the AST itself
handler(Data) :-
    is_path(Data, '/dcg'),
    status(success("text/gemini; lang=en")),
    main_page(Page),
    with_output_to(string(S), print_term(Page, [output(current_output)])),
    write_gemtext([ heading("DCG for the main page")
                 , pre(S, "prolog")
                 ]).

% Generic endpoint to showcase the formatting capabilities of text/gemini
handler(Data) :-
    is_path(Data, '/gemini_text'),
    status(success("text/gemini; lang=en")),
    write_gemtext([ heading("A Heading")
                 , heading("Followed by a sub-heading", 2)
                 , "And a paragraph"
                 , heading("Lists", 1)
                 , unordered_list(["List", "Elements", "Such", "Wow"])
                 , quote("A random quote")
                 ]).

% Test the input status code and display whatever the user supplied
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