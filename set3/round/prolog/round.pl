% Read input predicate
read_input(File, Cities, Vehicles, Sorted) :-
    open(File, read, Stream),
    read_line(Stream, [Cities, Vehicles]),
    read_line(Stream, L),
    msort(L, Sorted).
    

% Predicate that reads a line and returns a list of integers.
read_line(Stream, List) :-
    read_line_to_codes(Stream, Line),
    atom_codes(A, Line),
    atomic_list_concat(As, ' ', A),
    maplist(atom_number, As, List).

listReformat([], Counter, Index, Cities, Acc, TownList) :-
    ( Index < Cities ->
        NewIndex is Index + 1,
        listReformat([], 0, NewIndex, Cities, [Counter|Acc], TownList);
        reverse(Acc, TownList)
    ).
listReformat(List, Counter, Index, Cities, Acc, TownList) :-
    [L_head|L_tail] = List,
    ( L_head =:= Index -> 
        NewCounter is Counter + 1,
        listReformat(L_tail, NewCounter, Index, Cities, Acc, TownList);
        NewIndex is Index + 1,
        listReformat(List, 0, NewIndex, Cities, [Counter|Acc], TownList) 
    ).

maxSum([], _, _, Max, Sum, TheMax, TheSum) :- 
    TheMax = Max,
    TheSum = Sum.
maxSum([L_head|L_tail], From, Cities, Max, Sum, TheMax, TheSum) :-
    ( From >= L_head ->
        (
            ((From - L_head) > Max ) ->
                NewSum is (Sum + From - L_head),
                NewMax is (From - L_head),
                maxSum(L_tail, From, Cities, NewMax, NewSum, TheMax, TheSum);
                NewSum is (Sum + From - L_head),
                maxSum(L_tail, From, Cities, Max, NewSum, TheMax, TheSum)
        )
    );
    (
        (
            (Cities - L_head + From > Max ) -> 
                Diff is (Cities - L_head + From),
                NewSum is (Sum + Diff),
                NewMax is Diff,
                maxSum(L_tail, From, Cities, NewMax, NewSum, TheMax, TheSum); 
                Diff is (Cities - L_head + From),
                NewSum is (Sum + Diff),
                maxSum(L_tail, From, Cities, Max, NewSum, TheMax, TheSum)
        )
    ).

onlyMax([], _, _, Max, TheMax) :- 
    TheMax = Max.
onlyMax([L_head|L_tail], From, Cities, Max, TheMax) :-
    ( From >= L_head ->
        (
            ((From - L_head) > Max ) ->
                NewMax is (From - L_head),
                onlyMax(L_tail, From, Cities, NewMax, TheMax);
                onlyMax(L_tail, From, Cities, Max, TheMax)
        )
    );
    (
        (
            (Cities - L_head + From > Max ) ->
                NewMax is Cities - L_head + From,
                onlyMax(L_tail, From, Cities, NewMax, TheMax);
                onlyMax(L_tail, From, Cities, Max, TheMax)
        )
    ).

solve(_, _, _, [], _, _, _, _, _, Min, _, Pos, TheMin, ThePos) :-
    TheMin = Min,
    ThePos = Pos.
solve([L_head|L_tail], TownList, [], MainPtr, Cities, Vehicles, MainIndex, _, Sum, Min, Index, Pos, TheMin, ThePos) :-
    solve([L_head|L_tail], TownList, TownList, MainPtr, Cities, Vehicles, MainIndex, 0, Sum, Min, Index, Pos, TheMin, ThePos).                           
solve([L_head|L_tail], TownList, [MaxHead|MaxTail], MainPtr, Cities, Vehicles, MainIndex, MaxIndex, Sum, Min, Index, Pos, TheMin, ThePos) :-
    (
        MainIndex =:= MaxIndex, MaxHead =:= 0 ->
            NewMaxIndex is MaxIndex + 1,
            solve([L_head|L_tail], TownList, MaxTail, MainPtr, Cities, Vehicles, MainIndex, NewMaxIndex, Sum, Min, Index, Pos, TheMin, ThePos)
        ;
            (   
                [MainHead|MainTail] = MainPtr,
                onlyMax([L_head|L_tail], Index, Cities, 0, TheMax),
                ( Index =:= 0 -> NewSum is Sum; NewSum is (Sum + Vehicles - Cities * MainHead)),
                Max is TheMax,
                (
                    (NewSum < Min, (NewSum - Max + 1 >= Max)) ->
                        NewMin is NewSum,
                        NewPos is Index,
                        NewIndex is Index + 1,
                        NewMainIndex is MainIndex + 1,
                        solve([L_head|L_tail], TownList, [MaxHead|MaxTail], MainTail, Cities, Vehicles, NewMainIndex, MaxIndex, NewSum, NewMin, NewIndex, NewPos, TheMin, ThePos)
                        ;
                        NewIndex is Index + 1,
                        NewMainIndex is MainIndex + 1,
                        solve([L_head|L_tail], TownList, [MaxHead|MaxTail], MainTail, Cities, Vehicles, NewMainIndex, MaxIndex, NewSum, Min, NewIndex, Pos, TheMin, ThePos)
                )
            )

    ).

round(File, M, C) :-
    read_input(File, Cities, Vehicles, Sorted),
    listReformat(Sorted, 0, 0, Cities, [], TownList),
    maxSum(Sorted, 0, Cities, 0, 0, TheMax, TheSum),
    solve(Sorted, TownList, TownList, TownList, Cities, Vehicles, 0, 0, TheSum, TheSum, 0, 0, M, C).
