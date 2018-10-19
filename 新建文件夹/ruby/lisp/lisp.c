
/**




http://en.cppreference.com/

*/


#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <assert.h>

//char*strdup(char*);

enum Type {T_NIL, T_INTEGER, T_PAIR, T_SYMBOL, ENV,};
struct Object {
    char type;
    union {
        int integer;
        //float number;
        char *string;
        void *pointer;
        struct {
            struct Object *car;
            struct Object *cdr;
        };
        struct {
            struct Object *args;
            struct Object *body;
            struct Object *env;
        };
    };
    char mark;
    struct Object *next;
};
typedef struct Object Object;
Object *car(Object *pair)
{
    assert(pair->type==T_PAIR);
    return pair->car;
}
Object *cdr(Object *pair)
{
    assert(pair->type==T_PAIR);
    return pair->cdr;
}

#define caar(x) car(car(x))
#define cadr(x) car(cdr(x))
#define caddr(x) car(cdr(cdr(x)))


static Object *gc_root = NULL;

void runtime_assert(int boolexpr, const char* msg){
    if(!bool_expr){
        printf("%s",msg);
        exit(1);
    }
}


void gc_start()
{
    for (Object * p; p; p = p->next) {
        p->mark = 0;
    }
}
void gc_mark(Object *o)
{
    if (!o)
        return;
    if (o->mark)
        return;
    o->mark = 1;
    switch (o->type) {
    case T_PAIR:
        gc_mark(o->car);
        gc_mark(o->cdr);
        break;
    default:
        ;
    }
}
void gc_sweep()
{
    int count = 0;
    Object *p = gc_root;
    while (p && p->next) {
        if (p->mark) {
            break;
        } else {

        }
    }
    while (p) {
        if (gc_root == 0) {

        }
        p = p->next;
    }
    printf("%d object(s)\n", count);
}

Object *_alloc_object()
{
    Object *o = (Object*)malloc(sizeof(Object));
    o->type = 0;
    o->mark = 0;
    o->next = gc_root;
    gc_root = o;
    return o;
}

Object *make_integer(int x)
{
    Object *o = _alloc_object();
    o->type = T_INTEGER;
    o->integer = x;
    return o;
}

Object *make_symbol(const char *s)
{
    for(Object *node;node;node=node->next){
        if(node->type==T_SYMBOL && !strcmp(node->string, s)){
            return node;
        }
    }
    Object *o = _alloc_object();
    o->type = T_SYMBOL;
    o->string = strdup(s);
    return o;
}

Object *make_pair(Object* car, Object* cdr)
{
    Object *o = _alloc_object();
    o->type = T_PAIR;
    o->car = car;
    o->cdr = cdr;
    return o;
}

Object* make_proc(Object *args, Object *body, Object *env)
{
    Object *o = _alloc_object();
    o->args = args;
    o->body = body;
    o->env = env;
    return o;
}



static char token[64];
static char *token_append;
static const char *token_input;

int token_peekchar()
{
    return *token_input;
}
void token_getchar()
{
    token_input++;
}
void token_skipspace()
{
    while (isspace(token_peekchar()))
        token_getchar();
}
void token_next()
{
    token_skipspace();
    int c = token_peekchar();
    switch (c) {
    case '(':
    case ')':
        token[0] = c;
        token[1] = '\0';
        token_getchar();
        break;
    case 0:
    case -1:
        token[0] = '\0';
    default:
        *token = c;
        token_append = token + 1;
        token_getchar();
        while ((c = token_peekchar()) != ')' && c != '(' && !isspace(c)) {
            *token_append++ = c;
            token_getchar();
        }
        *token_append = '\0';

    }
}


Object *parse_list();
Object *parse_atom();
Object *parse_sexp()
{
    if (token[0] == '(') {
        token_next();
        return parse_list();
    } else {
        return parse_atom();
    }
}

Object *parse_list()
{
    Object *list = NULL;
    Object **t = &list;
    for (;;) {
        Object *o = parse_sexp();
        *t = make_pair(o, NULL);
        t = &(*t)->cdr;
        if (*token == ')') {
            token_next();
            return list;
        } else if (*token == 0) {
            printf("')' missing");
            assert(0);
            //exit(1);
        }
    }
    return NULL;
}

Object* parse_atom()
{
    Object *o;
    char *end;
    long x = strtol(token,&end,10);
    if(*end==0){
        o = make_integer(x);
    }else{
        o = make_symbol(token);
    }
    token_next();
    return o;
}

Object* parse(char *s)
{
    printf("parsing: %s\n", s);
    token_input = s;
    token_next();
    Object *o = parse_sexp();
    return o;
}

void _display(Object *o)
{
    if (o==NULL) {
        printf("nil");
        return;
    }
    switch (o->type) {
    case T_NIL:
        printf("nil");
        break;
    case T_SYMBOL:
        printf("%s", o->string);
        break;
    case T_INTEGER:
        printf("%d", o->integer);
        break;
    case T_PAIR:
        printf("(cons ");
        _display(o->car);
        printf(" ");
        _display(o->cdr);
        printf(")");
        break;
    default:
        printf("#unknown\n");
    }
}
void display(Object *o)
{
    _display(o);
    printf("\n");
}

int eq(Object *o, Object *p)
{
    if (o->type != p->type)
        return 0;
    switch (o->type) {
    case T_NIL:
        return 1;
    case T_INTEGER:
        return o->integer == p->integer;
    case T_SYMBOL:
        return !strcmp(o->string, p->string);
    default:
        return 0;
    }
}

int is_symbol(Object *o, char* s)
{
    return (o->type == T_SYMBOL && !strcmp(o->string, s));
}

static char *error = NULL;

Object* init()
{

}

typedef Object *Environment;
Environment environment_make()
{
    return make_pair(NULL, NULL);
}
Object *environment_lookup(Environment env, Object *key)
{
    assert(key->type == T_SYMBOL);
    while (env) {
        Object *list = env->car;
        for (Object *node = list; node; node = node->cdr) {
            Object *kv = node->car;
            if (kv->car==key) {
                return node->cdr;
            }
        }
        env = env->cdr;
    }
    return NULL;
}
void environment_define(Environment env, Object *key, Object *value)
{
    assert(key->type == T_SYMBOL);
    Object *kv = make_pair(key, value);
    env->car = make_pair(kv, env->car);
}


Object *eval_node(Object *node, Object *env)
{
    static lambda = make_symbol("lambda");

    if(node->type==T_PAIR) {
        Object *op = car(node);
        if (!strcmp(op->string, "lambda")) {
            return NULL;
        } else if (!strcmp(op->string, "define")) {
            char *key = car(cdr(node))->string;
            Object *value = eval_node(caddr(node),env);
            environment_define(env,key,value);
            return NULL;
        } else if (!strcmp(op->string, "if")) {
            char *key = car(cdr(node))->string;
            Object *value = eval_node(caddr(node),env);
            environment_define(env,key,value);
            return NULL;
        } else if (!strcmp(op->string, "+")) {
            Object *a = eval_node(cadr(node),env);
            Object *b = eval_node(caddr(node),env);
            assert(a->type==T_INTEGER && b->type==T_INTEGER);
            Object* c = make_integer(a->integer+b->integer);
            return c;
        } else {
            return node;
        }
    } else if(node->type==T_SYMBOL) {
        Object *value = environment_lookup(env, node);
        runtime_assert(value,"var not found");
        return value;
    } else {
        return node;
    }

}

Object *eval(char* s)
{
    printf("eval> %s\n",s);
    Object *tree = parse(s);
    Object *env = environment_make();
    return eval_node(tree,env);
}

void debug_print_tokens(char *s)
{
    printf("parse> %s\n",s);
    token_input = s;
    for (;;) {
        token_next();
        if (!*token)
            break;
        printf("\ttoken> %s\n",token);
    }
}
void test()
{
    debug_print_tokens("(+ 123 (sin 23 3))");
    assert(1);
    debug_print_tokens("12345");
    Object *o = parse("12345");
    display(o);
    o = parse("(+ 1 2 3)");
    display(o);
    o = parse("(+ 123 (sin 23 3))");
    display(o);
        o = parse("((lambda (x) (+ x 1)) 2)");
    display(o);
    o = eval("(+ 1 2)");
    display(o);
    //o = eval("((lambda (x) (+ x 1)) 2)");
    //display(o);
}
int main()
{
    int sum = 0;
    for (int i = 1; i <= 100; i++) {
        sum += i;
    }
    printf("%d\n", sum);
    puts("hello world");

    //calc("(+ 1 (* 2 3))");
    test();
    //getchar();
    //getch();
    return 0;
}
