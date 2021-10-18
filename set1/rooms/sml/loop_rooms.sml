fun parse file =
  let
    fun readInt input = Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)

    val inStream = TextIO.openIn file
    val (n, m) = (readInt inStream, readInt inStream)
    val _ = TextIO.inputLine inStream

    fun readLines acc = 
      case TextIO.inputLine inStream of
        NONE => rev acc
      | SOME line => readLines (explode (String.substring (line, 0, m)) :: acc)

    val inputList = readLines []:char list list
    val _ = TextIO.closeIn inStream
  in
    (n,m,inputList)
end;

fun getRows (i, _, _) = i;
fun getCols (_, j, _) = j;
fun getRooms (_, _, l) = l;

fun getFirst (a, _) = a;
fun getSecond (_, b) = b;

fun showMatrix arr =
  Array2.appi Array2.RowMajor
  (fn (_, col, c) =>
    print (str c ^ (if col + 1 = Array2.nCols arr then "\n" else "" ))
  )
    {base=arr,row=0,col=0,nrows=NONE,ncols=NONE}

fun calculate (queue, array, counter, rows, cols, true) = counter
  | calculate (queue, array, counter, rows, cols, false) =
  let
    val i = getFirst (Queue.head queue)
    val j = getSecond (Queue.head queue)
    
    val left =
      if (j <> 0 andalso Array2.sub(array, i, j-1) = #"R") then(
        Array2.update(array, i, j-1, #"X");
        Queue.enqueue(queue, (i, j-1));
        counter + 1
        )
      else counter
    
    val right =
      if (j <> cols-1 andalso Array2.sub(array, i, j+1) = #"L") then(
        Array2.update(array, i, j+1, #"X");
        Queue.enqueue(queue, (i, j+1));
        left + 1
        )
      else left

    val up =
      if (i <> 0 andalso Array2.sub(array, i-1, j) = #"D") then(
        Array2.update(array, i-1, j, #"X");
        Queue.enqueue(queue, (i-1, j));
        right + 1
        )
      else right
    
    val down =
      if (i <> rows-1 andalso Array2.sub(array, i+1, j) = #"U") then(
        Array2.update(array, i+1, j, #"X");
        Queue.enqueue(queue, (i+1, j));
        up + 1
        )
      else up
  in
    Queue.dequeue(queue);
    if(Queue.isEmpty(queue)) then
      calculate(queue, array, down, rows, cols, true)
    else
      calculate(queue, array, down, rows, cols, false)
  end

fun solve rows cols rooms =
  let
    val q = Queue.mkQueue()
    val counter = Array2.foldi Array2.RowMajor
    (fn (i, j, value, c) => 
      if (j = 0 andalso Array2.sub(rooms, i, j) = #"L") then(
        Array2.update(rooms, i, j, #"X");
        Queue.enqueue(q,(i,j));
        c + 1)
      else(
        if (j = cols-1 andalso Array2.sub(rooms, i, j) = #"R") then(
          Array2.update(rooms, i, j, #"X");
          Queue.enqueue(q,(i,j));
          c + 1)
        else(
          if (i = 0 andalso Array2.sub(rooms, i, j) = #"U") then(
            Array2.update(rooms, i, j, #"X");
            Queue.enqueue(q,(i,j));
            c + 1)
          else(
            if (i = rows-1 andalso Array2.sub(rooms, i, j) = #"D") then(
              Array2.update(rooms, i, j, #"X");
              Queue.enqueue(q,(i,j));
              c + 1)
            else
              c
          )
        )
      )
    ) 0 {base=rooms, row=0, col=0, nrows=NONE, ncols=NONE}
  in
    (* showMatrix rooms *)
    (* init *)
    (* counter *)
    calculate (q, rooms, counter, rows, cols, false)
  end


fun loop_rooms inputFile =
  let
    val input = parse inputFile;
    val rows = getRows input;
    val cols = getCols input;
    val rooms = Array2.fromList (getRooms input);
    val result = solve rows cols rooms  
  in
    print(Int.toString(rows * cols - result) ^ "\n")
end;