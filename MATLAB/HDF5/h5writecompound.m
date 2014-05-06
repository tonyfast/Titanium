function h5writecompound( fn, dset, DATA )
% An improved version of the matlab function h5write.   Natively, h5write lacks the
% ability to write structures to HDF5 files.
%
% INPUTS:
% fn - file name where the data is written to.
% dset - name of the dataset in the HDF5 that the data is being stored as
% DATA - allows structures are all h5write native datatypes to be written.
%        if DATA is a structure then the information is written as a
%        compound datatype.  The size of each field should be the same.


flds = fieldnames( DATA );
for ii = 1 : numel( flds )
    switch class( getfield( DATA, flds{ii} ) )
        case 'int8'
            hdftype{ii} = 'H5T_STD_I8LE';
            hdfbyte(ii) = 1;
        case 'int16'
            hdftype{ii} = 'H5T_STD_I16LE';
            hdfbyte(ii) = 2;
        case 'int32'
            hdftype{ii} = 'H5T_STD_I32LE';
            hdfbyte(ii) = 4;
        case 'uint8'
            hdftype{ii} = 'H5T_STD_I8LE';
            hdfbyte(ii) = 1;
        case 'int16'
            hdftype{ii} = 'H5T_STD_I16LE';
            hdfbyte(ii) = 2;
        case 'uint32'
            hdftype{ii} = 'H5T_STD_U32LE';
            hdfbyte(ii) = 4;
        otherwise
            hdftype{ii} = 'H5T_NATIVE_DOUBLE';
            hdfbyte(ii) = 8;
    end
end

cumhdfbyte = [0 , cumsum(hdfbyte)];


if isstruct( DATA )
    if exist( fn, 'file')
        fo = H5F.open(fn,'H5F_ACC_RDWR','H5P_DEFAULT');
    else
        fo = H5F.create(fn);
    end
    fields = fieldnames(DATA);
    sz = size( getfield( DATA, fields{1}));
    tid = H5T.create('H5T_COMPOUND', sum(hdfbyte));
    for ii = 1 : numel( fields )
        
        H5T.insert(tid,fields{ii},cumhdfbyte(ii),hdftype{ii});
        if ~all( sz == size( getfield( DATA, fields{ii})))
            error('The size of the elements in the data structure must be the same.  The data was not written.')
            H5T.close(tid)
            H5F.close(fo);
        end
    end
    
    sid = H5S.create_simple( numel(sz), fliplr(sz), fliplr(sz) );
    %     dset = horzcat(dset, num2str(round(rand(1)*1e5)));
    dset
    did = H5D.create( fo, dset, tid, sid, 'H5P_DEFAULT');
    H5D.write( did, tid, 'H5S_ALL', 'H5S_ALL', 'H5P_DEFAULT', DATA );
    H5D.close(did)
    H5S.close(sid)
    
else
    h5create( fn,dset, DATA, size(DATA) );
end

end