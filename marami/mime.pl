:- module(mime,[file_mime_type/2]).

mime(gmi, text/gemini).
mime(_, text/plain).

file_mime_type(FileName, MimeType) :-
    file_name_extension(_, Extension, FileName),
    mime(Extension, MimeType), 
    !.