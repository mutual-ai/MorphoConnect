function Y = SurfStatReadData1( filename )

%Reads data (e.g. thickness) from a single .txt or FreeSurfer file. 
%
% Usage: Y = SurfStatReadTxt( filename );
%
% filename = .txt or FS file name, either new version binary or ASCII. 
%
% Y = 1 x v vector of data, v=#vertices.

[pathstr,name,ext] = fileparts(filename);
if strcmp(ext,'.txt')
    % It's a .txt file
    fid=fopen(filename);
    Y=fscanf(fid,'%f')';
else
    % Assume it's a FreeSurfer file    
    % Assume it's a binary file
    fid = fopen(filename, 'rb', 'b') ;
    b1 = fread(fid, 1, 'uchar') ;
    b2 = fread(fid, 1, 'uchar') ;
    b3 = fread(fid, 1, 'uchar') ;
    magic = bitshift(b1, 16) + bitshift(b2,8) + b3 ;
    if magic==16777215
	    v = fread(fid, 1, 'int32') ;
	    t = fread(fid, 1, 'int32') ;
	    k = fread(fid, 1, 'int32') ;
        Y = fread(fid, [k v], 'float') ; 	   	
    else
        % Assume it's an ASCII file
        fclose(fid);
        fid = fopen(filename, 'r') ;
        v = fscanf(fid, '%d', 1);
        all = fscanf(fid, '%d %f %f %f %f\n', [5 v]) ;
        Y = all(5, :) ;
    end
end
fclose(fid) ;
    
return
end


