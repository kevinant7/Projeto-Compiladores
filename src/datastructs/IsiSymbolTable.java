package datastructs;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

public class IsiSymbolTable {
	
	private HashMap<String, datastructs.IsiSymbol> map;
	
	public IsiSymbolTable() {
		map = new HashMap<String, datastructs.IsiSymbol>();
		
	}
	
	public void add(datastructs.IsiSymbol symbol) {
		map.put(symbol.getName(), symbol);
	}
	
	public boolean exists(String symbolName) {
		return map.get(symbolName) != null;
	}

	public datastructs.IsiSymbol get(String symbolName) {
		datastructs.IsiSymbol s = map.get(symbolName);
		s.setUsed();
		return s;
	}

	public String getTypeByID(String id) {
		datastructs.IsiVariable variable = (datastructs.IsiVariable) this.get(id);
		if (variable.getType() == datastructs.IsiVariable.TEXT) {
			return "TEXT";
		} else return "NUMBER";
	}
	public ArrayList<datastructs.IsiSymbol> getAll(){
		ArrayList<datastructs.IsiSymbol> lista = new ArrayList<datastructs.IsiSymbol>();
		for (datastructs.IsiSymbol symbol : map.values()) {
			lista.add(symbol);
		}
		return lista;
	}

	public List<datastructs.IsiSymbol> getNonUsed() {
		ArrayList<datastructs.IsiSymbol> allSymbols = this.getAll();
		List<datastructs.IsiSymbol>      nonUsed	 = allSymbols.stream().filter(s -> !s.used).collect(Collectors.toList());
		return nonUsed;
	}
	
}
