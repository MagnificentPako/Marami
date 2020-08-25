:- use_module(library(dcg/basics)).

paragraph(P) -->
    P.

heading(Heading) -->
    heading(Heading, 1).
heading(Heading, Level) -->
    { repeat("#", Level, Deep) }, 
    Deep,
    Heading.

link(Url, UserFriendly) -->
    "=> ",
    Url,
    " ",
    UserFriendly.
link(Url) -->
    "=> ",
    Url.

pre(Text, Alt) -->
    "```",
    Alt,
    "\r\n",
    Text,
    "\r\n```".
pre(Text) -->
    pre(Text, "").

quote(Text) -->
    ">",
    Text.

unordered_list([D|T]) -->
    "* ",
    D,
    "\r\n",
    unordered_list(T).
unordered_list([]) --> 
    [].

gemini_text([D|T]) -->
    D, !,
    "\r\n",
    gemini_text(T).
gemini_text([]) -->
    [].

write_gemini(G) :-
    phrase(gemini_text(G), X),
    string_codes(Y, X),
    write(Y).