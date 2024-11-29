% =================
% INPUT DATA
% =================
% Example data to be entered externally  (e.g. restaurants_and_depots.lp)
% restaurant(1, 3).    % Restaurant 1 is located at position 3
% restaurant(2, 5).    % Restaurant 2 is located at position 5
% restaurant(3, 8).    % Restaurant 3 is located at position 8
% restaurant(4, 10).   % Restaurant 4 is located at position 10
% depots(2).           % Number of depots to select
% maxdist(10).         % Maximum allowed total distance
% #const depots = 2.	% Number of depots to select
% #const maxdist = 10.	% Maximum allowed total distance

% =================
% CMD LINE TO RUN
% =================
% clingo .\restaurants_and_depots.lp .\resource_planning.lp -t 4 -n 0 --warn no-operation-undefined
 
% =================
% HELPER PREDICATES
% =================
% Ground constants from input facts
depots_count(depots).
max_distance(maxdist).

% Calculate the absolute value of the difference between two positions
diff(PosA, PosB, Diff) :- restaurant(_, PosA), restaurant(_, PosB), PosA >= PosB, Diff = PosA - PosB.
diff(PosA, PosB, Diff) :- restaurant(_, PosA), restaurant(_, PosB), PosA < PosB, Diff = PosB - PosA.

% Distance between a restaurant and a chosen depot
dist(R, D, Distance) :- restaurant(R, PosR), restaurant(D, PosD), choose(D), diff(PosR, PosD, Distance). % Only consider chosen depots

% A restaurant is served by at least one depot
served_by_depot(R) :- restaurant(R, _), dist(R, _, _).

% Minimum distance from a restaurant to a chosen depot
min_dist(R, MinDist) :- restaurant(R, _), MinDist = #min { Distance : dist(R, D, Distance) }.

% Total sum of distances for all restaurants to their closest depot
total_distance(SumDist) :- SumDist = #sum { MinDist : restaurant(R, _), min_dist(R, MinDist) }.

% =================
% MAIN LOGIC
% =================
% Select exactly K depots
1 { choose(D) : restaurant(D, _) } K :- depots_count(K).

% =================
% CONSTRAINS
% =================
% Ensure every restaurant is served by at least one depot
:- restaurant(R, _), not served_by_depot(R).

% Enforce maximum allowed total distance
:- max_distance(Max), total_distance(SumDist), SumDist > Max.

% =================
% OUTPUT
% =================
#show choose/1.
#show total_distance/1.