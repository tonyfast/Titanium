function YAML = createDataset( filename );
% H5 is an output structure from h5info'
% YAML is an output structure from ReadYAML'
% Dictionary information is attached with a separate function
H5 = h5info( filename );
YAML = struct( 'layout','dataset');
[~,YAML.title,~] = fileparts(filename);
YAML.description = [];


cc = {'Groups' 'Groups'};
for ii = 1 : numel( H5.Groups)
    % This loop indexes the datasets
    
    dsetname = H5.Groups(ii).Name; %dataset name
    
    for dd = 1 : numel( H5.Groups(ii).Datasets );
        % Whether the dataset can be queried will be a file option in the
        % converter
        field = H5.Groups(ii).Datasets(dd).Name;
        switch field
            % The index is on the number of datasets
            case {'aggregate','Aggregate'}
                
                    [ YAML.aggregate{ii}.name YAML.aggregate{ii}.native ] = ...
                        deal( dsetname(2:end) );
               
                YAML.aggregate{ii}.description = [];
                
                if numel( fieldnames(YAML.aggregate{ii}) )==0 dsetid = 0;
                else dsetid = numel(YAML.aggregate{ii}); end
                % Read the aggregate values here
                
                data = h5read( filename,strjoin( {dsetname, field},'/'));
                for mm = 1 : numel(H5.Groups(ii).Datasets(dd).Datatype.Type.Member);
                    YAML.aggregate{ii}.output{mm}.native = ...
                        H5.Groups(ii).Datasets(dd).Datatype.Type.Member(mm).Name;
                    YAML.aggregate{ii}.output{mm}.value = ...
                        getfield( data, YAML.aggregate{ii}.output{mm}.native );
                end
            case {'spatial','Spatial'}
                    [ YAML.spatial{ii}.name YAML.spatial{ii}.native ] = ...
                        deal( dsetname(2:end) );
                YAML.spatial{ii}.description = [];
                
                for mm = 1 : numel(H5.Groups(ii).Datasets(dd).Datatype.Type.Member);
                    YAML.spatial{ii}.output{mm}.native = ...
                        H5.Groups(ii).Datasets(dd).Datatype.Type.Member(mm).Name;
                end
                
                if numel( H5.Groups(ii).Datasets(dd).Attributes) > 0
                    
                    for mm = 1: numel( H5.Groups(ii).Datasets(dd).Attributes)
                        switch H5.Groups(ii).Datasets(dd).Attributes(mm).Name
                            case 'link'
                                YAML.spatial{ii}.location = ...
                                    H5.Groups(ii).Datasets(dd).Attributes(mm).Value;
                            case 'image'
                               
                                urls = strsplit( H5.Groups(ii).Datasets(dd).Attributes(mm).Value, ';');                                
                                for qq = 1 : numel( urls )
                                YAML.spatial{ii}.viz{qq}.url = ...
                                    urls{qq};
                                YAML.spatial{ii}.viz{qq}.name = ...
                                    '';
                                end
                        end
                    end
                end
        end
    end
    
    % cycle through additional workflows
    for gg = 1 : numel( H5.Groups(ii).Groups );
        dsetname = H5.Groups(ii).Groups(gg).Name; %dataset name
        for dd = 1 : numel( H5.Groups(ii).Groups(gg).Datasets );
            % Whether the dataset can be queried will be a file option in the
            % converter
            field = H5.Groups(ii).Groups(gg).Datasets(dd).Name;
            switch field
                % The index is on the number of datasets
                case {'aggregate','Aggregate'}
                    if ~isfield(YAML.aggregate{ii},'workflow') || ...
                            numel( fieldnames(YAML.aggregate{ii}.workflow{gg}) )==0 dsetid = 0;
                    else dsetid = numel(YAML.aggregate{ii}.workflow{gg}); end
                    dsetid = dsetid+1;
                    
                    if ~isfield( YAML.aggregate{ii}, 'workflow' )
                        [ YAML.aggregate{ii}.workflow{dsetid}.name YAML.aggregate{ii}.workflow{dsetid}.native ] = ...
                            deal( dsetname(2:end) );
                    end
                    YAML.aggregate{ii}.workflow{dsetid}.description = [];
                    
                    
                    
                    data = h5read( filename,strjoin( {dsetname, field},'/'));
                    for mm = 1 : numel(H5.Groups(ii).Groups(gg).Datasets(dd).Datatype.Type.Member);
                        YAML.aggregate{ii}.workflow{dsetid}.output{mm}.native = ...
                            H5.Groups(ii).Groups(gg).Datasets(dd).Datatype.Type.Member(mm).Name;
                        YAML.aggregate{ii}.workflow{dsetid}.output{mm}.value = ...
                            getfield( data, YAML.aggregate{ii}.workflow{dsetid}.output{mm}.native );
                    end
                case {'spatial','Spatial'}
                    if ~isfield(YAML.spatial{ii},'workflow') || ...
                            numel( fieldnames(YAML.spatial{ii}.workflow{gg}) )==0 dsetid = 0;
                    else dsetid = numel(YAML.spatial{ii}.workflow{gg}); end
                    dsetid = dsetid+1;
                    
                    if ~isfield( YAML.spatial{ii}, 'worflow' )
                        [ YAML.spatial{ii}.workflow{dsetid}.name YAML.spatial{ii}.workflow{dsetid}.native ] = ...
                            deal( dsetname(2:end) );
                    end
                    YAML.spatial{ii}.workflow{dsetid}.description = [];
                    if numel( fieldnames(YAML.spatial{ii}.workflow{dsetid}) )==0 dsetid = 0;
                    else dsetid = numel(YAML.spatial{ii}.workflow{dsetid}); end
                    
                    for mm = 1 : numel(H5.Groups(ii).Datasets(dd).Datatype.Type.Member);
                        YAML.spatial{ii}.workflow{dsetid}.output{mm}.native = ...
                            H5.Groups(ii).Datasets(dd).Datatype.Type.Member(mm).Name;
                    end
            end
        end
    end
    
    for aa = 1 : numel( H5.Groups(ii).Attributes )
        field = H5.Groups(ii).Attributes(aa).Name;
        switch field
            case 'location'
                YAML.location = H5.Groups(ii).Attributes(aa).Value;
        end
    end
end

