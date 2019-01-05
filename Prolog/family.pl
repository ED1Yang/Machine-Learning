/* -*-Assignment 2, Machine Learning-*- */
% Part 2: Prolog Predicates for Logic Problems

% 1. Family Problems

motherOf(Mother,Person) :- childOf(Person,Mother),female(Mother).
sisterOf(Sister,Person) :- childOf(Sister,Parent),childOf(Person,Parent),female(Sister).


% ----------------------------------------------------------------------------------------

% 2. Tree Problems

% I write a helper predicates called superNodeOf(X,Y) which indicates that X is the supernode of Y.

% superNodeOf(X,Y) means that X is the superNode of Y. 

superNodeOf(X,Y) :- parentOf(X,Y). % Basecase.
superNodeOf(X,Y) :- parentOf(X,A), superNodeOf(A,Y).

inSameTree(X,X). % specialcase.
inSameTree(X,Y) :- superNodeOf(X,Y);superNodeOf(Y,X). % X or Y is the direct supernode of the other.
inSameTree(X,Y) :- superNodeOf(A,X),superNodeOf(A,Y). % X and Y share a common superNode.



