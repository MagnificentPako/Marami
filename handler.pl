:- use_module(library(filesex)).
:- use_module(library(readutil)).
:- use_module('./marami/marami').
:- [config].

main_page([ pre("\t┏━╸┏━╸┏┳┓╻┏┓╻╻ ╻ ╻╺┳╸┏━╸\r\n\t┃╺┓┣╸ ┃┃┃┃┃┗┫┃ ┃╻┃ ┃ ┣╸\r\n\t┗━┛┗━╸╹ ╹╹╹ ╹╹╹┗┻┛ ╹ ╹ ")
          , blank
          , "This capsule serves two purposes: showing off what Marami can do and letting people host some small stuff on here tilde-style."
          , blank
          , heading("Useful Links")
          , link("https://github.com/MagnificentPako/Marami", "Marami")
          , link("https://github.com/MagnificentPako/gemini.wtf", "gemini.wtf Source")
          , link("gemini://localhost/~paul", "~paul")
          ]).

% Doesn't do much other than displaying the main page. Nothing to see here.
handler(Data) :-
    is_path(Data, /),
    status(success("text/gemini; lang=en")),
    main_page(Page),
    write_gemtext(Page).

handler(Data) :-
    is_path(Data, '/reload'),
    status(redirect("/")),
    make.

handler(Data) :-
    debug,
    \+ is_path(Data, /),
    base_path(BasePathRaw),
    member(url(Url), Data),
    member(path(Path), Url),
    string_concat("/", RelPathRaw, Path),
    split_string(RelPathRaw, "/", "", SplitPath),
    [Username|_] = SplitPath,
    string_concat(Username, RelPath, RelPathRaw),
    proper_base(BasePathRaw, Username, RelPath, Full),
    serve_file(Full).

% Redirect bad paths to /
handler(Data) :-
    status(redirect(/)).

serve_file(Path) :-
    exists_file(Path),
    !,
    send_file(Path).

serve_file(Path) :-
    exists_directory(Path),
    directory_file_path(Path, "index.gmi", FullPath),
    exists_file(FullPath),
    !,
    send_file(FullPath).

serve_file(Path) :-
    format(string(S), "Not found: ~w", Path),
    status(permanent_failure(1, S)).

send_file(Path) :-
    read_file_to_string(Path, S, [ encoding(utf8) ]),
    file_base_name(Path, FileName),
    file_mime_type(FileName, Mime),
    status(success(Mime)),
    writeln(S).

proper_base(Base, Username, "", Full) :-
    directory_file_path(Base, Username, BasePathU),
    directory_file_path(BasePathU, "public", Full).
proper_base(Base, Username, Rel, Full) :-
    string_concat("/", RelPath, Rel),
    directory_file_path(Base, Username, BasePathU),
    directory_file_path(BasePathU, "public", BasePath),
    directory_file_path(BasePath, RelPath, Full).