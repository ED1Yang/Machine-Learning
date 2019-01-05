/* Assignment 2, Machine Learning. 
Part 3: Search as Problem Solving. 

For this exercise, I add a node to the closed list at the same time as adding to the open list. 
In this way when a new node is generated, I will check the closed list, 
and it will be classified as duplicated if it's already on the list.
*/

    :- consult(counter).
    :- consult(eightPuzzle).
    :- consult(queues).

    :- dynamic closed/3.

/* ---------------------------------------- */
% main:
	breadthFirstSearch(InitialState,Solution,Statistics) :- 
		bfs(InitialState,Solution,Statistics).
/* ---------------------------------------- */
% 1. 8-puzzle Domain.

    bfs(InitialState,Solution,Statistics) :-
        
        % defind and set counters to 0:
        G_Value = 0,
        initialiseCounter(_,generated),
        initialiseCounter(_,expanded),
        initialiseCounter(_,duplicated),
        
        % define and set closed list to empty:
        retractall(closed(_,_,_)),

        % put the InitialState into closed list.
        assert(closed(InitialState,[],0)),
        
        % make a empty queue for the openlist:
        make_queue(Q),

        % recursion until reach the goal.
        bfs_aux(InitialState,Solution,Statistics,Q,G_Value).
    
    % -------------------------------------

    % aux cases:

    % base case: when the goal is reached.  
        bfs_aux(State, Solution, Statistics,_,G_Value) :-
            goal8(State),

            % some extra content:
            write("Hi, you will need "),
            write(G_Value),
            write(" steps to reach the goal. And here is the solution and statistics for each step:"),

            % get the solution path:
            backTrack(State,[State],[_|Solution]),

            % get the Statistics of each step: 
            getStat(G_Value,[],Statistics).

    % -------------------------------------     
    % Recurisive case:
        bfs_aux(State,Solution,Statistics,OpenList,G_Value) :-

            % Get all the successors of the current state(Parent), and store them into a queue(OpenList). 
            succ8(State,Successors),
            plus(1,G_Value,Next_G_Value),
            getSuccQ(Successors,OpenList,New_OpenList,State,Next_G_Value),

            % Remove the first element(Current State) from the OpenList.
            serve_queue(New_OpenList,New_State,New_OpenList1),

            % Get the g value of the new state.
            closed(New_State,_,G_Value_ofNewState),

            % Then do it recursively to the following states: 
            bfs_aux(New_State,Solution,Statistics,New_OpenList1,G_Value_ofNewState).

 
/* ---------------------------------------- */
% 2. Get successors queue

    % Method to put all the successors from a tuple to a queue. 
        getSuccQ([],OldQ,OldQ,_,_). % Case when there is no successor left. 
        getSuccQ([(_,Succ)|Remaining],OldQ,NewQ,Parent,G_Value) :- 
            % Since a new successor is generated, its count should add one: (generated++)
            incrementCounter(G_Value,generated),

            % if
            not(closed(Succ,_,_)) ->

            % then (add the successor of the current state to closed list and queue)
            assert(closed(Succ,Parent,G_Value)),
            join_queue(Succ,OldQ,NewQ1),
            getSuccQ(Remaining,NewQ1,NewQ,Parent,G_Value),
            % Now this successor is expanded to the next level, its count should add one: (expanded++)
            incrementCounter(G_Value,expanded);

            % else (skip to the next turn)
            % If the successsor is found in the closed list, then it will be classified as duplicated: (duplicated++)
            incrementCounter(G_Value,duplicated),
            getSuccQ(Remaining,OldQ,NewQ,Parent,G_Value).
	


/* ---------------------------------------- */
% 3.Solution: Back track from the goal: 

    % base case: when the backtrack reach the top:
        backTrack([],Solution,Solution). 
    
    % recursive case:
        backTrack(State,Track,TrackResult) :-
            closed(State,Parent,_),
            append([Parent],Track,Result),
            backTrack(Parent,Result,TrackResult).

/* ---------------------------------------- */
% 4. Statistics:
    % base case:
        getStat(G_Value,Stat,Stat) :-
            G_Value < 0.

    % recursive case:
        getStat(G_Value,Stat,New_Stat) :-
            getValueCounter(G_Value,generated,Generated),
            getValueCounter(G_Value,duplicated,Duplicated),
            getValueCounter(G_Value,expanded,Expanded),
            
            append([stat(G_Value,Generated,Duplicated,Expanded)],Stat,Stat1),
            
            Next_G is G_Value - 1,
            getStat(Next_G,Stat1,New_Stat).
    
            
	
	
	


	
	