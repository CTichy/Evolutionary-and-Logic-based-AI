% Define houses
house(1..5).

% Define attributes
color(red; green; white; yellow; blue).
nationality(english; swede; dane; norwegian; german).
pet(dog; bird; cat; horse; zebra).
drink(tea; coffee; milk; beer; water).
cigar(pall_mall; dunhill; blend; blue_master; prince).

% Assign exactly one attribute of each type to each house
1 { painted(H, C) : color(C) } 1 :- house(H).
1 { lives_in(H, N) : nationality(N) } 1 :- house(H).
1 { owns_pet(H, P) : pet(P) } 1 :- house(H).
1 { drinks(H, D) : drink(D) } 1 :- house(H).
1 { smokes(H, S) : cigar(S) } 1 :- house(H).

% Ensure each attribute is used exactly once
1 { painted(H, C) : house(H) } 1 :- color(C).
1 { lives_in(H, N) : house(H) } 1 :- nationality(N).
1 { owns_pet(H, P) : house(H) } 1 :- pet(P).
1 { drinks(H, D) : house(H) } 1 :- drink(D).
1 { smokes(H, S) : house(H) } 1 :- cigar(S).

% ensure that clingo does not introduce house 6, with house(6)=False
% :- painted(H, _), not house(H).
% :- lives_in(H, _), not house(H).
% :- owns_pet(H, _), not house(H).
% :- drinks(H, _), not house(H).
% :- smokes(H, _), not house(H).

% Define adjacency
adjacent(H1, H2) :- house(H1), house(H2), H1 = H2 + 1.
adjacent(H1, H2) :- house(H1), house(H2), H1 = H2 - 1.

% Clues
painted(H, red) :- lives_in(H, english).          % The Englishman lives in the red house.
owns_pet(H, dog) :- lives_in(H, swede).           % The Swede keeps dogs.
drinks(H, tea) :- lives_in(H, dane).              % The Dane drinks tea.
painted(H2, white) :- painted(H1, green), H1 = H2 - 1, adjacent(H1,H2).  % The green house is immediately to the left of the white house.
drinks(H, coffee) :- painted(H, green).           % They drink coffee in the green house.
owns_pet(H, bird) :- smokes(H, pall_mall).         % The person who smokes Pall Mall keeps birds.
painted(H, yellow) :- smokes(H, dunhill).          % The person in the yellow house smokes Dunhill.
drinks(3, milk).                                   % They drink milk in the middle house.
lives_in(1, norwegian).                            % The Norwegian lives in the first house.
smokes(H1, blend) :- adjacent(H1, H2), owns_pet(H2, cat). % The man who smokes Blend lives next to the one who keeps cats.
owns_pet(H2, horse) :- adjacent(H1, H2), smokes(H1, dunhill). % The man who keeps horses lives next to the one who smokes Dunhill.
drinks(H, beer) :- smokes(H, blue_master).         % The man who smokes Blue Master drinks beer.
smokes(H, prince) :- lives_in(H, german).          % The German smokes Prince.
painted(H2, blue) :- lives_in(H1, norwegian), adjacent(H1, H2). % The Norwegian lives next to the blue house.
smokes(H1, blend) :- adjacent(H1, H2), drinks(H2, water). % The man who smokes Blend has a neighbor who drinks water.

% Determine the zebra owner
zebraOwner(N) :- lives_in(H, N), owns_pet(H, zebra).

#show zebraOwner/1.
