function h5writeattcompound( fn, dset, attname, DATA )
% An improved version of the matlab function h5write.   Natively, h5write lacks the
% ability to write structures to HDF5 files.
%
% INPUTS:
% fn - file name where the data is written to.
% dset - name of the dataset in the HDF5 that the data is being stored as
% DATA - allows structures are all h5write native datatypes to be written.
%        if DATA is a structure then the information is written as a
%        compound datatype.  The size of each field should be the same.

if isstruct( DATA )
    if exist( fn, 'file')
        fo = H5F.open(fn,'H5F_ACC_RDWR','H5P_DEFAULT');
    else
        fo = H5F.create(fn);
    end
    fields = fieldnames(DATA);
    sz = size( getfield( DATA, fields{1}));
    tid = H5T.create('H5T_COMPOUND',numel(fields)*8);
    
    ii = 1;
    H5T.insert(tid,fields{ii},(ii-1)*8,'H5T_NATIVE_DOUBLE');
    ii = 2;
    strType = H5T.copy( 'H5T_C_S1' );
    H5T.set_size(strType, numel(getfield( DATA, fields{ii})) );
    %     DATA = setfield( DATA, fields{ii}, getfield( DATA, fields{ii} ) );
    
    H5T.insert(tid,fields{ii},(ii-1)*8,strType);
    
    sid = H5S.create_simple( numel(sz), fliplr(sz), fliplr(sz) );
    %     dset = horzcat(dset, num2str(round(rand(1)*1e5)));
    did = H5D.open( fo, dset);
    aid = H5A.create( did, attname, tid, sid, H5P.create('H5P_ATTRIBUTE_CREATE'));
    H5A.write( aid, tid, DATA );
    H5A.close(aid)
    H5S.close(sid)
    H5D.close(did)
    
    H5T.close(tid)
    H5F.close(fo);
elseif ischar(DATA)
    
    if exist( fn, 'file')
        fo = H5F.open(fn,'H5F_ACC_RDWR','H5P_DEFAULT');
    else
        fo = H5F.create(fn);
    end
    SDIM = size(DATA,2);
    filetype = H5T.copy ('H5T_FORTRAN_S1');
    H5T.set_size (filetype, SDIM );
    memtype = H5T.copy ('H5T_C_S1');
    H5T.set_size (memtype, SDIM );
    
    % Create dataspace.  Setting maximum size to [] sets the maximum
    % size to be the current size.
    %
    dims = size(DATA,1);
    space = H5S.create_simple (1,fliplr( dims), []);
    
    %
    % Create the attribute and write the string data to it.
    %
    
    if strcmp( dset, '/');
        attr = H5A.create (fo, attname, filetype, space, 'H5P_DEFAULT');
        H5A.write (attr, memtype, DATA');
        
    else
    did = H5D.open( fo, dset );
        attr = H5A.create (fo, attname, filetype, space, 'H5P_DEFAULT');
        H5A.write (attr, memtype, DATA');
        H5D.close (did);
    end
    
    %
    % Close and release resources.
    %
    H5A.close (attr);
    
    H5S.close (space);
    H5T.close (filetype);
    H5T.close (memtype);
    H5F.close ( fo );
    
    
else
    h5writeatt( fn,dset, attname, DATA);
end

end