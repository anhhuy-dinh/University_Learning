dvAnCo(de).
dvHungDu(chosoi).
dvAnThit(X) :- dvHungDu(X).
an(X, thit) :- dvAnThit(X).
an(X, co) :- dvAnCo(X).
an(X, Y) :- dvAnThit(X), dvAnCo(Y).
uong(X, nuoc) :- dvAnThit(X).
uong(X, nuoc) :- dvAnCo(X).
tieuThu(X, Y) :- an(X, Y).
tieuThu(X, Y) :- uong(X, Y).

/*
    >> Cau hoi:
        ?- dvHungDu(X), tieuThu(X,Y).
        
    >> Ket qua:
    * ============ * ============ *
    |      X       |       Y      |
    * ============ * ============ *
    |    chosoi    *     thit     |
    |    chosoi    *      de      |
    |    chosoi    *     nuoc     |
    * ============ * ============ *
*/
