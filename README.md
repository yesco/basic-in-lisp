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
    (40 let n = n + 1)
    (50 goto 20)
    Ready!
    run
    hello
    0
    hello
    1
    hello
    2
    hello
    3
    hello
    4
    hello
    ....



## run on esp-lisp on esp8266

not working on esp-lisp yet (too much schemeisms here)
