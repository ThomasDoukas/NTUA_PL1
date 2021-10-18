import java.util.*;

public class ZBFSolver implements Solver{
    public State solve(State initial){
        Queue<State> remaining = new ArrayDeque<>();
        Set<State> seen = new HashSet<>();

        remaining.add(initial);
        seen.add(initial);

        while(!remaining.isEmpty()){
            State s = remaining.remove();
            if(s.isFinal()){
                return s;
            }
            for(State n: s.next()) {
                if(!seen.contains(n)){
                    remaining.add(n);
                    seen.add(n);
                }
            }
        }
        System.out.print("Should never be here!");
        return null;
    }
}
