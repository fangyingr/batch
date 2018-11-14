% readNihonKodenM00 - reads Nihon Koden .m00 text files.
%
% Usage  : [output,srate,scale] = readNihonKodenM00(input);
%
% Inputs : path to the Nihon Koden .m00 text file
% 
% Outputs: Matlab variable in channels x timepoints, sampling rate, and
%          amplitude scale. If 'scale' is 1, no need to rescale the data. If
%          'scale'~=1, rescale the data by the factor of 'scale'. 

% History:
% 09/10/2018 ver 1.02 by Brian Silverstein. Added parsing of channel labels
% in second line.s
% 02/01/2017 ver 1.01 by Makoto. C = strsplit(firstLine, ' '); has raw vector.
% 07/17/2013 ver 1.00 by Makoto. Created for my collaboration with Eishi Asano.


% Copyright (C) 2013 Makoto Miyakoshi SCCN,INC,UCSD
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General PublIC LICense as published by
% the Free Software Foundation; either version 2 of the LICense, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General PublIC LICense for more details.
%
% You should have received a copy of the GNU General PublIC LICense
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1.07  USA

function [output,srate,scale,chanlabels] = readNihonKodenM00(input)

% open the file
FID = fopen(input);

% skip the first two lines
firstLine  = fgetl(FID);
secondLine = fgetl(FID);

% Parse header info in the first line.
C = strsplit(firstLine, ' ');
if     size(C,1)==6 & size(C,2)==1
    timePnts = str2num(C{1,1}(12:end));             % 12 letters are 'TimePoints='
    numChans = str2num(C{2,1}(10:end));             % 10 letters are 'Channels='
    srate    = round(1000/str2num(C{4,1}(22:end))); % 22 letters are 'SamplingInterval[ms]='
    scale    = str2num(C{5,1}(9:end));              % 9  letters are 'Bins/uV='  
    
elseif size(C,1)==1 & size(C,2)==6 % New pattern confirmed in 2016. Depends on which strsplit() is used.
    timePnts = str2num(C{1,1}(12:end));             % 12 letters are 'TimePoints='
    numChans = str2num(C{1,2}(10:end));             % 10 letters are 'Channels='
    srate    = round(1000/str2num(C{1,4}(22:end))); % 22 letters are 'SamplingInterval[ms]='
    scale    = str2num(C{1,5}(9:end));              % 9  letters are 'Bins/uV='
end

% Parse header info in the second line.
C = strsplit(secondLine, ' ');
if ~isempty(str2double(C{2}))                       % Check to make sure the second line contains strings, not numbers.
    chanlabels=C(2:end);                            % Line starts with a space, so labels will start in second cell.
end

% parse data structure
tmpData = fscanf(FID, '%f');
fclose(FID);

% check consistency between header info and actual data size
if size(tmpData,1) ~= numChans*timePnts;
    warning('Data size does not match header information. Check consistency.')
end

% reshape the data for finalizing
output = reshape(tmpData, [numChans timePnts]);