%==========================================================================
% 
%  BME 60B, Fangyuan Ding, MWF 4:00 - 4:50pm
%  
%  Sandbox Project
%
%  Group 12:
%  Kentstar Samuel Harsono, 
%  Eric Hyun Kim, 
%  Tair Kuzhekov, 
%  Elian Martin Sian Lintag
% 
%  Description:
%  make a gui of a concert venue
%  can navigate through sections and choose specific seats to reserve
%  code has logic to recommend "best seats"
%       budget: cheapest and keeps party together (seats adjacent)
%       luxury: closest to stage, central, and keeps party together
% 
%==========================================================================

clear 
close all
clc

% modifiable game values
rows = 10;
cols = 10;
numMines = 20;

% initialize game engine
engine = mineEngine(rows, cols, numMines);
