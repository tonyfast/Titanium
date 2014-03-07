function TestSite

system('git checkout gh-pages');


disp( sprintf('<a href="localhost:4000%s/">Test Site</a>', getfield( ReadYaml( '_config.yml'), 'baseurl')) );
system( 'jekyll serve');