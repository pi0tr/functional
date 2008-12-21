-module(functional).
-export([e_power/2, reverse_list/1]).

e_power({X, kW}, hp) ->
  X * 0.75;
e_power({X, hp}, kW) ->
  X * (1/0.75).
  
reverse_list([]) -> [];
reverse_list([X|Xs]) -> reverse_list(Xs) ++ [X].

  
