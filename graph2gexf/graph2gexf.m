function graph2gexf(G, file)
%GRAPH2GEXF Write graph data to Graph Exchange XML (gexf) file
%
% graph2gexf(G, file)
%
% Input variables:
%
%   G:      graph object, with Node Properties x,y and Edge weights
%       
%   file:   name of output file


[pth,fl,ex] = fileparts(file);
if isempty(ex)
    file = fullfile(pth, [fl '.gexf']);
elseif ~strcmp(ex, '.gexf')
    warning('Using provided extension instead of .gexf');
end

nnode = numnodes(G);
nedge = numedges(G);
% nodeused = ismember({G.Nodes.name}, {G.Edges.target G.Edges.source});

docNode = com.mathworks.xml.XMLUtils.createDocument('gexf');
gml = docNode.getDocumentElement;
gml.setAttribute('version', '1.1');
gml.setAttribute('xmlns', 'http://www.gexf.net/1.1draft');
gml.setAttribute('xmlns:viz', 'http://www.gexf.net/1.1draft/viz');
gml.setAttribute('xmlns:xsi', 'http://www.w3.org/2001/XMLSchema-instance');
gml.setAttribute('xsi:schemaLocation', 'http://www.gexf.net/1.1draft http://www.gexf.net/1.1draft/gexf.xsd');

gr = docNode.createElement('graph');
gr.setAttribute('id', fl);
gr.setAttribute('defaultedgetype', 'directed');
gr.setAttribute('mode', 'static');
gml.appendChild(gr);

n = docNode.createElement('nodes');

for in = 1:nnode
    node = docNode.createElement('node');
    node.setAttribute('id',    G.Nodes.Name{in});
    node.setAttribute('label', G.Nodes.Name{in});
    
    ndata = docNode.createElement('viz:position');
    ndata.setAttribute('x', num2str(G.Nodes.x(in)));
    ndata.setAttribute('y', num2str(G.Nodes.y(in)));
    ndata.setAttribute('z', '0');
    ndata.setAttribute('xmlns:viz', 'http://www.gexf.net/1.1draft/viz');
    
    node.appendChild(ndata);
    n.appendChild(node);
end

ed = docNode.createElement('edges');

for il = 1:nedge
    lnk = docNode.createElement('edge');
    lnk.setAttribute('id', num2str(il));
    lnk.setAttribute('source', G.Edges.EndNodes{il,1});
    lnk.setAttribute('target', G.Edges.EndNodes{il,2});
    lnk.setAttribute('weight', num2str(G.Edges.Weight(il)));
    
    ed.appendChild(lnk);
end

gr.appendChild(n);
gr.appendChild(ed);

xmlwrite(file, docNode);