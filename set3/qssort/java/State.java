import java.util.Collection;

public interface State {
    public boolean isFinal();
    public Collection<State> next();
    public State getPrevious();
    public void initState(String line);
    public String getMove();
}
