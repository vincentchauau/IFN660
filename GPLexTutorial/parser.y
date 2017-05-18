﻿﻿%namespace GPLexTutorial

%union
{
    public int num;
    public string name;
    public CompilationUnit compUnit;
    public TypeDeclaration typeDecl;
    public NormalClassDeclaration normclassDecl;
    public ClassModifier classModi;  
    public Identifier identi;
    public ClassBody classBodi;
    public MethodDeclaration methDecl;
    public MethodModifier methModi;
    public Result result;
	public BlockStatement blksta;
	public List<BlockStatement> blkstas;
	public Block block;
	public MethodDeclarator methodecla;
	public MethodHeader methodhea;
	public ExpressionStatement expstm;
	
}

%token <num> NUMBER
%token <name> IDENTIFIER 
%token PUBLIC CLASS STATIC VOID INT
%token PRIVATE PROTECTED 

%left '=' 
%nonassoc '<'
%left '+'

%type <compUnit> CompilationUnit
%type <typeDecl> TypeDeclaration 
%type <normclassDecl> NormalClassDeclaration
%type <classModi> ClassModifier
%type <identi> Identifier
%type <classBodi> ClassBody
%type <methModi> MethodModifier
%type <methDecl> MethodDeclaration
%type <result> Result
%type <blksta> BlockStatement
%type <blkstas> BlockStatements
%type <methodecla> MethodDeclarator
%type <methodhea> MethodHeader
%type <block> Block
%type <block> MethodBody
%type <expstm> ExpressionStatement


%%

CompilationUnit
	: PackageDeclaration ImportDeclarations TypeDeclaration   { $$=new CompilationUnit(null,null,$3); }
	;

empty
	: 
	;

PackageDeclaration
	: empty
	;

ImportDeclarations
	: empty
	;

TypeDeclaration
	: NormalClassDeclaration								{ $$ = $1; }
	;

NormalClassDeclaration
	: ClassModifier CLASS Identifier TypeParameters '{' ClassBody '}'  {$$ = new NormalClassDeclaration($1,$3,$6);}
	;

Identifier
	: IDENTIFIER											{ $$ = $1; }
	;

ClassModifier
	: PUBLIC												{ $$ = ClassModifier.Public; } 
	;

TypeParameters
	: empty
	;

ClassBody
	: MethodDeclaration										{$$ = new ClassBody($1);}
	| empty
	;

MethodDeclaration
    : MethodModifiers MethodHeader MethodBody				{ $$ = new MethodDeclaration($1,$2,$3); }
    | empty
    ;

MethodModifiers
	: MethodModifier MethodModifiers						{ $$ = $2; $$.Add($1); }
	| empty													{ $$ = new List<MethodModifier>(); }
	;

MethodModifier
    : PUBLIC												{ $$ = $1; }
	| STATIC												{ $$ = $1; }
    ;

MethodHeader
    : Result MethodDeclarator								{$$ = new MethodHeader($1,$2);}
    ;

Result
    : VOID													{ $$ = $1; }
    ;

MethodDeclarator
    : Identifier '(' FormalParameterList ')'				{$$ = new MethodDeclarator($1,$3);}
    ;

FormalParameterList
    : FormalParameterList FormalParameter					{ $$ = $1; $$.Add($2); }
    | empty													{ $$ = new List<FormalParameter>(); }
    ;

FormalParameter
    : VariableModifiers UnannType VariableDeclaratorId		{ $$ = new FormalParameter($2,$3); }
    ;

MethodBody 
	: Block													{ $$ = $1; }
	;

Block
    : '{' BlockStatements '}'								{ $$ = $2; }
    ;

BlockStatements
	: BlockStatements BlockStatement						{ $$ = $1; $$.Add($2); }
	| empty													{ $$ = new List<BlockStatement>(); }
	;

BlockStatement
	: LocalVariableDeclarationStatement						{ $$ = $1; }
	| Statement												{ $$ = $1; }
	;

LocalVariableDeclarationStatement
	: LocalVariableDeclaration ';'							{ $$ = $1; }
	;

LocalVariableDeclaration
	: VariableModifiers UnannType VariableDeclarationList	{ $$ = new LocalVariableDeclaration($1,$2,$3); }
	;

VariableModifiers
	: VariableModifier VariableModifiers					{ $$ = $2; $$.Add($1); }
	| empty													{ $$ = new List<VariableModifier>(); }
	;

VariableModifier
	: empty													{ $$ = $1; }
	;

UnannType
	: UnannPrimitiveType									{ $$ = $1; }
	| UnannReferenceType									{ $$ = $1; }
	;

UnannReferenceType
	: UnannArrayType										{ $$ = $1; }
	;

UnannArrayType
	: UnannPrimitiveType '[' ']'							{ $$ = $1; }
	;

UnannPrimitiveType
	: NumericType											{ $$ = $1; }
	;

NumericType
	: IntegralType											{ $$ = $1; }
	;

IntegralType
	: INT													{ $$ = $1; }
	;

VariableDeclarationList
	: VariableDeclarator									{ $$ = $1; }
	;

VariableDeclarator
	: VariableDeclaratorId									{ $$ = $1; }
	;

VariableDeclaratorId
	: IDENTIFIER											{ $$ = $1; }
	;

Statement
	: ExpressionStatement									{ $$ = $1; }
	;

ExpressionStatement
	: Assignment ';'										{ $$ = $1; }
	;

Assignment
	: LeftHandSide AssignmentOperator Expression			{ $$ = new Assignment($1,$3); }
	;

LeftHandSide
	: ExpressionName										{ $$ = $1; }
	;

ExpressionName
	: IDENTIFIER											{ $$ = $1; }
	;

AssignmentOperator
	: '='													{ $$ = $1; }
	;

Expression
	: AssignmentExpression									{ $$ = $1; }
	;

AssignmentExpression
	: IntegerLiteral										{ $$ = $1; }
	;
IntegerLiteral
	: NUMBER												{ $$ = $1; }
	;

%%

public Parser(Scanner scanner) : base(scanner)
{

}
