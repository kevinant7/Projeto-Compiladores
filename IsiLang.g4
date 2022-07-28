grammar IsiLang;

prog	: 'programa' decl bloco  'fimprog;'
  		;

decl    :  (declaravar)+
        ;
declaravar :  tipo ID;

tipo       : 'numero'

           | 'texto'
           ;

cmd		:  cmdleitura
 		|  cmdescrita
 		|  cmdattrib
 		|  cmdselecao
		;

cmdleitura	: 'leia' AP
                     ID
                     FP
                     SC


			;

cmdescrita	: 'escreva'
                 AP
                 ID
                 FP
                 SC

			;

bloco	:
          (cmd)+
		;

cmdattrib	:  ID
               ATTR
               SC

			;


cmdselecao  :  'se' AP
                    ID
                    FP
                    ACH


                    FCH
                   	ACH


                   	FCH

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