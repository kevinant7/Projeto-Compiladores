package ast;

import java.util.ArrayList;

public class CommandRepeticao extends AbstractCommand {
 
	private String condition;
	private ArrayList<AbstractCommand> lista;
	
	public CommandRepeticao(String condition, ArrayList<AbstractCommand> l){
		this.condition = condition;
		this.lista = l;
	}
	@Override
	public String generateJavaCode() {
		// TODO Auto-generated method stub
		StringBuilder str = new StringBuilder();
		str.append("while ("+condition+") {\n");
		for (AbstractCommand cmd: lista) {
			str.append(cmd.generateJavaCode());
		}
		str.append("}");
		return str.toString();
	}
	@Override
	public String toString() {
		return "CommandRepeticao [condition=" + condition + ", lista=" + lista + "]";
	}
}
