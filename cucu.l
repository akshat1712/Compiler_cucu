%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "cucu.tab.h"

FILE * lexer_output=fopen("Lexer.txt","w");
%}

%%
int                     { fprintf(lexer_output,"TYPE : %s\n",yytext); return INT;}
char[ ]\*               { fprintf(lexer_output,"TYPE : %s\n",yytext); return CHARS;}
[0-9]+                  { fprintf(lexer_output,"NUM : %s\n",yytext);yylval.number=atoi(yytext); return NUMBER;}
if                      { fprintf(lexer_output,"COND_STMT: %s\n",yytext); return IF;}
else                    { fprintf(lexer_output,"COND_STMT: %s\n",yytext); return ELSE;}
while                   { fprintf(lexer_output,"COND_STMT: %s\n",yytext); return WHILE;}
return                  { fprintf(lexer_output,"FUNC_OVER\n"); return RETURN;}
[a-zA-Z][a-zA-Z0-9_]*   { fprintf(lexer_output,"ID : %s\n",yytext); yylval.string=strdup(yytext); return ID;}
\(                      { fprintf(lexer_output,"OPR_PAR\n"); return OPR_PAR;}
\)                      { fprintf(lexer_output,"CLR_PAR\n"); return CLR_PAR;}
\{                      { fprintf(lexer_output,"OPC_PAR\n"); return OPC_PAR;}
\}                      { fprintf(lexer_output,"CLC_PAR\n"); return CLC_PAR;}
\[                      { fprintf(lexer_output,"OPS_PAR\n"); return OPS_PAR;}
\]                      { fprintf(lexer_output,"CLS_PAR\n"); return CLS_PAR;}
\+                      { fprintf(lexer_output,"OP: %s\n",yytext); return PLUS;}
-                       { fprintf(lexer_output,"OP: %s\n",yytext); return NEG;}
\*                      { fprintf(lexer_output,"OP: %s\n",yytext); return MULT;}
\/                      { fprintf(lexer_output,"OP: %s\n",yytext); return DIVD;}
&&                      { fprintf(lexer_output,"OP: %s\n",yytext); return AND;}
(\|\|)                  { fprintf(lexer_output,"OP: %s\n",yytext); return OR;}
==                      { fprintf(lexer_output,"EQUAL : %s\n",yytext); return EQUAL;}
=                       { fprintf(lexer_output,"ASSIGN : %s\n",yytext); return ASSIGN;}
!=                      { fprintf(lexer_output,"NOT_EQUAL : %s\n",yytext); return NOT_EQUAL;}
\/\*(.|\n)*\*\/         { fprintf(lexer_output,"COMMENTS\n");}
,                       { fprintf(lexer_output,"COMMA\n"); return COMMA;}
(;)                     { fprintf(lexer_output,"SEMI : %s\n",yytext); return SEMI;}
\"[a-zA-Z0-9 ]*\"       { fprintf(lexer_output,"STRING : "); for( int i=1;i<yyleng-1;i++){fprintf(lexer_output,"%c",yytext[i]);}printf("\n");yylval.string=strdup(yytext); return STRING;}
[ |\t]                  /*WhiteSpaces Ignored*/
[\n]                    { fprintf(lexer_output,"\n");yylineno++;}

%%


int yywrap(){
    fclose(lexer_output);
    return 1;
}
