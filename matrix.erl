-module(matrix).
-author('baryluk@smp.if.uj.edu.pl').

-export([tests_good_/0]).

-export([mul/2, mul_vec/2]).
-export([dot/2, blas_0/2, blas_0/3, blas_1/2, blas_1/3, blas_1/5]).


tests_good_() ->
	M1 = [
		[1.0,2.0,3.0],
		[4.0,5.0,6.0],
		[7.0,8.0,9.0]
	],
	V2 = [11.0, 12.0, 13.0],

	M1M1 = mul(M1, M1),
	true = ([[30.0, 36.0, 42.0],
	 [66.0, 81.0, 96.0],
	 [102.0, 126.0, 150.0]] =:= M1M1),
	io:format("~p~n", [M1M1]),

	M1V2 = mul_vec(M1, V2),
	true = ([74.0, 182.0, 290.0] =:= M1V2),
	io:format("~p~n", [M1V2]).


% matrix-matrix multiplication
-spec mul([[number()]], [[number()]]) -> [[number()]].
mul(A, B) ->
	TB = transpozycja:tr(B),
	comb(A, TB, fun (X, Y) ->
	%	comb(X, Y, fun (XX, YY) -> XX*YY end) % Kronecker's product ?
		dot(X, Y)
	end).

%-spec comb(list(), list(), fun(list(), list()) -> any() end) -> any().
comb(L1, L2, F) ->
	[ [ F(X, Y) || Y <- L2 ] || X <- L1 ].


% matrix-vector multiplication
-spec mul_vec([[number()]], [number()]) -> number().
mul_vec(A, V) ->
	[ dot(X, V) || X <- A ].

% dot product
-spec dot([number()], [number()]) -> number().
dot(L1, L2) ->
	dot(L1, L2, 0.0).

-spec dot([number()], [number()], number()) -> number().
dot([], [], Acc) ->
	Acc;
dot([H1 | T1], [H2 | T2], Acc) ->
	dot(T1, T2, H1*H2 + Acc).


% blas methods
-spec blas_0([number()], number()) -> [number()].
blas_0(X, Delta) when is_number(Delta)  ->
	[ E + Delta || E <- X ].

-spec blas_0(number(), [number()], number()) -> [number()].
blas_0(Alpha, X, Delta) when is_number(Alpha), is_number(Delta)  ->
	[ Alpha*E + Delta || E <- X ].

-spec blas_1(number(), [number()]) -> [number()].
blas_1(Alpha, X) when is_number(Alpha) ->
	[ Alpha*E || E <- X ].

-spec blas_1(number(), [number()], number()) -> [number()].
blas_1(Alpha, X, Delta) when is_number(Alpha), is_number(Delta) ->
	[ Alpha*E + Delta || E <- X ].

-spec blas_1(number(), [number()], number(), [number()], number()) -> [number()].
blas_1(Alpha, X, Beta, Y, Delta) when is_number(Alpha), is_number(Beta), is_number(Delta) ->
	blas_1_(Alpha, X, Beta, Y, Delta, []).

-spec blas_1_(number(), [number()], number(), [number()], number(), [number()]) -> [number()].
blas_1_(_Alpha, [], _Beta, [], _Delta, Acc) ->
	Acc;
blas_1_(Alpha, [H1 | T1], Beta, [H2 | T2], Delta, Acc) ->
	blas_1_(Alpha, T1, Beta, T2, Delta, [Alpha*H1 + Beta*H2 + Delta | Acc]).
