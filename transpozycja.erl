-module(transpozycja).
-author('baryluk@smp.if.uj.edu.pl').

-export([tr/1]).

-export([tests_bad_/0]).
-export([tests_good_/0]).


t(T) ->
	io:format("~n~nTesting: ~p~n", [T]),
	TR = tr(T),
	io:format("Result:  ~p~n", [TR]),
	TR2 = tr(TR),
	io:format("Result2: ~p~n", [TR2]),
	true = (TR2 =:= T).

t2(T) ->
	io:format("~n~nTesting: ~p~n", [T]),
	TR = tr(T),
	io:format("Result:  ~p~n", [TR]),
	TR2 = tr(TR),
	io:format("Result2: ~p~n", [TR2]),
	false.

tests_good_() ->
	t([
		[]
	]),
	t([
		[a]
	]),
	t([
		[a,b],
		[e,f]
	]),
	t([
		[a,b]
	]),
	t([
		[a],
		[e]
	]),
	t([
		[a,b,c],
		[e,f,g],
		[i,j,k]
	]),
	t([
		[a,b,c],
		[e,f,g]
	]),
	t([
		[a,b],
		[e,f],
		[i,j]
	]),
	t([
		[a,b,c]
	]),
	t([
		[a],
		[e],
		[i]
	]),
	t([
		[a,b,c,d],
		[e,f,g,h],
		[i,j,k,l],
		[m,n,o,p]
	]),
	t([
		[a,b,c,d],
		[e,f,g,h],
		[i,j,k,l]
	]),
	t([
		[a,b,c],
		[e,f,g],
		[i,j,k],
		[m,n,o]
	]),
	% w zasadze to niby jakie wynik miałby to dawać? []? 
%	t([
%		[],
%		[]
%	]),
%	t([
%		[],
%		[],
%		[]
%	]),
%	t([
%		[],
%		[],
%		[],
%		[]
%	]),
	ok.

tests_bad_() ->
	t2(not_a_list),
	t2([
	]),
	t2([
		[],
		[]
	]),
	t2([
		[a],
		[e,f]
	]),
	t2([
		[a,b],
		[e]
	]),
	t2([
		[a],
		[]
	]),
	t2([
		[],
		[e]
	]),
	ok.

-spec tr(list(list(any()))) -> list(list(any())) | {'error' | 'not_a_matrix'}.
tr([]) ->
	% special case
	{error, not_a_matrix};
tr([[]]) ->
	% special case
	[[]];
tr(T) when is_list(T) ->
	case tr_left(T, [], [], []) of
		[] ->
			{error, not_a_matrix};
		Other ->
			Other
	end.

tr_left([[] | T], [], [], FullAcc) ->
	consume_left(T, [], [], FullAcc);
tr_left([], [], [], FullAcc) ->
	lists:reverse(FullAcc);
tr_left([], [[]], [], FullAcc) ->
	lists:reverse(FullAcc);
tr_left([[E | T2] | T], Rest, Acc, FullAcc) ->
	tr_left(T, [T2 | Rest], [E | Acc], FullAcc);
tr_left([], Rest, Acc, FullAcc) ->
	tr_left(lists:reverse(Rest), [], [], [lists:reverse(Acc) | FullAcc]);
tr_left(_, _, _, _) ->
	{error, not_a_matrix}.

% consume remaining empty elements in list
consume_left([[] | T], [], [], FullAcc) ->
	consume_left(T, [], [], FullAcc);
consume_left([], [], [], FullAcc) ->
	tr_left([], [], [], FullAcc);
consume_left(_, _, _, _) ->
	{error, not_a_matrix}.
