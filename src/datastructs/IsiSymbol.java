package datastructs;

public abstract class IsiSymbol {
    protected String name;
    protected boolean used;

    public abstract String generateJavaCode();

    public IsiSymbol(String name) {
        this.name = name;
        this.used = false;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @Override
    public String toString() {
        return "IsiSymbol [name=" + name + "]";
    }

    public void setUsed() {
        this.used = true;
    }
}
