function h5CreateGroup( filename, groupname );

if exist( filename, 'file')
    fo = H5F.open(filename,'H5F_ACC_RDWR','H5P_DEFAULT');
else
    fo = H5F.create(filename);
end

gid = H5G.create( fo, groupname, 'H5P_DEFAULT','H5P_DEFAULT','H5P_DEFAULT');
H5G.close(gid)
H5F.close(fo);