function b = genmcode(h, d)
%GENMCODE Generate MATLAB code

%   Author(s): J. Schickler
%   Copyright 1988-2009 The MathWorks, Inc.
%   $Revision: 1.1.4.8 $  $Date: 2010/01/25 22:49:49 $

b = sigcodegen.mcodebuffer;

[p,v] = abstract_genmcode(h, d);
p{end+1} = 'match';
v{end+1} = sprintf('''%s''', get(d, 'MatchExactly'));

b.addcr(b.formatparams(p,v));
b.cr;
b.addcr(designdesc(d));
b.addcr('h  = fdesign.bandpass(Fstop1, Fpass1, Fpass2, Fstop2, Astop1, Apass, Astop2%s);', getfsinput(d));
b.add('Hd = design(h, ''ellip'', ''MatchExactly'', match);');

% [EOF]
