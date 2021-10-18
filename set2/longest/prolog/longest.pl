% Code from 
% https://www.geeksforgeeks.org/longest-subarray-having-average-greater-than-or-equal-to-x-set-2/?fbclid=IwAR3SKX9FL1ndynMGB8noCe7fG_CXws0A7L-xBfa5G7i8hrClH42sMQoAb6Q
% will be used as a reference for this problem.

% Read input predicate
read_input(File, Days, Hosp, L) :-
    open(File, read, Stream),
    read_line(Stream, [Days, Hosp]),
    read_line(Stream, L).

% Predicate that reads a line and returns a list of integers.
read_line(Stream, List) :-
    read_line_to_codes(Stream, Line),
    atom_codes(A, Line),
    atomic_list_concat(As, ' ', A),
    maplist(atom_number, As, List).

% Predicate to check if list is empty
is_empty([]).

% Predicate to delete last element from list
del_last_el([_], []):- !.
del_last_el([X|Xs], [X|WithoutLast]) :- 
    del_last_el(Xs, WithoutLast).

% Subtract hospitals from each element list
% May need to remove prepare_list
prepare_list(List, Hosp, R) :-
    maplist(plus(Hosp), List, R).

% Predicate to create Prefix array.
calc_prefix(L, S) :- 
    runnner(L, S, 0).
runnner([], [], _).
runnner([A|B], [C|D], TOTAL) :- C is TOTAL + A, runnner(B, D, C).

% Calculate left max
calc_left_max([], _, L, Left_max) :-
    reverse(L, Left_max).
calc_left_max(List, Prev_index_val, L, Left_max) :-
    [L_head| L_tail] = List,
    Max is max(L_head, Prev_index_val),
    calc_left_max(L_tail, Max, [Max| L], Left_max).

% Calculate rigth min
calc_right_min([], _, R, Right_min) :-
    Right_min = R.
calc_right_min(List, Prev_index_val, R, Right_min) :-
    [L_head| L_tail] = List,
    Min is min(Prev_index_val, L_head),
    calc_right_min(L_tail, Min, [Min| R], Right_min).

% Predicate for while loop
% (+Left_max, +Right_min, +Days, +i, +j, +Max_difference, -Res)
loop([], [], _, _, _, _, Diff, R) :-
    R = Diff.
loop(Left, Right, Pf, Days, I, J, Diff, R) :-
    (  
        (I >= Days ; J >= Days) -> loop([], [], Pf, Days, I, J ,Diff, R);
       (
            [Pf_head| _] = Pf,
            [L_head| L_tail] = Left,
            [R_head| R_tail] = Right,
            (
                R_head =< L_head -> (
                    Index_diff is J - I,
                    New_diff is max(Index_diff, Diff),
                    (
                        (Pf_head =< Days, I =:= 0) -> 
                            (Inc_diff is New_diff + 1);
                            (Inc_diff is New_diff)
                    ),
                    New_j is J + 1,
                    loop(Left, R_tail, Pf, Days, I, New_j, Inc_diff, R)
                );
                (
                    New_i is I + 1,
                    loop(L_tail, Right, Pf, Days, New_i, J, Diff, R)
                )
            )
        ) 
    ).

% Predicate for general solution
solve(List, Days, Hosp, Result):-
    prepare_list(List, Hosp, New_list),
    calc_prefix(New_list, Prefix_list),
    [P_head| P_tail] = Prefix_list,
    calc_left_max(P_tail, P_head, [P_head], Left_max),
    reverse(Prefix_list, Pf_reverse),
    [Rp_head| Rp_tail] = Pf_reverse,
    calc_right_min(Rp_tail, Rp_head, [Rp_head], Right_min),
    loop(Left_max, Right_min, Prefix_list, Days, 0, 0, -1, Res),
    Result = Res.

% Predicate to check if full list satisfies condition
check_full_list(List, Days, Hosp, R) :-
    sumlist( List, Sum ),
    Val is (Sum * (-1) )/ (Days * Hosp),
    Val >= 1 -> (R = Days);
    solve(List, Days, Hosp, R), !.

% Begin solving
longest(File, Answer) :-
    read_input(File, M, N, L),
    check_full_list(L, M, N, Answer).
