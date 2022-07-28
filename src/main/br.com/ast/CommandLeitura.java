package ast;

import datastructs.IsiVariable;

public class CommandLeitura extends AbstractCommand {
    private final String id;
    private final IsiVariable var;

    public CommandLeitura(String id, IsiVariable var) {
        this.id = id;
        this.var = var;
    }

    @Override
    public String generateJavaCode() {
        // TODO Auto-generated method stub
        return id + "= _key." + (var.getType() == IsiVariable.NUMBER ? "nextDouble();" : "nextLine();");
    }

    @Override
    public String toString() {
        return "CommandLeitura [id=" + id + "]";
    }

    @Override
    public String getId() {
        return "";
    }

    @Override
    public String getCommand() {
        return this.getClass().getName();
    }
}
