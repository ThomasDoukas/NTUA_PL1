import java.util.*;

public class QSstate implements State{
    private ArrayList<Integer> Q = new ArrayList<>();
    private ArrayList<Integer> S = new ArrayList<>();
    private String move = "";
    private State previous = null;

    public QSstate() {}
    public QSstate(ArrayList<Integer> newQ, ArrayList<Integer> newS, String newMove, State newPrev){
        Q = newQ;
        S = newS;
        move = newMove;
        previous = newPrev;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder(move);
        return sb.toString();
    }
    
    // Two states are equal if all four are on the same shore.
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        QSstate other = (QSstate) o;
        return Q.equals(other.Q) && S.equals(other.S) && move == other.move;
    }

    // Hashing: consider only the positions of the four players.
    @Override
    public int hashCode() {
        List<ArrayList<Integer>> hashList = new ArrayList<ArrayList<Integer>>();
        hashList.add(Q);
        hashList.add(S);
        return Objects.hash(hashList);
    }

    // Initialize queue with string read from file
    public void initState(String queueData){
        StringTokenizer st = new StringTokenizer(queueData, " ");
        while (st.hasMoreTokens()) {
            String temp = st.nextToken();
            int n = Integer.parseInt(temp);
            Q.add(n);
        }
    }

    // Check if state is final (ordered queue, empty stack)
    public boolean isFinal() {
        if(!S.isEmpty())
            return false;
        
        for(int i=0; i<Q.size()-1; i++){
            if(Q.get(i) > Q.get(i+1))
                return false;
        }
        return true;
    }

    // Next move: Q move first for alphabetical order
    public Collection<State> next() {
        Collection<State> states = new ArrayList<>();
        
        // Q move: remove first element from queue and add it to stack head
        if(!Q.isEmpty()){
            ArrayList<Integer> tempQueue = new ArrayList<>(Q);
            ArrayList<Integer> tempStack = new ArrayList<>(S);
            int value = tempQueue.remove(0);
            tempStack.add(0, value);
            states.add(new QSstate(tempQueue, tempStack, "Q", this));
        }

        // S move: remove element from stack head and add to queue as last element
        if(!S.isEmpty()){
            ArrayList<Integer> tempQueue = new ArrayList<>(Q);
            ArrayList<Integer> tempStack = new ArrayList<>(S);
            int value = tempStack.remove(0);
            tempQueue.add(value);
            states.add(new QSstate(tempQueue, tempStack, "S", this));
        }

        return states;
    }

    public State getPrevious() {
        return this.previous;
    }

    public String getMove() {
        return move;
    }
}
