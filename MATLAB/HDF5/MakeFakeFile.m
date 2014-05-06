hh = 'something.h5';
delete(hh);
nms = {'/Dataset1/aggregate','/Dataset1/spatial','/Dataset1/Workflow1/aggregate', ...
    '/Dataset2/aggregate','/Dataset2/spatial','/Dataset2/Workflow1/aggregate','/Dataset2/Workflow2/spatial'};

for dd = 1 : numel(nms);
    dset = nms{dd};
    if ~exist( hh,'file');
        fo = H5F.create(hh);
    else
        fo = H5F.open(hh,'H5F_ACC_RDWR','H5P_DEFAULT');
    end
    
    try
    gid=H5G.create(fo,fileparts(dset),'H5P_DEFAULT','H5P_DEFAULT','H5P_DEFAULT');H5G.close(gid);
    s.link = 'http://www.theinternet.com';
    h5writeatt( hh, fileparts(dset), 'location',s.link );
    catch
        disp('group exists')
    end
    H5F.close(fo);
%     h5create(hh,dset,[1 1]);
    S = struct('Var1',rand(1),'Huh',rand(1),'Pressure',rand(1));
    h5writecompound( hh, nms{dd}, S);
  
end