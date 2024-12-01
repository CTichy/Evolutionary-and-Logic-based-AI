% =================
% Application 1: Task-Part
% AUTHORS: GROUP 10 - Anna M. Punzengruber, Martin Stasek, Carlos E. Tichy
% =================

% =================
% INPUT DATA in other file
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
% clingo ./restaurants_and_depots.lp ./resource_planning.lp -t 1 -n 0
 
% =================
% MAIN LOGIC
% =================

% Select exactly K depots
K { choose(D) : restaurant(D, _) } K :- depots(K).

% Calculate the absolute value of the difference between restaurant and depots
dist_rest_dep(R, DISTANCE) :- restaurant(R, POS_A), restaurant(D, POS_B), choose(D), POS_A >= POS_B, DISTANCE = POS_A - POS_B.
dist_rest_dep(R, DISTANCE) :- restaurant(R, POS_A), restaurant(D, POS_B), choose(D), POS_A < POS_B, DISTANCE = POS_B - POS_A.

% A restaurant is served by at least one depot
served(R) :- restaurant(R, _), dist_rest_dep(R, _).
:- restaurant(R,_), not served(R).

% Minimum distance from a restaurant to a chosen depot
min_dist_depot(R, MIN_DIST) :- restaurant(R, _), MIN_DIST = #min { DISTANCE: dist_rest_dep(R, DISTANCE) }, MIN_DIST!=#sup.

% Total distance for every restaurants to their closest depot
total_distance(SUM_DIST) :- SUM_DIST = #sum { DISTANCE, R: min_dist_depot(R, DISTANCE), DISTANCE!=#sup }.

% Enforce maximum allowed total distance
:- maxdist(MAX), total_distance(SUM_DIST), SUM_DIST > MAX.

% =================
% OUTPUT
% =================

#show choose/1.
%#show min_dist_depot/2.
%#show total_distance/1.
%#show dist_rest_dep/2.