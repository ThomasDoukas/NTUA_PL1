import java.io.*;

public class Round {
    public static void main(String[] args) {
        try {
            BufferedReader br = new BufferedReader(new FileReader(args[0]));
            String line = br.readLine();
            String[] temp = line.split(" ");
            int N = Integer.parseInt(temp[0]);
            int K = Integer.parseInt(temp[1]);
            line = br.readLine();
            br.close();

            State initial = new State(N, K);
            initial.initState(line);
            
            Solver solver = new Solver();
            solver.solve(initial);
            
        }
        catch(FileNotFoundException e){
            System.out.println("Please provide an input file.");
        }
        catch(IOException e){
            System.out.println("IOException");
        }
    }
}