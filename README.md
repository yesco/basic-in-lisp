# basic-in-lisp
A simple basic interpreter in lisp (scheme) for esp8266 esp-lisp

This is for lio ( https://github.com/lionello ) - haha!

## run on unix/guile

    unix> guile basic.scm
    Ready!
    list
    (10 let n = 0)
    (20 print hello)
    (30 print n)
    (40 let n = n + 1 * 2)
    (50 goto 20)
    Ready!
    run
    hello
    0
    hello
    2
    hello
    4
    hello
    6
    hello
    8
    hello
    ....


## run on esp-lisp on esp8266

not working on esp-lisp yet (too much schemeisms here)

## functionality

- only integers
- lower case keywords
- simple expressions with + - / * with correct priorites
- you have to use let
- to edit a line type it in: (35 print "moho!")
- single word comands just type it: run / list
- any statement can be typed on the command line: (print "hello")
- goto NN / gosub NN / print X
- TODO: if ;-)
