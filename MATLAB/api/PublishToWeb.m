function PublishToWeb( issudo )

if ~exist( 'issudo', 'var')
    issudo = false;
end

if issudo 
    strstart = 'sudo ';
else
    strstart = '';
end

%% Create a README.md file for first commit

system(sprintf('%s git checkout gh-pages', strstart ) );
system(sprintf('%s git add _posts _data', strstart ) );
system(sprintf('%s git commit -m "Publishing dataset and dictionary pages"', strstart ) );
system(sprintf('%s git push origin gh-pages', strstart ) );
system(sprintf('%s git checkout master', strstart ) );

