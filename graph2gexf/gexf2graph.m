function G = gexf2graph(file)
%GEXF2GRAPH Reads graph object data from a Graph Exchange XML (gexf) file
%
% G = gexf2graph(file)
%
% Input variables:
%
%   file:   name of input file
%
% Output variables:
%
%   G:      graph object.  Currently only reads in node ID and position,
%           and edge source and target nodes, while ignoring any other
%           attributes.

% Copyright 2015-2016 Kelly Kearney

xdoc = xmlread(file);
n = xdoc.getElementsByTagName('node');

nnode = n.getLength;

id = cell(nnode,1);
[x,y] = deal(nan(nnode,1));

for in = 1:nnode
    tmp = n.item(in-1);
    id{in} = getstratt(tmp, 'id', sprintf('node%d',in));
    
    v = tmp.getElementsByTagName('viz:position');
    if v.getLength > 0
        x(in) = str2double(getstratt(v.item(0), 'x', 'NaN'));
        y(in) = str2double(getstratt(v.item(0), 'y', 'NaN'));
    end
%     x(in) = str2double(char(v.item(0).getAttribute('x')));
%     y(in) = str2double(char(v.item(0).getAttribute('y')));
end

ed = xdoc.getElementsByTagName('edge');

nedge = ed.getLength;

[eid,src,tar] = deal(cell(nedge,1));
w = zeros(nedge,1);
for ie = 1:nedge
    tmp = ed.item(ie-1);
    
    eid{ie} = getstratt(tmp, 'id', sprintf('edge%d',ie));
    
    src{ie} = getstratt(tmp, 'source', '');
    tar{ie} = getstratt(tmp, 'target', '');
    
    w(ie) = str2double(getstratt(tmp, 'weight', '1'));
        
end

[tf, sloc] = ismember(src, id);
[tf, tloc] = ismember(tar, id);

[st, ~, idx] = unique([sloc tloc], 'rows', 'stable');
w = accumarray(idx, w, [size(st,1) 1]);

G = digraph(st(:,1), st(:,2), w, id);
G.Nodes.x = x;
G.Nodes.y = y;

function att = getstratt(x, attname, def)

if x.hasAttribute(attname)
    att = char(x.getAttribute(attname));
else
    att = def;
end

