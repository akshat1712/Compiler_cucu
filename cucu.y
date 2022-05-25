%{
#include <stdio.h>
#include <stdlib.h>

void yyerror( const char * str);
int yylex();
FILE * parser_output;
extern FILE * yyin;
extern int yylineno;

void yyerror( const char * str)
{
    fprintf(parser_output," Line: %d %s\n",yylineno,str);
}
%}

%token INT CHARS IF ELSE WHILE RETURN;
%token OPR_PAR CLR_PAR OPC_PAR CLC_PAR OPS_PAR CLS_PAR;
%token PLUS NEG MULT DIVD EQUAL ASSIGN NOT_EQUAL;
%token COMMA SEMI AND OR;

%union{
    int number;
    char *string;
}

%left DIVD MULT 
%left PLUS NEG 
%left OPR_PAR CLR_PAR

%token<number> NUMBER
%token<string> ID STRING

%%



PROG:
    PROG_BODY { fprintf(parser_output," Program Ended\n"); return 0;}

PROG_BODY:
    PROG_BODY VAR_DEC  
    | PROG_BODY FUN_DEC 
    | PROG_BODY FUNC 
    |  

VAR_DEC:
    INT ID SEMI     { fprintf(parser_output," Local Variable:%s \n",$2);}
    | CHARS ID SEMI { fprintf(parser_output," Local Variable:%s \n",$2);}

FUN_DEC:
    FUNC_HEADER SEMI

FUNC :
    FUNC_HEADER FUNC_BODY


FUNC_HEADER:
    INT ID OPR_PAR FUNC_PAR CLR_PAR         { fprintf(parser_output," FUNC HEADER: %s \n",$2);}
    | CHARS ID OPR_PAR FUNC_PAR CLR_PAR     { fprintf(parser_output," FUNC HEADER: %s \n",$2);}

FUNC_PAR:
    FUNC_PAR COMMA INT ID                   { fprintf(parser_output," Function Argument: %s ",$4);}
    | FUNC_PAR COMMA CHARS ID               { fprintf(parser_output," Function Argument: %s ",$4);}
    | INT ID                                { fprintf(parser_output," Function Argument: %s \n",$2);}
    | CHARS ID                              { fprintf(parser_output," Function Argument: %s \n",$2);}
    |                                       { fprintf(parser_output,"\n");}





FUNC_BODY:
    OPC_PAR STMTS CLC_PAR                   { fprintf(parser_output," Function Body Ended\n");}

FUNC_CALL:
    ID OPR_PAR FUNC_ARU CLR_PAR SEMI        { fprintf(parser_output," FUNC CALL\n");}


FUNC_ARU:
    FUNC_ARU COMMA EXPR
    | FUNC_ARU COMMA ID ASSIGN EXPR         {fprintf(parser_output," VAR: %s Assigned a value ",$3);}
    | EXPR                                  
    | ID ASSIGN EXPR                        {fprintf(parser_output," VAR: %s Assigned a value ",$1);}
    | FUNC_ARU COMMA STRING                 
    | STRING
    | FUNC_ARU COMMA ID ASSIGN STRING       { fprintf(parser_output," VAR: %s Assigned a value ",$3);}
    | ID ASSIGN STRING                      {fprintf(parser_output," VAR: %s Assigned a value ",$1);}
    |                                       { fprintf(parser_output,"\n");}


STMTS:
    STMTS STMT 
    |

STMT: 
    FUN_DEC   
    | VAR_DEC  
    | VAR_ASG  
    | VAR_DEC_ASG  
    | COND_STMT   
    | FUNC_CALL   
    | RETURN ID SEMI                                { fprintf(parser_output," RETURN From Function ");}

VAR_ASG:
    ID ASSIGN EXPR SEMI                             { fprintf(parser_output," Local Variable:%s \n",$1);}
    | ID ASSIGN STRING SEMI                         { fprintf(parser_output," Local Variable:%s \n",$1);}
    | ID ASSIGN ID OPS_PAR ID CLS_PAR SEMI          { fprintf(parser_output," Local Variable:%s \n",$1);}
    | ID ASSIGN FUNC_CALL                           { fprintf(parser_output," Local Variable:%s \n",$1);}

VAR_DEC_ASG:
    INT ID ASSIGN EXPR SEMI                         { fprintf(parser_output," Local Variable:%s \n",$2);}
    | CHARS ID ASSIGN STRING SEMI                   { fprintf(parser_output," Local Variable:%s \n",$2);}
    | CHARS ID ASSIGN ID OPS_PAR ID CLS_PAR SEMI    { fprintf(parser_output," Local Variable:%s \n",$2);}
    | INT ID ASSIGN FUNC_CALL                       { fprintf(parser_output," Local Variable:%s \n",$2);}


EXPR:
    OPERAND
    | EXPR PLUS EXPR
    | EXPR MULT EXPR
    | EXPR DIVD EXPR
    | EXPR NEG EXPR
    | OPR_PAR EXPR CLR_PAR 

OPERAND:
    NUMBER   { fprintf(parser_output," CONST-:%d ",$1);}
    | ID     { fprintf(parser_output," VAR: %s ",$1);}


COND_STMT:
    WHILE OPR_PAR BOOL_EXPR { fprintf(parser_output,"\n");} CLR_PAR OPC_PAR STMTS CLC_PAR       { fprintf(parser_output," WHILE LOOP ENDED\n");}
    | IF OPR_PAR BOOL_EXPR  CLR_PAR OPC_PAR  STMTS CLC_PAR                                      { fprintf(parser_output," IF STATEMENT ENDED\n");}
    | IF OPR_PAR BOOL_EXPR  CLR_PAR OPC_PAR STMTS CLC_PAR ELSE OPC_PAR STMTS CLC_PAR            { fprintf(parser_output," IF ELSE STATEMENT ENDED\n");}
    
BOOL_EXPR:
    BOOL_EXPR BOOL_OP OPERAND CHECK OPERAND  
    | OPERAND CHECK OPERAND                                         
    | BOOL_EXPR BOOL_OP ID OPS_PAR OPERAND CLS_PAR CHECK STRING         
    | ID OPS_PAR OPERAND CLS_PAR CHECK STRING                       
    | BOOL_EXPR BOOL_OP OPERAND                                     
    | OPERAND
    |                                                               

BOOL_OP:
    AND                                                             { fprintf(parser_output," AND ");}
    | OR                                                            { fprintf(parser_output," OR ");}

CHECK:
    EQUAL                                                           { fprintf(parser_output," EQUALITY TEST ");}
    | NOT_EQUAL                                                     { fprintf(parser_output," NOT-EQUALITY TEST ");}

%%






int main(int argc, char* argv[])
{
    if( argc==1){
        
        printf("No file is given.\n");
        return 0;
    }
    parser_output =fopen("Parser.txt","w");
    yyin=fopen( argv[1],"r");
    yyparse();

    return 0;
}