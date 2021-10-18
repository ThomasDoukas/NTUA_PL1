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
      val n = readInt inStream
      val k = readInt inStream
      val _ = TextIO.inputLine inStream

      (* A function to read N integers from the open file. *)
      fun readInts 0 acc = rev acc (* Replace with 'rev acc' for proper order. *)
        | readInts i acc = readInts (i - 1) (readInt inStream :: acc)
    in
      (n, k, readInts k [])
end;

fun getCities (n, _, _) = n;
fun getVehicles (_, k, _) = k;
fun getList (_, _, l) = l;

fun sumNmax (li) =
  let
    fun max(x,y) = if x > y then x else y
    fun goodMax(nil) = 0
      | goodMax(x::nil) = x
      | goodMax(x::xs) = let val y = goodMax(xs) in max(x,y) end
    
    fun sumList ([], acc)  = acc
      | sumList ((x :: xs), acc) = sumList(xs, (x + acc))

    val max = goodMax(li)
    val sum = sumList(li, 0)
    val res = sum::max::[]
  in 
    res
  end

fun findDiff2 ([], target, _, res) = rev res
      | findDiff2 (l, target, cities, res) = 
      let
        val initHd = hd l
      in
        if (target >= initHd)
        then
          let
            val diff = target-initHd
            val newRes = diff::res
          in
            findDiff2(tl l, target, cities, newRes)
          end
        else 
          let
            val diff = cities - initHd + target
            val newRes = diff::res
          in 
            findDiff2(tl l, target, cities, newRes)
          end
      end

fun differences2 (l, target, cities, acc) = 
  if (target < cities)
  then
    let
      val initList = l
      val tar = target
      val listOfDiffs = findDiff2(l, target, cities, [])
      val sumAndMax = sumNmax(listOfDiffs)
      val newAcc = sumAndMax :: acc
    in
      differences2(initList, tar + 1, cities, newAcc)
    end
  else
   rev acc

  fun solve ([], min, _, resIndex) = (min, resIndex)
    | solve ((sum::max)::xs, min, index, resIndex) =
        if (((sum - hd max) >= ((hd max) - 1)) andalso (sum < min))
        then solve(xs, sum, index + 1, index)
        else solve(xs, min, index + 1, resIndex) 


  fun round inputFile = 
    let
      val input = parse inputFile;
      val cities = getCities input;
      val vehicles = getVehicles input;
      val list = getList input;
      val differences = differences2(list, 0, cities, []);
      val res = solve(differences, hd (hd differences), 0, 0);
      val resString = Int.toString(#1 res) ^ " " ^ Int.toString(#2 res) ^ "\n";
    in
      print resString
    end