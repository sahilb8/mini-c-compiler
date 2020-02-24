%{
	#include<stdio.h>
	#include<stdlib.h>
	#include "y.tab.h"
	int cmnt=0;
%}
identifier [_a-zA-Z][a-zA-Z0-9]+
ws [ \t\r\f\v]+
	/*\r is CR,\v is Vertical tab,*/
hex [0-9a-fA-F]
letter [a-zA-Z]
digit [0-9]

/*Exclusive State*/
%x CMNT
%x PREPROC

%%

	/*Comments*/
"/*" 		{cmnt=yylineno; BEGIN CMNT;}
<CMNT>.|{ws}	{;}
<CMNT>\n 	{yylineno++;}
<CMNT>"*/"	{BEGIN INTITAL;}
<CMNT>"/*"                        {printf("Line %3d: Nested comments are not valid!\n",yylineno);}
<CMNT><<EOF>>                     {printf("Line %3d: Unterminated comment\n", cmnt_strt); yyterminate();}


	/*HEADER_FILES*/
^"#include"                       {BEGIN PREPROC;}
<PREPROC>"<"[^<>\n]+">"            {return HEADER_FILE;}
<PREPROC>{ws}                     {;}
<PREPROC>\"[^"\n]+\"              {return HEADER_FILE;}
<PREPROC>\n                       {yylineno++; BEGIN INITIAL;}
<PREPROC>.                        {printf("Line %3d: Illegal header file format \n",yylineno);}
"//".*                            {;}

	/*If the quoted string ends with a backslash before the closing quotation
	mark, it uses yyless() to push back the closing quote, and yyrnore () (q.v.)
	to tell lex to append the next token to this one. The next token will be the
	rest of the quoted string starting with the pushed back quote, so the entire
	string will end up in yytext.*/

\"[^\"\n]*\"     {

  if(yytext[yyleng-2]=='\\') /* check if it was an escaped quote */
  {
    yyless(yyleng-1);       /* push the quote back if it was escaped */
    yymore();
  }
  else{
  return STRING;
  }
 }



	/*Keywords*/
"int"		{return INT;}
"long"		{return LONG;}
"long long"	{return LONG_LONG;}
"short"		{return SHORT;}
"signed"	{return SIGNED;}
"unsigned"	{return UNSIGNED;}
"for"		{return FOR;}
"while"		{return WHILE;}
"break"		{return BREAK;}
"continue"	{return CONTINUE;}
"if"		{return IF;}
"else"		{return ELSE;}
"return"	{return RETURN;}

{ws}    	{;}
{identifier}    {return IDENTIFIER;}

[+\-]?[0][x|X]{hex}+[lLuU]?        {return  HEX_CONSTANT;}
[+\-]?{digit}+[lLuU]?              {return  DEC_CONSTANT;}
	/*l is long suffix and u is unsigned suffix*/

\"[^\"\n]*$                     {printf("Line %3d: Unterminated string %s\n",yylineno,yytext);}
{digit}+({letter}|_)+	        {printf("Line %3d: Illegal identifier name %s\n",yylineno,yytext);}

"--"		{return DEC;}
"++"		{return INC;}
"+="		{return PLUSEQ;}
"-="		{return MINEQ;}
"*="		{return MULEQ;}
"/="		{return DIVEQ;}
"%="		{return MODEQ;}


"&&"		{return AND;}
"||"		{return OR;}
">="		{return GREQ;}
"<="		{return LSEQ;}
"=="		{return EQ;}
"!="		{return NOTEQ;}

.		{return yytext[0];}


%%
