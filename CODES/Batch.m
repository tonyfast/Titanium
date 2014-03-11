prefix = '23_750X';
h5out = horzcat(prefix,'.h5');
imdir = '~/Dropbox/Collaborations/Dave Brough/Data/BW_HT/';
files = dir( fullfile(imdir,horzcat(prefix,'*')) );
clear data
for ii = 1 : numel(files)
imagelocation = fullfile( imdir,sprintf('%s',files(ii).name));
data{ii} = StructureTitanium( imagelocation );
end

StructureData( h5out, data, false );
dictname = 'segmented-titanium';
YAML = createDataset( h5out );
YAML.dict = dictname;
PublishDataset( YAML );

AttachDictionary( YAML, [], dictname );

%%
