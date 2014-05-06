function A = StructureTitanium( ImageLocation )

[~,A.name ] = fileparts( ImageLocation);

A.spatial.phase = double(round(imread( ImageLocation )./255));
[~,imnm,ext] = fileparts(ImageLocation);

shifts = [ eye(2) ];
A.spatial.edge = zeros( size(A.spatial.phase));

for ii = 1 : size(shifts,2)
A.spatial.edge(:) = or(A.spatial.edge, abs(A.spatial.phase + circshift(A.spatial.edge, shifts(ii,:))));
end

A.aggregate.fraction = mean(A.spatial.phase(:));
A.aggregate.ssa = mean(A.spatial.edge(:));


% This portion is necessary when importing raw data.  This requires the
% flickr toolbox is installed.
if ~strcmp( ImageLocation( 1:4 ), 'http')
    A.image = flickrGetImage( 'flickr.photos.search','Medium 640','text', sprintf('"%s"',imnm));
    A.link = flickrGetImage( 'flickr.photos.search','Original','text', sprintf('"%s"',imnm));
end


