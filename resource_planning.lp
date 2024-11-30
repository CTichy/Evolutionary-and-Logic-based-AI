% =================
% INPUT DATA
% =================
% Example data to be entered externally  (e.g. by restaurants_and_depots.lp)
% restaurant(1, 3).    % Restaurant 1 is located at position 3
% restaurant(2, 5).    % Restaurant 2 is located at position 5
% restaurant(3, 8).    % Restaurant 3 is located at position 8
% restaurant(4, 10).   % Restaurant 4 is located at position 10
% depots(5).	% Number of depots to select
% maxdist(2).	% Maximum allowed total distance

% =================
% CMD LINE TO RUN
% =================
% clingo ./restaurants_and_depots.lp ./resource_planning.lp -t 4 -n 0
 
% =================
% HELPER PREDICATES
% =================

% Calculate the absolute value of the difference between two positions
dist_rest_dep(R, DISTANCE) :- restaurant(R, POS_A), restaurant(D, POS_B), choose(D), POS_A >= POS_B, DISTANCE = POS_A - POS_B.
dist_rest_dep(R, DISTANCE) :- restaurant(R, POS_A), restaurant(D, POS_B), choose(D), POS_A < POS_B, DISTANCE = POS_B - POS_A.

% A restaurant is served by at least one depot
:- restaurant(R, _), not dist_rest_dep(R, _).

% Minimum distance from a restaurant to a chosen depot
min_dist_depot(R, MIN_DIST) :- restaurant(R, _), MIN_DIST = #min { DISTANCE: dist_rest_dep(R, DISTANCE) }, MIN_DIST != #sup. % empty set evaluates to #sup => would return warnings otherwise

% Total distance for every restaurants to their closest depot
total_distance(R, SUM_DIST) :- restaurant(R, _), SUM_DIST = #sum { DISTANCE: min_dist_depot(R, DISTANCE) }.

% =================
% MAIN LOGIC
% =================
% Select exactly K depots
K { choose(D) : restaurant(D, _) } K :- depots(K).

% =================
% CONSTRAINTS
% =================

% Enforce maximum allowed total distance
:- maxdist(MAX), total_distance(_, SUM_DIST), SUM_DIST > MAX.

% =================
% OUTPUT
% =================

#show choose/1.
%#show min_dist_depot/2.
#show total_distance/2.