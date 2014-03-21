%% Download Tony Fast's Spatial Statistics Tools

issudo = '';

if ~isdir( './Spatial_Statistics/' )
    system(sprintf('%s git clone https://github.com/tonyfast/Spatial_Statistics.git', issudo) );
end
addpath(genpath('./Spatial_Statistics/'));


%% Use Mark Tygert's Randomized PCA algorithm.
% Spatial statistics provide a large number of features that are limiting
% to most PCA codes.  I like this one and this script will download it.

if ~isdir( './pca/' )
    mkdir('./pca');
    urlwrite('https://raw.github.com/ryotat/dal/master/pca.m','./pca/pca.m')
end
addpath('./pca');

addpath(genpath('./MATLAB'))
addpath(genpath('./CODES'))

%%

% Read the names of the post files in the gh-pages branch
system( 'git checkout gh-pages');
[~,postnames] = system( 'git ls-files _posts/');
postnames = strsplit(postnames); % Cover string output to cells
system( 'git checkout master');

%% Read post information

ct = 0;
for ii = 1 : numel( postnames )
    if numel( postnames{ii}) > 0
    system( sprintf( 'git checkout gh-pages %s', postnames{ii} ) );
    contents = fileread(postnames{ii});
    contents = regexprep( contents, '---','');
    fo = fopen(postnames{ii},'w');
    fprintf(fo, '%s\n',contents)
    fclose(fo);
    postml = ReadYaml( postnames{ii} );
    if strcmp( postml.layout, 'dataset' )
        for jj = 1 : numel( postml.spatial )
            ct = ct +  1;
            MetaData{ct}.url = postml.spatial{jj}.viz{1}.url ;
            MetaData{ct}.name = postml.spatial{jj}.name ;
         
        end
    end
    system( sprintf( 'git reset HEAD %s', postnames{ii} ) );
    end
end

%% Download flickr images

for ii = 1 : numel( MetaData );
    A = StructureTitanium( MetaData{ii}.url);
    Stats = SpatialStatsFFT( A.spatial.phase, [],'display',false, 'cutoff',100);
    if ii == 1
        Feature = zeros( numel( MetaData ), numel(Stats) );
    end
    Feature(ii,:) = Stats(:);
end

%% Principal Component Analysis using SVD
[ U S V ] = pca( bsxfun( @minus, Feature, mean(Feature,1)));

classnames =  cellfun( @(x)strtok( x.name, '_'), MetaData, 'UniformOutput', false );
[uniquenames, ~, nameid] = unique( classnames );

co = cbrewer( 'qual','Paired',20);
%% Local Visualization
for ii = 1 : max(nameid)
    
    b = nameid == ii;
    plot( U(b,1), U(b,2), 'ko','MarkerFacecolor',co(ii,:),'Markersize',16);
    
    if ii == 1
        hold on;
    end
end
hold off;
legend( uniquenames, 'Location','Best');
axis square
grid on
xlabel('First Principal Component Direction');
ylabel('Second Principal Component Direction');


%% Create a plot.ly visualization of the data

for ii = 1 : max(nameid)
    b = nameid == ii;
    plotdata{ii}.x = U(b,1);
    plotdata{ii}.y = U(b,2);
    plotdata{ii}.name = uniquenames{ii};
    plotdata{ii}.line = struct('width',0,'color','');
    plotdata{ii}.marker = struct('opacity',.9, ...
        'symbol','circle', ...
        'size',16, ...
        'color', sprintf('rgb(%i,%i,%i)',co(ii,:)*255), ...
        'line', struct('width',3,'color','black') );
end
% Compute spatial statistics 
% Visualize them


layout = struct( 'showlegend' , true, ...
    'xaxis' , struct( 'title', 'First Principal Components',...
        'autorange' , true ), ...
    'yaxis' , struct( 'title', 'Second Principal Components',...
        'autorange' , true ) ...
);

% response = plotly( plotdata, struct('layout',layout) );