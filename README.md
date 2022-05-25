Lab Project for CS202- Programming Paradimes & Pragramatics , Academic Year - 2021-22  

ASSUMPTIONS:
1.  There is no greater and less than operator i.e < or >.
2.  There is no type checking after initialization
    so int a="akshat"; will fail
    but let's suppose a is integer , but assignmnet i="akshat" will not fail and not produce an error.
3.  If and else block needs to be in curly braces.  

PARSER_OUTPUT
1. The parser_output will print parser result in new line except for if - else block.
2. The name of the function will be printed after the arguments 
3. The kind of Block will be printed after the respective block i.e like If-Block ended or While loop ended
4. for boolean statements, they are printed like <first_oprand> EQUALITY/NON-EQUALITY <second_operand>
5. Some lines may be printed considering right recursion due to yacc method of parsing.
6. I have tried to make it left rucursion as much as possible.


