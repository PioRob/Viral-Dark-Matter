function movie(varargin)
%MOVIE  Play recorded movie frames.
%   MOVIE(M) plays the movie in matrix M once, using the current axes
%   as the default target. To play the movie in the figure instead of
%   the axes, specify the figure handle (or gcf) as the first
%   argument: movie(figure_handle,...). M must be an array of movie
%   frames (usually from getframe).
%   MOVIE(M,N) plays the movie N times. If N is negative, each
%   "play" is once forward and once backward. If N is a vector,
%   the first element is the number of times to play the movie and
%   the remaining elements comprise a list of frames to play
%   in the movie. For example, if M has four frames then
%   N = [10 4 4 2 1] plays the movie ten times, and the movie
%   consists of frame 4 followed by frame 4 again, followed by
%   frame 2 and finally frame 1.
%   MOVIE(M,N,FPS) plays the movie at FPS frames per second. The
%   default if FPS is omitted is 12 frames per second. Machines
%   that can't achieve the specified FPS play as fast as they can.
%
%   MOVIE(H,...) plays the movie in object H, where H is a handle
%   to a figure, or an axis.
%   MOVIE(H,M,N,FPS,LOC) specifies the location to play the movie
%   at, relative to the lower-left corner of object H and in
%   pixels, regardless of the value of the object's Units property.
%   LOC = [X Y unused unused].  LOC is a 4-element position
%   vector, of which only the X and Y coordinates are used (the
%   movie plays back using the width and height in which it was
%   recorded).  All four elements are required, however.
%
%   See also GETFRAME, IM2FRAME, FRAME2IM, AVIFILE.

%   Copyright 1984-2009 The MathWorks, Inc.
%   $Revision: 5.12.4.4 $  $Date: 2009/12/28 04:18:29 $


% First we check whether Handle Graphics uses MATLAB classes
    isHGUsingMATLABClasses = feature('HGUsingMATLABClasses');
    
    if isHGUsingMATLABClasses
        movieHGUsingMATLABClasses(varargin{:});
    else
        % Call the built-in implementation
        builtin('hgMovie',varargin{:});
    end
    
