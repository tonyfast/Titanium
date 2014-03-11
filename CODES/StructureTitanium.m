function A = StructureTitanium( ImageLocation )

[~,A.name ] = fileparts( ImageLocation);

A.spatial.phase = round(imread( ImageLocation )./255);
[~,imnm,ext] = fileparts(ImageLocation);

A.image = flickrGetImage( 'flickr.photos.search','Medium 640','text', sprintf('"%s"',imnm));   
A.link = flickrGetImage( 'flickr.photos.search','Original','text', sprintf('"%s"',imnm));

A.spatial.edge = double(edge( A.spatial.phase ));

A.aggregate.fraction = mean(A.spatial.phase(:));
A.aggregate.ssa = mean(A.spatial.edge(:));

