(* 
  Parse funcion based on countries.sml 
  as given by https://courses.softlab.ntua.gr/pl1/2021a/
*)
fun parse file =
    let
      (* A function to read an integer from specified input. *)
      fun readInt input =
      Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)

      (* Open input file. *)
      val inStream = TextIO.openIn file

      (* Read N,K and consume newline. *)
      val m = readInt inStream
      val n = readInt inStream
      val _ = TextIO.inputLine inStream

      (* A function to read N integers from the open file. *)
      fun readInts 0 acc = rev acc (* Replace with 'rev acc' for proper order. *)
        | readInts i acc = readInts (i - 1) (readInt inStream :: acc)
    in
      (m, n, readInts m [])
end;

fun getDays (m, _, _) = m;
fun getHospitals (_, n, _) = n;
fun getList (_, _, l) = l;

fun getFirst (a, _) = a;
fun getSecond (_, b) = b;

fun compare ((x1,y1), (x2,y2)) =
  let
    val firstComp = Int.compare (x1,x2)
    val secondComp = Int.compare (y1,y2)
  in
    if (firstComp = EQUAL)
    then secondComp
    else firstComp
  end;

fun prepareInput d h l = 
  let
    fun updateList l n = map (fn x => x*(~1) - n) l
    (* may need to remove rev *)
    fun createPreSum ([], index, sum) = []
      | createPreSum (li, index, sum) =
        if index=0 then
         (hd li, index) :: createPreSum (tl li, index+1, hd li)
        else
          (sum + hd li, index) :: createPreSum (tl li, index+1, sum + hd li)
    val newList = updateList l h;
    val preSum = Array.fromList(createPreSum (newList, 0, 0))
    val sorting = ArrayQSort.sort compare preSum
  in 
    preSum
end;

fun solve days hosp l = 
  let
    val preSum = prepareInput days hosp l;
    val firstInd = getSecond (Array.sub(preSum, 0));
    val minInd = Array.array (days, firstInd);
    val modifyMinInd = Array.modifyi 
    (fn (index, value) => 
      if index = 0 then getSecond (Array.sub(preSum, index))
      else
        if Array.sub(minInd, index-1) < getSecond (Array.sub(preSum, index))
        then Array.sub(minInd, index-1)
        else getSecond (Array.sub(preSum, index))
    ) minInd
    fun updateList l n = map (fn x => x*(~1) - n) l
    val arr = updateList l hosp

    fun findInd (true, ps, left, right, mid, ans, value) =  ans
      | findInd (false, ps, left, right, mid, ans, value) =
      if left <= right then 
        let
          val newMid = (left + right ) div 2;
          val psValue = getFirst (Array.sub(ps, newMid))
        in
          if( psValue <= value) then
            findInd (false, ps, newMid+1, right, newMid, newMid, value)
          else
            findInd (false, ps, left, newMid-1, newMid, ans, value)
        end
      else
        findInd(true, ps, left, right, mid, ans, value)

    fun calculate ([], index, sum , maxLen, mi) = maxLen 
      | calculate (li, index, sum, maxLen, mi) = 
      let
        val newSum = sum + hd li
      in
        if newSum >= 0 then
          let
            val newMaxLen = index + 1
          in
            calculate (tl li, index+1, newSum, newMaxLen, mi)
          end
        else
          let
            fun max a b = if a > b then a else b
            val ind = findInd (false, preSum, 0, days-1, 0, ~1, newSum)
            val minimumInd = Array.sub(mi, ind)
            val temp = maxLen
          in
            if (ind <> ~1 andalso minimumInd < index) then
              let
                val newMaxLen = max maxLen (index - minimumInd)
              in
                calculate (tl li, index+1, newSum, newMaxLen, mi)
              end  
            else
              calculate (tl li, index+1, newSum, temp, mi)
          end
      end

    val result = calculate (arr, 0, 0, 0, minInd)
  in
    result
end;

fun longest inputFile =
  let
    val input = parse inputFile;
    val days = getDays input;
    val hospitals = getHospitals input;
    val list = getList input;
    fun checkFullList li = 
      let
        val sum = foldl (fn (value, acc) => acc + value) 0 li
      in 
        if (sum*(~1) div (days * hospitals) >= 1) then true
        else false
      end
  in
    if checkFullList list then print(Int.toString(List.length list) ^ "\n")
    else print(Int.toString(solve days hospitals list) ^ "\n")
end;
