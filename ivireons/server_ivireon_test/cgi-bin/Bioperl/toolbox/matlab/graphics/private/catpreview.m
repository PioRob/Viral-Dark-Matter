function catpreview(pj,epsFilename,tifFilename,preFilename)
%CATPREVIEW Creates an EPS/TIFF preview file.
%CATPREVIEW(PRINTOBJ,EPSFILENAME,TIFFFILENAME,PREFILENAME)
%   PRINTJOBOBJ  - Instance of printjob object
%   EPSFILENAME  - name of the EPS file
%   TIFFFILENAME - name of the TIFF preview file
%   PREFILENAME  - name of the resulting preview file
%   
%   Deletes the EPS and TIFF files when done unless PrintJob.DebugMode is true.

%   Copyright 1984-2005 The MathWorks, Inc. 
%   $Revision: 1.7.4.2 $  $Date: 2007/10/15 22:54:17 $

if ~exist(epsFilename, 'file')
    error('MATLAB:Print:catpreviewNoEPSFile', 'No EPS file to concatenate.' )
end
if ~exist(tifFilename, 'file')
    error('MATLAB:Print:catpreviewNoTIFFFile', 'No TIFF file to concatenate.' )
end

hdrFilename=LocMakeHeader(epsFilename,tifFilename);

pFID=fopen(preFilename,'w');
if pFID>0
    %Just checking that I could write to it, get rid of it.
    fclose(pFID);
    delete(preFilename)
    
    if isunix
      try
	[Status, result] = unix(['cat  "' hdrFilename '" "', ...  %#ok
		    epsFilename,'" "' tifFilename '" > "' preFilename ...
		    '"']);
      catch
	% Try unix with one argument if last call fails
	Status = unix(['cat  "' hdrFilename '" "', ... %#ok
		       epsFilename,'" "' tifFilename '" > "' preFilename ...
		       '"']);
	result = ''; %#ok
      end
    elseif strncmp(computer,'PC',2)
        [Status, result] = privdos( pj, ['copy /B "' hdrFilename '" +"', ...  %#ok
                epsFilename,'" /B +"' tifFilename '" "' preFilename '"']);
    end % if computer type
else
    error('MATLAB:Print:catpreviewFileError', 'Could not open file %s', preFilename)
end

if ~pj.DebugMode
    delete(epsFilename);
    delete(tifFilename);
    delete(hdrFilename);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function hdrFilename=LocMakeHeader(epsFilename,tifFilename)
%creates EPS preview header

epsCount=dir(epsFilename);
epsCount=epsCount.bytes;
tifCount=dir(tifFilename);
tifCount=tifCount.bytes;

epsHeader=[197 208 211 198 ...  %Header
      30 00 00 00 ... %PostScript file Start
      dec2pairs(epsCount) ... %PostScript length
      00 00 00 00 ... %Metafile start
      00 00 00 00 ... %Metafile length 
      dec2pairs(epsCount+30) ... %TIFF start
      dec2pairs(tifCount) ... %TIFF length
      255 255];  %footer

hdrFilename=[tempname '.hdr'];
hFID=fopen(hdrFilename,'w');
if hFID>0
   fwrite(hFID,epsHeader,'uchar');
   fclose(hFID);
else
   error('MATLAB:Print:catpreviewHeaderWriteError', 'Could not write header file to %s', hdrFilename);
end

%%%%%%%%%%%%%%%%%%%%%%%
function s=dec2pairs(d)
%converts Base10 decimal numbers to base 256 hex pairs
%note that this function flips the order of the resulting
%pairs.

base = 256;
nreq = ceil(log2(max(d) + 1)/log2(base)); 

n=4;
nreq = max(nreq,1);
n = max(n,nreq);
last = n - nreq + 1;

s(:,n) = rem(d,base);
while n ~= last
   n = n - 1;
   d = floor(d/base);
   s(:,n) = rem(d,base);
end

symbols=0:255;
s = reshape(symbols(s + 1),size(s));

%flip order
s=s(end:-1:1);
