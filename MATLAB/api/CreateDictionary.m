function [dict] = createDictionary( YAML, workflow, dictionary )
% if workflow is empty then work on the raw
% dict goes in the top level of YAML
%
% if workflow has a value then look for the workflow name
% Dictionary needs to output a structure that can write YAML to make the
% dictionary
% 
% You can loop over this function is you have heterogenous outputs.

persistent spatialvars aggregatevars

if numel( workflow ) == 0;
    cc = {'output'};
    israw = true;
else
    cc = {'workflow', 'output'};
    israw = false;
end

if numel( spatialvars ) == 0 spatialvars = cell(0); end
if numel( aggregatevars ) == 0 aggregatevars = cell(0); end

% read the native variable names from a YAML structure
%%
if israw
    for ii = 1 : numel( YAML.aggregate )
        for jj = 1 : numel( YAML.aggregate{ii}.output )
            aggregatevars = union( aggregatevars, YAML.aggregate{ii}.output{jj}.native );
        end
    end
    for ii = 1 : numel( YAML.spatial )
        for jj = 1 : numel( YAML.spatial{ii}.output )
            spatialvars = union( spatialvars, YAML.spatial{ii}.output{jj}.native );
        end
    end
else
    
    for ii = 1 : numel( YAML.aggregate )
        if isfield( YAML.aggregate{ii}, 'workflow' )
            for jj = 1 : numel( YAML.aggregate{ii}.workflow )
                wf = fliplr( strtok( fliplr( YAML.aggregate{ii}.workflow{jj}.native ), '/' ) );
                if strcmp( wf, workflow )
                    for kk = 1 : numel( YAML.aggregate{ii}.workflow{jj}.output )
                        aggregatevars = union( aggregatevars, YAML.aggregate{ii}.workflow{jj}.output{kk}.native );
                    end
                end
            end
        end
    end
    
        if isfield( YAML.spatial{ii}, 'workflow' )
            for jj = 1 : numel( YAML.spatial{ii}.workflow )
                wf = fliplr( strtok( fliplr( YAML.spatial{ii}.workflow{jj}.native ), '/' ) );
                if strcmp( wf, workflow )
                    for kk = 1 : numel( YAML.spatial{ii}.workflow{jj}.output )
                        spatialvars = union( spatialvars, YAML.spatial{ii}.workflow{jj}.output{kk}.native );
                    end
                end
            end
        end
end

assignin( 'base','spatialvars',spatialvars);
assignin( 'base','aggregatevars',aggregatevars);

%%
% Create dictionary YAML Matlab Structure

if numel( aggregatevars ) > 0 |  numel( spatialvars ) > 0
    dict.name = dictionary;
    dict.description = '';
    dict.layout = 'dictionary';
end

if numel( aggregatevars ) > 0
    % Create a default group
    dict.aggregate{1}.group{1}=struct(...
            'name','DEFAULT', ...
            'description','',...
            'links',struct( 'url','','name','') ...
            );
    for ii = 1 : numel( aggregatevars );
        dict.aggregate{1}.group{1+ii} = struct(...
            'pretty', aggregatevars{ii},...
            'native', aggregatevars{ii},...
            'units','undefined',...
            'description','',...
            'links',struct( 'url','','name','') ...
            );
    end
end

if numel( spatialvars ) > 0
    % Create a default group
    dict.spatial{1}.group{1}=struct(...
            'name','DEFAULT', ...
            'description','',...
            'links',struct( 'url','','name','') ...
            );
    for ii = 1 : numel( spatialvars );
        dict.spatial{1}.group{1+ii} = struct(...
            'pretty', spatialvars{ii},...
            'native', spatialvars{ii},...
            'units','undefined',...
            'description','',...
            'links',struct( 'url','','name','') ...
            );
    end
end