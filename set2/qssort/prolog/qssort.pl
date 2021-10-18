% Goat.pl as seen in Adam Brooks Webber's Book "Modern Programming Languages"
% and PL1-Ntua's lectures will be used as a reference for this problem.

% Read input predicate
read_input(File, N, Q) :-
    open(File, read, Stream),
    read_line(Stream, N),
    read_line(Stream, Q).

% Predicate that reads a line and returns a list of integers.
read_line(Stream, List) :-
    read_line_to_codes(Stream, Line),
    atom_codes(A, Line),
    atomic_list_concat(As, ' ', A),
    maplist(atom_number, As, List).

% Predicate to prin all elements of list
printlist([]).
printlist([X|List]) :-
    write(X),
    write(' '),
    printlist(List).

% Predicate to check if list is sorted
is_sorted([]) :- !.
is_sorted([_]) :- !.
is_sorted([Head|[Head1|Tail]]) :-
    Head =< Head1,
    is_sorted([Head1|Tail]).

% Predicate to check id list is empty
is_empty([]).

% Q move = remove first element of queue and add it to stach head.
move((Queue, Stack), 'Q', New_state) :-
    \+ is_empty(Queue),
    [Q_head| Q_tail] = Queue,
    append([[Q_head], Stack], New_stack),
    New_state = (Q_tail, New_stack).

% S move = remove element from stack head and add to queue as last element
move((Queue, Stack), 'S', New_state) :-
    \+ is_empty(Stack),
    [S_head| S_tail] = Stack,
    append([Queue, [S_head]], New_queue),
    New_state = (New_queue, S_tail).

final((Queue, Stack)) :-
    is_empty(Stack),
    is_sorted(Queue).

solution(State, []) :- final(State).
solution(State, [Move| RestMoves]) :-
    move(State, Move, Next_state),
    solution(Next_state, RestMoves).

format_res(A, Result) :-
    is_empty(A) -> Result = 'empty';
    atomic_list_concat(A, Result).

qssort(File, Answer) :-
    read_input(File, _, Q),
    length(Res, _),
    solution((Q, []), Res),
    format_res(Res, Answer),
    !. 
