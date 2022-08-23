package datastructs;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.stream.Collectors;

import datastructs.IsiSymbol;
import datastructs.IsiVariable;

public class IsiSymbolTable {

    private HashMap<String, IsiSymbol> map;

    public IsiSymbolTable() {
        map = new HashMap<String, IsiSymbol>();
    }

    public void add(IsiSymbol symbol) {
        map.put(symbol.getName(), symbol);
    }

    public boolean exists(String symbolName) {
        return map.get(symbolName) != null;
    }

    public IsiSymbol get(String symbolName) {
        IsiSymbol symbol = map.get(symbolName);
        symbol.setUsed();
        return symbol;
    }

    public String getTypeByID(String id) {
        IsiVariable variable = (IsiVariable) this.get(id);
        if (variable.getType() == IsiVariable.TEXT) {
            return "TEXT";
        } else return "NUMBER";
    }

    public ArrayList<IsiSymbol> getAll() {
        ArrayList<IsiSymbol> lista = new ArrayList<IsiSymbol>();
        for (IsiSymbol symbol : map.values()) {
            lista.add(symbol);
        }
        return lista;
    }

    public List<IsiSymbol> getNonUsed() {
        ArrayList<IsiSymbol> allSymbols = this.getAll();
        List<IsiSymbol> nonUsed = allSymbols.stream().filter(s -> !s.used).collect(Collectors.toList());
        return nonUsed;
    }
}
