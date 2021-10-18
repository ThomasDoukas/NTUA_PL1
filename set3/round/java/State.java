import java.util.ArrayList;

public class State {
    private int cars = 0;
    private int cities = 0;
    private ArrayList<Integer> carPosition = new ArrayList<>();

    public State() {}
    public State(int newCities, int newCars){
        cities = newCities;
        cars = newCars;
    }

    // Set initial state as read from file (car position and possible finalStates)
    public void initState(String listData){
        // Set initial ArrayList
        String[] temp = listData.split(" ");
        for(int i=0; i<cars; i++){
            carPosition.add(Integer.parseInt(temp[i]));
        }
    }

    public void calculateDistances(){
        int totalMoves = Integer.MAX_VALUE;
        int index = 0;
        for(int i=0; i<cities; i++){
            int sum = 0;
            int max = 0;
            int addVal = 0;
            for(int j=0; j<cars; j++){
                int start = carPosition.get(j);
                int to = i;
                if(to >= start){
                    addVal = to - start;
                    sum = sum + addVal;
                    if(max < addVal){
                        max = addVal;
                    }
                }
                else{
                    addVal = cities + to - start;
                    sum = sum + addVal;
                    if(max < addVal){
                        max = addVal;
                    }
                }
            }
            if(sum + 1 >= 2 * max && totalMoves>sum){
                totalMoves = sum;
                index = i;
            }
        }
        System.out.print(totalMoves);
        System.out.print(" ");
        System.out.println(index);
    }
}