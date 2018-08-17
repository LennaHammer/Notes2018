
/**




http://en.cppreference.com/

*/


#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <assert.h>

//char*strdup(char*);

enum Type {T_NIL, INT, PAR, SYM, ENV,};
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
typedef struct Object O;



static O *gc_root = NULL;
void gc_start() {
    for (O * p; p; p = p->next) {
        p->mark = 0;
    }
}
void gc_mark(O *o) {
    if (!o)
        return;
    if (o->mark)
        return;
    o->mark = 1;
    switch (o->type) {
    case PAR:
        gc_mark(o->car);
        gc_mark(o->cdr);
        break;
    default:
        ;
    }
}
void gc_sweep() {
    int count = 0;
    O *p = gc_root;
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

O *make_raw() {
    O *o = (O*)malloc(sizeof(O));
    o->type = 0;
    o->mark = 0;
    o->next = gc_root;
    gc_root = o;
    return o;
}

O *make_int(int x) {
    O *o = make_raw();
    o->type = INT;
    o->integer = x;
    return o;
}

O* make_sym(char *s) {
    O *o = make_raw();
    o->type = SYM;
    o->string = strdup(s);
    return o;
}

O* make_pair(O* car, O* cdr) {
    O *o = make_raw();
    o->type = PAR;
    o->car = car;
    o->cdr = cdr;
    return o;
}

O* make_proc(O *args, O *body, O *env) {
    O *o = make_raw();
    o->args = args;
    o->body = body;
    o->env = env;
    return o;
}



static char token[64];
static char *token_append;
static const char *token_input;

int token_peekchar() {
    return *token_input;
}
void token_nextchar() {
    token_input++;
}
void token_skipspace() {
    while (isspace(token_peekchar()))
        token_nextchar();
}
void token_next() {
    token_skipspace();
    int c = token_peekchar();
    switch (c) {
    case '(':
    case ')':
        token[0] = c;
        token[1] = '\0';
        token_nextchar();
        break;
    case 0:
    case -1:
        token[0] = '\0';;
    default:
        *token = c;
        token_append = token + 1;
        token_nextchar();
        while ((c = token_peekchar()) != ')' && c != '(' && !isspace(c)) {
            *token_append++ = c;
            token_nextchar();
        }
        *token_append = '\0';

    }
}
O *parse_list();
O* parse_atom();
O* parse_sexp() {
    if (token[0] == '(') {
        token_next();
        return parse_list();
    } else {
        return parse_atom();
    }
}

O *parse_list() {
    O *list = NULL;
    O **t = &list;
    for (;;) {
        O *o = parse_sexp();
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

O* parse_atom() {
    O *o = make_sym(token);
    token_next();
    return o;
}

O* parse(char *s) {
    printf("parsing: %s\n", s);
    token_input = s;
    token_next();
    O *o = parse_sexp();
    return o;
}

void display(O *o) {
    if (!o) {
        return;
    }
    switch (o->type) {
    case T_NIL:
        printf("#nil\n");
        break;
    case SYM:
        printf("sym %s\n", o->string);
        break;
    case INT:
        printf("int %d\n", o->integer);
        break;
    case PAR:
        printf("begin cons\n");
        display(o->car);
        display(o->cdr);
        printf("end cons\n");
        break;
    default:
        printf("#unknown\n");
    }
}

int eq(O *o, O *p) {
    if (o->type != p->type)
        return 0;
    switch (o->type) {
    case T_NIL:
        return 1;
    case INT:
        return o->integer == p->integer;
    case SYM:
        return !strcmp(o->string, p->string);
    default:
        return 0;
    }
}

int is_symbol(O *o, char* s) {
    return (o->type == SYM && !strcmp(o->string, s));
}

static char *error = NULL;

O* init() {

}
O *env_make() {
    return make_pair(NULL, NULL);
}
O *env_lookup(O *env, char *key) {
    while (env) {
        O *list = env->car;
        for (O *node = list; node; node = node->cdr) {
            assert(node->car->type == SYM);
            if (!strcmp(node->car->string, key)) {
                return node->cdr;
            }
        }
        env = env->cdr;
    }
    return NULL;
}
O* env_define(O *env, char *key, O *value) {
    O *kv = make_pair(make_sym(key), value);
    env->car = make_pair(kv, env->car);
    return NULL;
}


void check(int bool_expr) {

}
O* eval_expr(O *o, O *env) {
    if (!o)
        return NULL;
    switch (o->type) {
    case PAR:
        //O *op = o->car;
        switch (o->type) {
        case SYM:
            if (!strcmp(o->string, "lambda")) {
                return;
            } else if (!strcmp(o->string, "define")) {

            } else if (!strcmp(o->string, "+")) {

            } else {

            }
            break;
        default:
            assert(0);
        }
        break;
    default:
        return o;
    }
}

O *eval(char* s) {
    return NULL;
}


void calc(char *s) {

}
void debug_print_tokens(char *s) {
    token_input = s;
    for (;;) {
        token_next();
        if (!*token)
            break;
        puts(token);
    }
}
void test() {
    debug_print_tokens("(+ 123 (sin 23 3))");
    assert(1);
    debug_print_tokens("12345");
    O *o = parse("12345");
    display(o);
    o = parse("(+ 1 2 3)");
    display(o);
    puts(".");
    o = parse("(+ 123 (sin 23 3))");
    display(o);
    puts(".");
    o = eval("(+ 1 2)");
    display(o);
    o = eval("((lambda (x) (+ x 1)) x)");
    display(o);
}
int main() {
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
