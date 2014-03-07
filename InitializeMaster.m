function InitializeMaster

% soft link to the api and utility path
addpath( genpath( 'MATLAB' ));

fo = fopen( '.gitignore', 'w' );
fseek( fo, 0,'eof');
fprintf( fo, '\nMATLAB');
fprintf( fo, '\nInitializeMaster.m');
fprintf( fo, '\nGitHubSetUp.m');
fclose( fo );

