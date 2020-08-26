:- module(gemtext, [ write_gemtext/1 ]).

blank -->
    "".

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

ul([D|T]) -->
    "* ",
    D,
    "\r\n",
    ul(T).
ul([]) --> 
    [].

gemtext([D|T]) -->
    D, !,
    "\r\n",
    gemtext(T).
gemtext([]) -->
    [].

write_gemtext(G) :-
    phrase(gemtext(G), X),
    string_codes(Y, X),
    write(Y).