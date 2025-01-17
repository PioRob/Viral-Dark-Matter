function h = dpskdemod(varargin)
%DPSKDEMOD  DPSK Demodulator
%   H = MODEM.DPSKDEMOD(PROPERTY1, VALUE1, ...) constructs a DPSK demodulator
%   object H with properties as specified by PROPERTY/VALUE pairs.
%
%   H = MODEM.DPSKDEMOD(DPSKMOD_OBJECT) constructs a DPSK demodulator object H
%   by reading the property values from the DPSK modulator object
%   DPSKMOD_OBJECT. The properties that are unique to the DPSK demodulator
%   object are set to default values.
%
%   H = MODEM.DPSKDEMOD(DPSKMOD_OBJECT, PROPERTY1, VALUE1, ...) constructs a
%   DPSK demodulator object H by reading the property values from the DPSK
%   modulator object DPSKMOD_OBJECT. Additional properties are specified using
%   PROPERTY/VALUE pairs.
%
%   A DPSK demodulator object has following properties. All the properties are
%   writable except for the ones explicitly noted otherwise.
%
%   Type          - Type of modulation object ('DPSK Demodulator'). This
%                   property is not writable.
%   M             - Constellation size.
%   PhaseRotation - Specifies the phase rotation (rad) of the modulation.
%                   In this case, the total per-symbol phase shift is the
%                   sum of PhaseRotation and the phase generated by the
%                   differential modulation.  
%   Constellation - Ideal signal constellation. This property is not
%                   writable and is automatically computed based on M.
%   SymbolOrder   - Type of mapping employed for mapping symbols to ideal
%                   constellation points. The choices are: 
%                   'binary'          - Binary mapping
%                   'gray'            - Gray mapping 
%                   'user-defined'    - custom mapping
%   SymbolMapping - A list of integer values from 0 to M-1 that correspond to
%                   ideal constellation points. This property is writable only
%                   when SymbolOrder is set to 'user-defined'; otherwise it is
%                   automatically computed. 
%   OutputType    - Type of output to be computed by DPSK demodulator
%                   object. The choices are: 
%                   'bit'             - bit/binary output
%                   'integer'         - integer/symbol output
%   DecisionType  - Type of output values to be computed by DPSK demodulator
%                   object. This property is set to 'hard decision' and is
%                   not writable.
%   InitialPhase  - Initial phase state of the DPSK demodulator.  InitialPhase
%                   is used to calculate the first demodulated symbol.
%
%   H = MODEM.DPSKDEMOD constructs a DPSK demodulator object H with default
%   properties. It constructs a demodulator object for binary DPSK demodulation
%   and is equivalent to:
%   H = MODEM.DPSKDEMOD('M', 2, 'PHASEROTATION', 0, 'SYMBOLORDER', ...
%           'BINARY', 'OUTPUTTYPE', 'INTEGER', 'INITIALPHASE', 0)  
%
%   A DPSK demodulator object is equipped with four functions for inspection,
%   management, and simulation:
%     - DISP (type "help modem/disp" for detailed help)
%     - COPY (type "help modem/copy" for detailed help)
%     - DEMODULATE (type "help modem/demodulate" for detailed help)
%     - RESET (type "help modem/reset" for detailed help)
%
%   EXAMPLES:
%
%     % Construct a demodulator object for 4-DPSK demodulation with initial
%     % phase pi/4.
%     h = modem.dpskdemod('M', 4, 'InitialPhase', pi/4)
%
%     % Construct an object to compute hard bit decisions of a baseband signal
%     % using 16-DPSK modulation. The modulated signal has a minimum phase
%     % rotation of pi/8 per symbol.  The constellation has Gray mapping.  
%     h = modem.dpskdemod('M', 16, 'SymbolOrder', 'Gray', ...
%               'PhaseRotation', pi/8, 'OutputType', 'Bit') 
%
%     % Construct a demodulator object from an existing modulator object for
%     % DPSK modulation in order to make bit decision.
%     modObj = modem.dpskmod('M', 8, 'InputType', 'Bit') % existing DPSK
%                                                        % modulator object
%     demodObj = modem.dpskdemod(modObj)
%
%   See also MODEM, MODEM/TYPES, MODEM/DISP, MODEM/COPY, MODEM/DEMODULATE,
%   MODEM.DPSKMOD

%   @modem/@dpskdemod   

%   Copyright 2007-2008 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $  $Date: 2008/08/01 12:18:09 $

h = modem.dpskdemod;

% default prop values
h.Type = 'DPSK Demodulator';
h.M = 2;
setPrivProp(h, 'ProcessFunction', @demodulate_IntBin);

% Initialize based on the arguments
if nargin ~= 0
    if isa(varargin{1},'modem.dpskmod')
        % modem.dpskdemod(dpskmod_object, ...) form
        initFromObject(h, varargin{:});
    else
        initObject(h, varargin{:});
    end
end

%-------------------------------------------------------------------------------
% [EOF]
