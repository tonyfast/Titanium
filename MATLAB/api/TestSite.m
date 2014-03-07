function TestSite

system('git checkout gh-pages');


disp( sprintf('Go to http://localhost:4000%s/ to test the site.', getfield( ReadYaml( '_config.yml'), 'baseurl')) );
system( 'jekyll serve');