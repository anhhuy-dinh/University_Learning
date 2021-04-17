:- dynamic visited_state/5.  /* Create a database */

min(X, Y, K) :- X > Y, K is Y.
min(X, Y, K) :- X =< Y, K is X.

input(Vx, Vy, Z) :- 
    X = 0, Y = 0,
	/* Remove all clauses in database before we begin */
	retractall(visited_state(_,_,_,_,_)),  
	state(X, Y, Vx, Vy, Z).	

/* if Z > max(Vx, Vy) then the problem has no solution */ 
state(_, _, Vx, Vy, Z) :- 
	Z > Vx, Z > Vy, 
	write('No solution!').

state(Z, _, _, _, Z) :- write('Goal state').
state(_, Z, _, _, Z) :- write('Goal state').

state(X, Y, Vx, Vy, Z) :- 
	Y = 0, 
	New_Y is Vy, 
	not(visited_state(X, New_Y, Vx, Vy, Z)), 
	assertz(visited_state(X, Y, Vx, Vy, Z)),
	format('Pour ~d lit water into jug Y: (~d, ~d).', [Vy, X, New_Y]), 
    nl,
	state(X, New_Y, Vx, Vy, Z).

state(X, Y, Vx, Vy, Z) :- 
	X = Vx, 
	New_X is 0,
	not(visited_state(New_X, Y, Vx, Vy, Z)),
	assertz(visited_state(X, Y, Vx, Vy, Z)), 
	format('Pour ~d lit water of jug X out: (~d, ~d).', [Vx, New_X, Y]),
	nl,
	state(New_X, Y, Vx, Vy, Z).

state(X, Y, Vx, Vy, Z) :- 
	not(Y = 0), X < Vx, 
	min(Y, Vx - X, K), New_X is X + K, New_Y is Y - K,
	not(visited_state(New_X, New_Y, Vx, Vy, Z)),
	assertz(visited_state(X, Y, Vx, Vy, Z)), 
	format('Pour ~d lit water from jug Y to jug X: (~d, ~d)', [K, New_X, New_Y]),
	nl, 
	state(New_X, New_Y, Vx, Vy, Z).

/*
For example, we start a program by using the query: 
input(7, 4, 2). 
We will receive the result. 
*** Note that: z <= max(Vx, Vy).
*/






