function S = AddTags( S,varargin );
if isfield(S,'tags')
    S.tags = cat(1,S.tags, varargin{:});
else
    S.tags = varargin{:};
end