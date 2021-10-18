// Goat.java as seen in PL1-Ntua's lectures will be used as a reference for this problem.
import java.io.*;

public class QSsort {
    public static void main(String[] args) {
        try {
            File input = new File(args[0]);
            BufferedReader br = new BufferedReader(new FileReader(input));
            int N = Integer.parseInt(br.readLine());
            String line = br.readLine();
            br.close();

            State initial = new QSstate();
            initial.initState(line);

            Solver solver = new ZBFSolver();
            State result = solver.solve(initial);

            if(result.getMove() == ""){
                System.out.println("empty");
            }
            else{
                printSolution(result);
                System.out.println();
            }
        }
        catch(FileNotFoundException e){
            System.out.println("Please provide an input file.");
        }
        catch(IOException e){
            System.out.println("IOException");
        }
    }

    private static void printSolution(State s){
        if(s.getPrevious() != null){
            printSolution(s.getPrevious());
        }
        System.out.print(s);
    }
    
}
