function hh = trimesh(tri,varargin)
%TRIMESH Triangular mesh plot
%   TRIMESH(TRI,X,Y,Z,C) displays the triangles defined in the M-by-3
%   face matrix TRI as a mesh.  A row of TRI contains indexes into
%   the X,Y, and Z vertex vectors to define a single triangular face.
%   The edge color is defined by the vector C.
%
%   TRIMESH(TRI,X,Y,Z) uses C = Z, so color is proportional to surface
%   height.
%
%   TRIMESH(TRI,X,Y) displays the triangles in a 2-d plot.
%
%   TRIMESH(TR) displays the triangles in a TriRep - a Triangulation 
%   representation.
%
%   H = TRIMESH(...) returns a handle to the displayed triangles.
%
%   TRIMESH(...,'param','value','param','value'...) allows additional
%   patch param/value pairs to be used when creating the patch object. 
%
%   Example:
%
%       [x,y] = meshgrid(1:15,1:15);
%       tri = delaunay(x,y);
%       z = peaks(15);
%       trimesh(tri,x,y,z)
%
%       % Alternatively, if the surface is in the form of a TriRep
%       % a triangulation representation it may be plotted as follows;
%       tr = TriRep(tri, x(:), y(:), z(:))
%       trimesh(tr)
%
%   See also PATCH, TRISURF, DELAUNAY, DelaunayTri, TriRep.

%   Copyright 1984-2009 The MathWorks, Inc. 
%   $Revision: 1.18.4.5 $  $Date: 2009/10/24 19:18:40 $

ax = axescheck(varargin{:});
ax = newplot(ax);

if (nargin < 1)
     error(id('NotEnoughInputs'),'Not enough input arguments');
end

if ~(nargin == 1 && isa(tri, 'TriRep')) && (nargin == 3 || (nargin > 4 && ischar(varargin{3})))
  d = tri(:,[1 2 3 1])';
  x = varargin{1};
  y = varargin{2};
  if nargin == 3
    h = plot(ax, x(d), y(d));
  else
    z = varargin{3};  
    h = plot(ax, x(d), y(d),z,varargin{4},varargin{5:end});
  end
  if nargout == 1, hh = h; end
  return;
end

start = 1;

if (nargin == 1 && isa(tri, 'TriRep'))
     if tri.size(1) == 0
        error('MATLAB:triplot:EmptyTri',...
          'The triangulation is empty.');
     elseif tri.size(2) ~= 3
        error('MATLAB:triplot:NonTriangles',...
          'The triangulation must be composed of triangles.');
     elseif size(tri.X, 2) ~= 3
        error('MATLAB:triplot:NonPlanarTri',...
          'The triangulation must reside in 3D space.');
     end
     x = tri.X(:,1);
     y = tri.X(:,2);
     z = tri.X(:,3);
     trids = tri(:,:);
     if (nargin == 1) || rem(nargin,2)==1
       c = z;
     else
       c = varargin{1};
       start = 2;
     end
else
    x = varargin{1};
    y = varargin{2};
    z = varargin{3};
    trids = tri;
    if nargin>4 && rem(nargin-4,2)==1
      c = varargin{4};
      start = 5;
    elseif nargin<3
      error(id('NotEnoughInputs'),'Not enough input arguments');
    else
      start = 4;
      c = z;
    end
end
    
if ischar(get(ax,'color')),
  fc = get(gcf,'Color');
else
  fc = get(ax,'color');
end

h = patch('faces',trids,'vertices',[x(:) y(:) z(:)],'facevertexcdata',c(:),...
	  'facecolor',fc,'edgecolor',get(ax,'DefaultSurfaceFaceColor'),...
	  'facelighting', 'none', 'edgelighting', 'flat',...
      'parent',ax,...
	  varargin{start:end});
if ~ishold(ax), view(ax,3), grid(ax,'on'), end
if nargout == 1, hh = h; end

function str = id(str)
str = ['MATLAB:trimesh:' str];
