%{
	#include<stdio.h>
	#include<stdlib.h>
%}


/*Header file*/
%token HEADER_FILE

/*Identifier*/
%token IDENTIFIER

/*Constants*/
%token HEX_CONSTANT DEC_CONSTANT

/*String*/
%token STRING

/*Data Types*/
%token INT LONG LONG_LONG SHORT SIGNED UNSIGNED

/*Keywords*/
%token FOR WHILE BREAK CONTINUE IF ELSE RETURN

 /* Short hand assignment operators */
%token PLUSEQ MINEQ MULEQ DIVEQ MODEQ INC DEC

/* Logical and Relational operators */
%token AND OR GREQ LSEQ EQ NOTEQ

/*start will specify the production for the parser to start with.*/
%start start

%left ','
%right '='
%left OR
%left AND
%left EQ NOTEQ
%left '<' '>' LSEQ GREQ
%left '+' '-'
%left '*' '/' '%'
%right '!'

%%

/* Program is made up of multiple builder blocks. */
start: start builder
			 |builder;

/* Each builder block is either a function or a declaration */
builder: function|
       declaration;
function: type IDENTIFIER '(' arguments ')' '{' statements '}'
	;

statements: statements stmt 
	;

arguments: arguments ',' arg
	;

argument_list :arguments
    |
    ;

arg: type IDENTIFIER
	;

stmt: '{' statements '}'|
       single_stmts
	;

single_stmt: if_block
	        |while_block
		|for_block
		|declaration
		|function_call ';'
		|break ';'
		|continue ';'
		|return sub_expr';'
	;
if_block: IF '(' expression ')' stmt
	  | IF '(' expression ')' stmt ELSE stmt
		;
while_block: WHILE '(' expression ')' stmt
		;

for_block: FOR '(' expression_stmt expression_stmt ')' stmt
	  | FOR '(' expresion_stmt expression_stmt expression')' stmt
	;

expression:expression ',' sub_expr						
    	|sub_expr		                                 
		;

expresion_stmt: expression ';'
	       | ';'
		;


declaration:type declaration_list ';'
			 |declaration_list ';'
			 | unary_expr ';'
		;

declaration_list: declaration_list ',' sub_decl
		|sub_decl
		;

sub_decl: assignment_expr
    	  |IDENTIFIER  
	;
			



%%
