java_comp : y.tab.c lex.yy.c
	cc y.tab.c lex.yy.c -ly -ll -o java_comp

y.tab.c : java_comp.y
	yacc -d -vd java_comp.y

lex.yy.c:java_comp.lex
	lex java_comp.lex

clean:
	rm y.output y.tab.c y.tab.h lex.yy.c java_comp