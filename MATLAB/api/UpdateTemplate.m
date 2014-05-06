function UpdateTemplate(issudo)

if nargin == 0 || ~issudo
    strstart = '';
else
    strstart = 'sudo';
end

system(sprintf('%s git fetch upstream',strstart));
system(sprintf('%s git merge upstream/master',strstart));
system(sprintf('%s git commit -m "UpdateTemplate merged updates to the forked repo."',strstart));