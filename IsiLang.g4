grammar IsiLang;

@header{
	import datastructs.IsiSymbol;
	import datastructs.IsiVariable;
	import datastructs.IsiSymbolTable;
	import exceptions.IsiSemanticException;
	import ast.IsiProgram;
	import ast.AbstractCommand;
	import ast.CommandLeitura;
	import ast.CommandEscrita;
	import ast.CommandAtribuicao;
	import ast.CommandDecisao;
	import ast.CommandRepeticao;
	import java.util.ArrayList;
	import java.util.Stack;
}

@members{
	private int _tipo;
	private String _varName;
	private String _varValue;
	private IsiSymbolTable symbolTable = new IsiSymbolTable();
	private IsiSymbol symbol;
	private IsiProgram program = new IsiProgram();
	private ArrayList<AbstractCommand> curThread;
	private Stack<ArrayList<AbstractCommand>> stack = new Stack<ArrayList<AbstractCommand>>();
	private String _readID;
	private String _writeID;
	private String _exprID;
	private String _exprContent;
	private String _exprDecision;
	private String _left;
    private String _right;
    private String _actionID;
    private String _declID;
	private ArrayList<AbstractCommand> lista;
	private ArrayList<AbstractCommand> listaTrue;
	private ArrayList<AbstractCommand> listaFalse;
	private ArrayList<String> exprTypeList = new ArrayList<String>();

	public void verificaID(String id){
		if (!symbolTable.exists(id)){
			throw new IsiSemanticException("Symbol "+id+" not declared");
		}
	}

	public void exibeComandos(){
		for (AbstractCommand c: program.getComandos()){
			System.out.println(c);
		}
	}

	public void generateCode(){
		program.generateTarget();
	}

	public String getTypeByID(String id) {
        		return symbolTable.getTypeByID(id);
        	}

        public void checkType(String left, String id, String expression){
        	for(String type : exprTypeList)  {
        		if(left != type) {
        			throw new IsiSemanticException("Incompatible types " + left + " and " + type + " in " + id + " = " + expression);
        		}
        	}
        }

        public String verifyAndGetType(String expression) {
            String type = exprTypeList.get(0);
            for (String tipo: exprTypeList) {
                if (tipo != type) {
                    throw new IsiSemanticException("Incompatible types in expression: " + expression);
                }
            }
            return type;
        }

        public ArrayList<String> warnings() {
            ArrayList<String> listWarnings = new ArrayList<String>();
            for(IsiSymbol symbol: symbolTable.getNonUsed()) {
                listWarnings.add("Variable <" + symbol.getName() + "> declared, but not used");
            }
            return listWarnings;
        }

        public void exibeWarnings(){
            ArrayList<String> warnings = warnings();
            if(warnings.size() > 0) {
                System.out.println("-".repeat(50) + " WARNINGS " + "-".repeat(50));
                for(String w : warnings) {
                    System.out.println("- " + w + ".");
                }
                System.out.println("-".repeat(110) + "\n");
            }
        }
}

prog	: 'programa' decl bloco  'fimprog;'
           {  program.setVarTable(symbolTable);
           	  program.setComandos(stack.pop());

           }
		;

decl    :  (declaravar)+
        ;


declaravar :  tipo ID  {
	                  _varName = _input.LT(-1).getText();
	                  _varValue = null;
	                  symbol = new IsiVariable(_varName, _tipo, _varValue);
	                  if (!symbolTable.exists(_varName)){
	                     symbolTable.add(symbol);
	                  }
	                  else{
	                  	 throw new IsiSemanticException("Symbol "+_varName+" already declared");
	                  }
                    }
              (  VIR
              	 ID {
	                  _varName = _input.LT(-1).getText();
	                  _varValue = null;
	                  symbol = new IsiVariable(_varName, _tipo, _varValue);
	                  if (!symbolTable.exists(_varName)){
	                     symbolTable.add(symbol);
	                  }
	                  else{
	                  	 throw new IsiSemanticException("Symbol "+_varName+" already declared");
	                  }
                    }
              )*
               SC
           ;

tipo       : 'numero' { _tipo = IsiVariable.NUMBER;  }
           | 'texto'  { _tipo = IsiVariable.TEXT;  }
           ;

bloco	: { curThread = new ArrayList<AbstractCommand>();
	        stack.push(curThread);
          }
          (cmd)+
		;


cmd		:  cmdleitura
 		|  cmdescrita
 		|  cmdattrib
 		|  cmdselecao
 		|  cmdrepeticao
		;

cmdleitura	: 'leia' AP
                     ID { verificaID(_input.LT(-1).getText());
                     	  _readID = _input.LT(-1).getText();
                        }
                     FP
                     SC

              {
              	IsiVariable var = (IsiVariable)symbolTable.get(_readID);
              	CommandLeitura cmd = new CommandLeitura(_readID, var);
              	stack.peek().add(cmd);
              }
			;

cmdescrita	: 'escreva'
                 AP
                 ID { verificaID(_input.LT(-1).getText());
	                  _writeID = _input.LT(-1).getText();
                     }
                 FP
                 SC
               {
               	  CommandEscrita cmd = new CommandEscrita(_writeID);
               	  stack.peek().add(cmd);
               }
			;

cmdattrib	:  ID { verificaID(_input.LT(-1).getText());
                    _exprID      = _input.LT(-1).getText();
                    _left	     = getTypeByID(_exprID);
                    exprTypeList = new ArrayList<String>();
                   }
               ATTR { _exprContent = ""; }
               expr
               SC
               {
               	 CommandAtribuicao cmd = new CommandAtribuicao(_exprID, _exprContent);
               	 checkType(_left, _exprID, _exprContent);
               	 stack.peek().add(cmd);
               }
			;


cmdselecao  :  'se' AP    { exprTypeList = new ArrayList<String>(); }
                    ID    { _exprDecision = _input.LT(-1).getText();
                            verificaID(_exprDecision);
                            _left = getTypeByID(_exprDecision);
                    }
                    OPREL { _exprDecision += _input.LT(-1).getText(); }
                    (ID | NUMBER) {_exprDecision += _input.LT(-1).getText(); }
                    FP
                    ACH
                    { curThread = new ArrayList<AbstractCommand>();
                      stack.push(curThread);
                    }
                    (cmd)+

                    FCH
                    {
                       listaTrue = stack.pop();
                    }
                   ('senao'

                   	 ACH
                   	 {
                   	 	curThread = new ArrayList<AbstractCommand>();
                   	 	stack.push(curThread);
                   	 }
                   	(cmd+)

                   	FCH
                   	{
                   		listaFalse = stack.pop();
                   		CommandDecisao cmd = new CommandDecisao(_exprDecision, listaTrue, listaFalse);
                   		stack.peek().add(cmd);
                   	}
                   )?
            ;

expr		:  termo (
	             OP  { _exprContent += _input.LT(-1).getText();}
	            termo
	            )*
			;

termo		: ID { verificaID(_input.LT(-1).getText());
	               _exprContent += _input.LT(-1).getText();
                 }
            |
              NUMBER
                {
                    _exprContent += _input.LT(-1).getText();
                    exprTypeList.add("NUMBER");
                }
              |
              TEXT
                {
                  _exprContent += _input.LT(-1).getText();
                  exprTypeList.add("TEXT");
                }
              ;


AP	: '('
	;

FP	: ')'
	;

SC	: ';'
	;

OP	: '+' | '-' | '*' | '/'
	;

ATTR : '='
	 ;

VIR  : ','
     ;

ACH  : '{'
     ;

FCH  : '}'
     ;


OPREL : '>' | '<' | '>=' | '<=' | '==' | '!='
      ;

ID	: [a-z] ([a-z] | [A-Z] | [0-9])*
	;

NUMBER	: [0-9]+ ('.' [0-9]+)?
		;

WS	: (' ' | '\t' | '\n' | '\r') -> skip;

TEXT  : '"' ([A-Z] | ' ' | [a-z])* '"'
      ;

cmdrepeticao :  'enquanto' AP
                ID    { _exprDecision = _input.LT(-1).getText(); }
                OPREL { _exprDecision += _input.LT(-1).getText(); }
                (ID | NUMBER) {_exprDecision += _input.LT(-1).getText(); }
                FP
                ACH
                { curThread = new ArrayList<AbstractCommand>();
                  stack.push(curThread);
                }
                (cmd)+

                FCH
                {
                	lista = stack.pop();
               		CommandRepeticao cmd = new CommandRepeticao(_exprDecision, lista);
               		stack.peek().add(cmd);
               	}
               	;