public class Test extends BonneNote{
    private int nb,more_nb;
    public String mot;
    protected double pi;
    boolean isConnected;

    public int returnSum(int a,int b){
        return a+b;
    }

    public static void printSmtg(){
        System.out.println("Smtg"+nb+mot+pi);
    }

    public static void main(String params[]){
        int a,b;
        String def;

        for(a=0;a<=b;a++){
            a=a+b;
            System.out.println(b+"test");
        }

        if(a<b){
            System.out.println("Hello");
        }else if(b<a){
            System.out.println("Goodbye");
        }else{
            System.out.println("...");
        }
    }
}