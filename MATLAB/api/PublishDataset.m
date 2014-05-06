function PublishDataset( YAML )

t = clock;
datapage = sprintf( '%i-%0.2i-%0.2i-%s.markdown',t(1),t(2),t(3),YAML.title);
WriteYaml(  horzcat(YAML.title,'.yml'), YAML );

system( 'git checkout gh-pages')
fo = fopen( fullfile( '_posts', datapage ),'w' );
fprintf( fo, '---\n');
s = fileread( horzcat(YAML.title,'.yml') );
fprintf( fo,'%s', s );
fprintf( fo, '---\n');
fclose(fo)

system( sprintf( 'git add %s', fullfile( '_posts', datapage )) )
system( sprintf( 'git commit -m "Added dataset %s"', fullfile( '_posts', datapage )) )
system( 'git checkout master')