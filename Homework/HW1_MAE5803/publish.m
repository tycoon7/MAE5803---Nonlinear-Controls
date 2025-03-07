function outputAbsoluteFilename = publish(file,options,varargin)
%PUBLISH Publish file containing cells to output file
%   PUBLISH(FILE) evaluates the file one cell at a time in the base
%   workspace.  It saves the code, comments, and results to an HTML file
%   with the same name.  The HTML file is stored, along with other
%   supporting output files, in an "html" subdirectory within the script's
%   directory.
%
%   PUBLISH(FILE,FORMAT) saves the results to the specified format.  FORMAT
%   can be one of the following:
%
%      'html'  - HTML.
%      'doc'   - Microsoft Word (requires Microsoft Word).
%      'pdf'   - PDF.
%      'ppt'   - Microsoft PowerPoint (requires Microsoft PowerPoint).
%      'xml'   - An XML file that can be transformed with XSLT or other 
%                tools.
%      'latex' - LaTeX.  Also sets the default imageFormat to 'epsc2' 
%                unless figureSnapMethod is 'getframe'.
%
%   PUBLISH(FILE,OPTIONS) provides a structure, OPTIONS, that may contain
%   any of the following fields.  If the field is not specified, the first
%   choice in the list is used.
%
%       format: 'html' | 'doc' | 'pdf' | 'ppt' | 'xml' | 'latex'
%       stylesheet: '' | an XSL filename (ignored when format = 'doc', 'pdf', or 'ppt')
%       outputDir: '' (an html subfolder below the file) | full path
%       imageFormat: '' (default based on format)  'bmp' | 'eps' | 'epsc' | 'jpeg' | 'meta' | 'png' | 'ps' | 'psc' | 'tiff'
%       figureSnapMethod: 'entireGUIWindow'| 'print' | 'getframe' | 'entireFigureWindow'
%       useNewFigure: true | false
%       maxHeight: [] (unrestricted) | positive integer (pixels)
%       maxWidth: [] (unrestricted) | positive integer (pixels)
%       showCode: true | false
%       evalCode: true | false
%       catchError: true | false
%       createThumbnail: true | false
%       maxOutputLines: Inf | non-negative integer
%       codeToEvaluate: (the file you are publishing) | any valid code
%
%   When publishing to HTML, the default stylesheet stores the original
%   code as an HTML comment, even if "showcode = false".  Use GRABCODE to
%   extract it.
%
%   MY_DOC = PUBLISH(...) returns the path and filename of the generated
%   output document.
%
%   Example:
%
%       opts.outputDir = tempdir;
%       file = publish('intro',opts);
%       web(file)
%
%   See also NOTEBOOK, GRABCODE.

% Copyright 1984-2016 The MathWorks, Inc.

% This function requires Java.
if ~usejava('jvm')
    error(pm('NoJvm'));
end

% Convert param/value pairs to structure.
if (nargin > 2)
    pv = [{options} varargin];
    options = cell2struct(pv(2:2:end),pv(1:2:end),2);
end

% Default to HTML publishing.
if (nargin < 2)
    options = 'html';
end

% If options is a simple string (format), convert to structure.
if ischar(options)
    t = options;
    options = struct;
    options.format = t;
end

% Process options.
checkOptionFields(options);
options = supplyDefaultOptions(options);
validateOptions(options)
format = options.format;

% Have they explicitly asked to publish a non-code file?
[~,~,fileExt] = fileparts(file);
switch fileExt
    % This can't be a whitelist of extensions because fileparts won't work
    % for packages, methods, and such, so blacklist the most common.
    case {'mdl','slx'}
        error(pm('OnlyCode'));
end

% Locate the exact file to publish.
fullPathToScript = locateFile(file);
if isempty(fullPathToScript)
    error(pm('SourceNotFound',file));
end

% Now that we know the exact file, is it code?
isCodeExtension = @(x)(strcmp(x,'.m') || strcmp(x,'.mlx'));
[scriptDir,prefix,ext] = fileparts(fullPathToScript);
if ~isCodeExtension(ext)
    % We found a non-code file. Guess why for the error message.
    getExtension = @(x)returnNthOfM(@fileparts,3,3,x);
    hasCodeExtension = @(x)isCodeExtension(getExtension(x));
    if any(cellfun(hasCodeExtension,which('-all',prefix)))
        error(pm('Shadowed',fullPathToScript));
    else
        error(pm('OnlyCode'));
    end
end

% Supply the command to evaluate, if needed.
options = setCodeToEvaluateIfEmpty(file,options,fullPathToScript);

% Determine publish location.
if isfield(options,'outputDir') && ~isempty(options.outputDir)
    outputDir = options.outputDir;
    % Check for relative path.
    javaFile = java.io.File(outputDir);
    % Run it through FULLFILE to normalize path. Use the trailing FILESEP
    % to remove trailing dots.
    if (javaFile.isAbsolute)
        outputDir = fullfile(outputDir,filesep);
    else
        outputDir = fullfile(pwd,outputDir,filesep);
    end
    % Remove the trailing filesep.
    outputDir = regexprep(outputDir,'[/\\]$','');
else
    outputDir = fullfile(scriptDir,'html');
end
switch format
    case 'latex'
        ext = 'tex';
    otherwise
        ext = format;
end
outputAbsoluteFilename = fullfile(outputDir,[prefix '.' ext]);

% Make sure we can write to this filename.  Create the directory, if needed.
error(prepareOutputLocation(outputAbsoluteFilename));

% Determine where to save image files.
switch format
    case {'doc','ppt','pdf'}
        imageDir = tempdir;
        % Trim the trailing slashes off the directory to make later logic easier.
        imageDir(end) = [];
        needToCleanTempdir = true;
    otherwise
        imageDir = outputDir;
        needToCleanTempdir = false;
end

% Flush out any existing images.  This also verifies there are no read-only
% images in the way.  It also keeps us from drooling images if a
% republished version has fewer images than the existing one.
deleteExistingImages(imageDir,prefix,false)

% Convert the M-code to XML.
[dom,cellBoundaries] = m2mxdom(file2char(fullPathToScript));

% Add reference to original file.
newNode = dom.createElement('m-file');
newTextNode = dom.createTextNode(prefix);
newNode.appendChild(newTextNode);
dom.getFirstChild.appendChild(newNode);
newNode = dom.createElement('filename');
newTextNode = dom.createTextNode(fullPathToScript);
newNode.appendChild(newTextNode);
dom.getFirstChild.appendChild(newNode);
newNode = dom.createElement('outputdir');
newTextNode = dom.createTextNode(outputDir);
newNode.appendChild(newTextNode);
dom.getFirstChild.appendChild(newNode);

oldJFWarning = warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
%restore state on exit.
jfCleanupHandler = onCleanup(@() warning(oldJFWarning));

% Creat images of TeX equations for non-TeX output.
dom = createEquationImages(dom,imageDir,prefix,format,outputDir);

% Evaluate each cell, snap the output, and store the results.
if options.evalCode
    dom = evalmxdom(file,dom,cellBoundaries,prefix,imageDir,outputDir,options);
end

% Post-process the DOM.
dom = removeDisplayCode(dom,options.showCode);
dom = truncateOutput(dom,options.maxOutputLines);
dom = postEval(dom);

% Write to the output format.
switch format
    case 'xml'
        if isempty(options.stylesheet)
            xmlwrite(outputAbsoluteFilename,dom)
        else
            xslt(dom,options.stylesheet,outputAbsoluteFilename);
        end

    case 'html'
        xslt(dom,options.stylesheet,outputAbsoluteFilename);
        
    case 'latex'
        xslt(dom,options.stylesheet,outputAbsoluteFilename);
        resaveWithNativeEncoding(outputAbsoluteFilename)
        
    case 'doc'
        mxdom2word(dom,outputAbsoluteFilename);

    case 'ppt'
        mxdom2ppt(dom,outputAbsoluteFilename);

    case 'docbook'
        xslt(dom,options.stylesheet,outputAbsoluteFilename);
        resaveWithNativeEncoding(outputAbsoluteFilename)

    case 'pdf'
        publishToPdf(dom,options,outputAbsoluteFilename)
end


% Cleanup.
if needToCleanTempdir
    try
        deleteExistingImages(imageDir,prefix,true)
    catch %#ok<CTCH>
        % Don't error if cleanup fails for some strange reason.
    end
end
if strcmp(format,'doc') && (numel(dir(fullfile(tempdir,'VBE'))) == 2)
    % Word drools this empty temporary directory.
    try
        rmdir(fullfile(tempdir,'VBE'))
    catch %#ok<CTCH>
        % Don't error if cleanup fails for some strange reason.
    end
end

%===============================================================================
function nthOutput = returnNthOfM(f,n,m,varargin)
outputs = cell(1,m);
[outputs{:}] = f(varargin{:});
nthOutput = outputs{n};

%===============================================================================
function checkOptionFields(options)
validOptions = {'format','stylesheet','outputDir','imageFormat', ...
    'figureSnapMethod','useNewFigure','maxHeight','maxWidth','showCode', ...
    'evalCode','stopOnError','catchError','displayError','createThumbnail', 'maxOutputLines', ...
    'codeToEvaluate','font','titleFont','bodyFont','monospaceFont', ...
    'maxThumbnailHeight','maxThumbnailWidth'};
bogusFields = setdiff(fieldnames(options),validOptions);
if ~isempty(bogusFields)
    error(pm('InvalidOption',bogusFields{1}));
end

%===============================================================================
function options = supplyDefaultOptions(options)
% Supply default options for any that are missing.
if ~isfield(options,'format')
    options.format = 'html';
end
format = options.format;
privateDir = fullfile(fileparts(mfilename('fullpath')),'private');

if ~isfield(options,'stylesheet') || isempty(options.stylesheet)
    switch format
        case 'html'
            styleSheet = fullfile(privateDir,'mxdom2simplehtml.xsl');
            options.stylesheet = styleSheet;
        case 'latex'
            styleSheet = fullfile(privateDir,'mxdom2latex.xsl');
            options.stylesheet = styleSheet;
        case {'docbook','pdf'}
            styleSheet = fullfile(privateDir,'mxdom2docbook.xsl');
            options.stylesheet = styleSheet;
        otherwise
            options.stylesheet = '';
    end
end
if ~isfield(options,'figureSnapMethod')
    options.figureSnapMethod = 'entireGUIWindow';
end
if ~isfield(options,'imageFormat') || isempty(options.imageFormat)
    options.imageFormat = '';
elseif strcmp(options.imageFormat,'jpg')
    options.imageFormat = 'jpeg';
elseif strcmp(options.imageFormat,'tif')
    options.imageFormat = 'tiff';
elseif strcmp(options.imageFormat,'gif')
    error(pm('NoGIFs'));
end
if ~isfield(options,'useNewFigure')
    options.useNewFigure = true;
end
if ~isfield(options,'maxHeight')
    options.maxHeight = [];
end
if ~isfield(options,'maxWidth')
    options.maxWidth = [];
end
if ~isfield(options,'maxThumbnailHeight')
    options.maxThumbnailHeight = 64;
end
if ~isfield(options,'maxThumbnailWidth')
    options.maxThumbnailWidth = 85;
end
if ~isfield(options,'showCode')
    options.showCode = true;
end
if ~isfield(options,'evalCode')
    options.evalCode = true;
end
if ~isfield(options,'stopOnError')
    options.stopOnError = true;
end
if ~isfield(options,'catchError')
    options.catchError = true;
end
if ~isfield(options,'displayError')
    options.displayError = true;
end
if ~isfield(options,'createThumbnail')
    options.createThumbnail = true;
end
if ~isfield(options,'maxOutputLines')
    options.maxOutputLines = Inf;
end
if ~isfield(options,'codeToEvaluate')
    options.codeToEvaluate = '';
end
if ~isfield(options,'font')
    options.font = '';
end
if ~isfield(options,'titleFont')
    options.titleFont = options.font;
end
if ~isfield(options,'bodyFont')
    options.bodyFont = options.font;
end
if ~isfield(options,'monospaceFont')
    options.monospaceFont = options.font;
end

%===============================================================================
function validateOptions(options)

% Check format.
supportedFormats = {'html','doc','ppt','xml','rpt','latex','pdf','docbook'};
if ~any(strcmp(options.format,supportedFormats))
    error(pm('UnknownFormat',options.format));
end

% Check stylesheet.
if ~isempty(options.stylesheet) && ~exist(options.stylesheet,'file')
    error(pm('StylesheetNotFound',options.stylesheet))
end

% Check logical scalars.
logicalScalarOptions = {'useNewFigure','showCode','evalCode','catchError','displayError','createThumbnail'};
isLogicalScalarOrEmpty = @(x) ...
    isempty(options.(x)) || ...
    (islogical(options.(x)) && (numel(options.(x))==1));
badOptions = logicalScalarOptions(~cellfun(isLogicalScalarOrEmpty,logicalScalarOptions));
if ~isempty(badOptions)
    error(pm('InvalidBoolean',badOptions{1}))
end

% Check maxOutputLines.
if ~isnumeric(options.maxOutputLines) || ...
        (numel(options.maxOutputLines) ~= 1) || ...
        (options.maxOutputLines < 0) || ...
        isnan(options.maxOutputLines) || ...
        (round(options.maxOutputLines) ~= options.maxOutputLines)
    error(pm('InvalidMaxOutputLines'));
end

% Check maxWidth and maxHeight.
isEmptyOrPositiveInteger = @(x)isempty(x) || ...
    (isnumeric(x) && numel(x) == 1 && x > 0 && round(x) == x);
for field = {'maxWidth','maxHeight','maxThumbnailHeight','maxThumbnailWidth'}
    f = field{1}; % dislike
    if ~isEmptyOrPositiveInteger(options.(f))
        error(pm('MustBeEmptyOrPositiveInteger',f))
    end
end

% Check consistency.
vectorFormats = internal.matlab.publish.getVectorFormats();
if any(strcmp(options.imageFormat,vectorFormats))
    if strcmp(options.figureSnapMethod,'getframe')
        error(pm('VectorAndGetframe',options.imageFormat))
    end
    if ~isempty(options.maxHeight) || ~isempty(options.maxWidth)
        warning(pm('VectorSize',upper(options.imageFormat)))
    end
end

% Format-specific limitations.
if strcmp(options.format,'pdf') && ...
        ~isempty(options.imageFormat) && ...
        ~(strcmp(options.imageFormat,'bmp') || strcmp(options.imageFormat,'jpeg'))
    error(pm('InvalidPDFImageFormat'));
end

% Check deprication.
if ~isempty(options.stopOnError) && (options.stopOnError == false)
    warning(pm('StopOnErrorDeprecated'))
end

%===============================================================================
function options = setCodeToEvaluateIfEmpty(file,options,fullPathToScript)
if isempty(options.codeToEvaluate)
    % Don't use FILEPARTS because it doesn't handle packages, methods, etc.
    cmd = regexprep(file,'.*[\\/]','');
    cmd = regexprep(cmd,'\.m$','');
    foundAt = safeWhich(cmd);
    % Do a case insensitve match because the PC is case-insensitve.
    if ~strcmpi(strrep(fullPathToScript,'/',filesep),foundAt) && ...
            (options.evalCode==true)
        if isempty(foundAt)
            error(pm('OffPath'))
        else
            error(pm('Shadowed',foundAt))
        end
    end
    options.codeToEvaluate = cmd;
end

%===============================================================================
function deleteExistingImages(imageDir,prefix,equations)

% Start with a list of candidates for deletions.
d = dir(fullfile(imageDir,[prefix '_*.*']));

% Define the regexp to use to to lessen the chance of false hits.
tail = '\d{2,}\.[A-Za-z]+';
if equations
    tail = ['(' tail '|eq\d+\.(?:png|bmp))'];
end
imagePattern = ['^' prefix '_' tail '$'];

% We need to detect if a DELETE failed by checking WARNING.  Save the
% original state and clear the warning.
[lastmsg,lastid] = lastwarn('');

% Delete the images.
for i = 1:length(d)
    if (regexp(d(i).name,imagePattern) == 1)
        toDelete = fullfile(imageDir,d(i).name);
        delete(toDelete)
        if ~isempty(lastwarn)
            error(pm('CannotDelete',toDelete))
        end
    end
end

% Delete the thumbnail.
thumbnail = fullfile(imageDir,[prefix '.png']);
if ~isempty(dir(thumbnail))
    delete(thumbnail)
    if ~isempty(lastwarn)
        error(pm('CannotDelete',thumbnail))
    end
end

% Restore the warning.
lastwarn(lastmsg,lastid);

%===============================================================================
function dom = removeDisplayCode(dom,showCode)
if ~showCode
    while true
        codeNodeList = dom.getElementsByTagName('mcode');
        if (codeNodeList.getLength == 0)
            break;
        end
        codeNode = codeNodeList.item(0);
        codeNode.getParentNode.removeChild(codeNode);
    end
    
    codeNodeList = dom.getElementsByTagName('mcode-xmlized');
    for i = codeNodeList.getLength:-1:1
        codeNode = codeNodeList.item(i-1);
        if (~strcmp(codeNode.getParentNode.getNodeName,'text'))
            codeNode.getParentNode.removeChild(codeNode);
        end
    end
    
end

%===============================================================================
function dom = truncateOutput(dom,maxOutputLines)
if ~isinf(maxOutputLines)
    outputNodeList = dom.getElementsByTagName('mcodeoutput');
    % Start at the end in case we remove nodes.
    for iOutputNodeList = outputNodeList.getLength:-1:1
        outputNode = outputNodeList.item(iOutputNodeList-1);
        if (maxOutputLines == 0)
            outputNode.getParentNode.removeChild(outputNode);
        else
            text = char(outputNode.getFirstChild.getData);
            newlines = regexp(text,'\n');
            if maxOutputLines <= length(newlines)
                chopped = text(newlines(maxOutputLines):end);
                text = text(1:newlines(maxOutputLines));
                if ~isempty(regexp(chopped,'\S','once'))
                    text = [text '...']; %#ok<AGROW>
                end
            end
            outputNode.getFirstChild.setData(text);
        end
    end
end


%===============================================================================
function dom = postEval(dom)
postEvalNodeList = dom.getElementsByTagName('mcode-xmlized-post');
% Start at the end in case we remove nodes.
for iPostEvalNodeList = postEvalNodeList.getLength:-1:1
    inputNode = postEvalNodeList.item(iPostEvalNodeList-1);
    code = inputNode.getTextContent;
    filename = strtrim(char(code));
    [codeoutput, includeWarning] = includeCode(filename);
    if isempty(includeWarning)
        codeNode = dom.createElement('mcode-xmlized');
        [~,~,ext] = fileparts(filename);
        if isempty(ext) || strcmp(ext, '.m')
            node=com.mathworks.widgets.CodeAsXML.xmlize(dom, codeoutput);
        else
            node = dom.createTextNode(codeoutput);
        end
        codeNode.appendChild(node);
        inputNode.getParentNode.replaceChild(codeNode, inputNode);
    else
        node = dom.createElement('pre');
        node.setAttribute('class','error')
        node.appendChild(dom.createTextNode(includeWarning));
        inputNode.getParentNode.replaceChild(node, inputNode);
    end
end


%===============================================================================
function resaveWithNativeEncoding(outputAbsoluteFilename)
% UTF in.
f = fopen(outputAbsoluteFilename,'r','n','UTF-8');
c = fread(f,'char=>char')';
fclose(f);

% Native out.
f = fopen(outputAbsoluteFilename,'w');
fwrite(f,c,'char');
fclose(f);

%===============================================================================
function publishToPdf(dom,options,outputAbsoluteFilename)

% Unix doesn't figure out when these are full paths.  Help it out.
if ~ispc
    imgNodeList = dom.getElementsByTagName('img');
    for i = 1:imgNodeList.getLength();
        node = imgNodeList.item(i-1);
        src = char(node.getAttribute('src'));
        if strcmp('/',src)
            node.setAttribute('src',file2urn(src));
        end
    end
end

% Create the temporary DocBook.
docbook = xslt(dom,options.stylesheet,'-tostring');

% Driver, set log level and set to render PDF.
[fopDriver, fopOutputStream] = fopInitialize(options,outputAbsoluteFilename);

% Input.
saxParserFactory = javax.xml.parsers.SAXParserFactory.newInstance;
saxParserFactory.setValidating(false);
saxParserFactory.setNamespaceAware(true);
xmlReader = saxParserFactory.newSAXParser.getXMLReader();
uriResolver = com.mathworks.toolbox.rptgencore.tools.UriResolverRG();
xmlReader.setEntityResolver(uriResolver);
saxInputSource = org.xml.sax.InputSource(java.io.StringReader(docbook));
saxSource = javax.xml.transform.sax.SAXSource(xmlReader,saxInputSource);

xsltDestination = javax.xml.transform.sax.SAXResult(...
            fopDriver.getDefaultHandler());

% Transform.
noToc = dom.getElementsByTagName('steptitle').getLength < 3;
xslt(saxSource,getPdfStylesheet(options,noToc),xsltDestination);

% Cleanup.
fopOutputStream.close;


%===============================================================================
function [fop, fopOutputStream] = fopInitialize(options,outputAbsoluteFilename)

% Get the logger for any class prefixed with org.apache 
%   (see http://logging.apache.org/log4j/1.2/manual.html for details)
oaLogger = org.apache.log4j.Logger.getLogger('org.apache');
fopLogger = org.apache.log4j.Logger.getLogger('FOP');

% Each logger needs at least one appender to avoid warnings, so we simply add NullAppenders
oaLogger.addAppender(org.apache.log4j.varia.NullAppender);
fopLogger.addAppender(org.apache.log4j.varia.NullAppender);

classes = {
    'org.apache.fop.apps.FopFactory'
    'org.apache.fop.apps.FopFactoryConfigurator'
    'org.apache.fop.fonts.truetype.TTFFile'
    'org.apache.fop.fo.properties.PropertyMaker'
    'org.apache.fop.apps.FOUserAgent'
    };
for iClasses = 1:numel(classes)
    c = classes{iClasses};
    factoryLogger = org.apache.commons.logging.LogFactory.getLog(c);
    if isa(factoryLogger,'org.apache.commons.logging.impl.SimpleLog')
        factoryLogger.setLevel(factoryLogger.LOG_LEVEL_ERROR);
    end
end

% Create FOP factory
fopFactory = org.apache.fop.apps.FopFactory.newInstance();
fopFactory.setStrictValidation(false);
fopFactory.setSourceResolution(get(0,'ScreenPixelsPerInch'));
fopFactory.setURIResolver(com.mathworks.toolbox.rptgencore.tools.UriResolverRG());

% Enable hypenation.
fopFactory.setHyphenBaseURL(file2urn( ...
    fullfile(matlabroot,'sys/namespace/hyph/')));

% There is a performance penalty, so only turn on auto-detect if we need to.
if all(cellfun(@isempty,{options.titleFont,options.bodyFont,options.monospaceFont}))
    fopConfigXml = 'fop_config.xml';
else
    fopConfigXml = 'fop_config_autodetect.xml';
end
fullFopConfigXml = fullfile(fileparts(mfilename('fullpath')),'private',fopConfigXml);

% Workaround for an apparent bug in FOP 1.0 which fails for UNC paths.
tempFullFopConfigXml = [tempname '.xml'];
copyfile(fullFopConfigXml,tempFullFopConfigXml);
fopFactory.setUserConfig(file2urn(tempFullFopConfigXml));
delete(tempFullFopConfigXml)

fopFactory.setBaseURL(file2urn( ...
    fullfile(fileparts(outputAbsoluteFilename),filesep)));
fixFontDirectories(fopFactory);

% Create FOP renderer
fopOutputStream = java.io.BufferedOutputStream(java.io.FileOutputStream(outputAbsoluteFilename));

fop = fopFactory.newFop('application/pdf', fopOutputStream);
% fop.getUserAgent().getEventBroadcaster().addEventListener(...
%     com.mathworks.toolbox.rptgencore.tools.FOPEventListener);

%===============================================================================
function fixFontDirectories(fopFactory)

fonts = fopFactory.getUserConfig().getChild('renderers').getChild('renderer').getChild('fonts');
directoryNodes = fonts.getChildren('directory');

for iDirectoryNodes = 1:numel(directoryNodes)
    directoryNode = directoryNodes(iDirectoryNodes);

    fontDir = char(directoryNode.getValue());
    tempdirSub = regexptranslate('escape',fileparts(tempdir));
    fontDir = regexprep(fontDir,'^\$tempdir',tempdirSub);    
    matlabrootSub = regexptranslate('escape',matlabroot);
    fontDir = regexprep(fontDir,'^\$matlabroot',matlabrootSub);
    fontDir = regexprep(fontDir,'[\\/]',filesep);
    
    if exist(fontDir,'dir')
        directoryNode.setValue(fontDir);
    else
        fonts.removeChild(directoryNode)
    end
end

%===============================================================================
function styleDom = getPdfStylesheet(options,noToc)
% Stylesheet
styleDom = com.mathworks.xml.XMLUtils.createDocument('xsl:stylesheet');
de = styleDom.getDocumentElement();
de.setAttribute('xmlns:xsl','http://www.w3.org/1999/XSL/Transform');
de.setAttribute('xmlns','http://www.w3.org/TR/xhtml1/transitional');
de.setAttribute('version','1.0');
importNode = styleDom.createElement('xsl:import');
xslUrl = file2urn(fullfile(matlabroot, ...
    '/sys/namespace/docbook/v4/xsl/fo/docbook_rptgen.xsl'));
importNode.setAttribute('href',xslUrl);
de.appendChild(importNode);
addVariable(styleDom,de,'show.comments','0')
addVariable(styleDom,de,'fop.extensions','0')
addVariable(styleDom,de,'fop1.extensions','1')
if noToc
    addVariable(styleDom,de,'generate.toc','0')
end
addVariable(styleDom,de,'draft.mode','no')

% Format hyperlinks.
addVariable(styleDom,de,'ulink.show','0')
attributeSet = styleDom.createElement('xsl:attribute-set');
attributeSet.setAttribute('name','xref.properties');
de.appendChild(attributeSet);
addAttribute(styleDom,attributeSet,'text-decoration','underline')
addAttribute(styleDom,attributeSet,'color','blue')

% Override default fonts.
sections = {'title','body','monospace'};
for i = 1:numel(sections)
    section = sections{i};
    val = options.([section 'Font']);
    if ~isempty(val)
        addVariable(styleDom,de,[section '.font.family'],['''' val ''''])
    end
end

%===============================================================================
function addVariable(dom,node,name,value)
var = dom.createElement('xsl:variable');
var.setAttribute('name',name);
var.setAttribute('select',value);
node.appendChild(var);

%===============================================================================
function addAttribute(dom,attributeSet,name,value)
attribute = dom.createElement('xsl:attribute');
attribute.setAttribute('name',name);
attribute.appendChild(dom.createTextNode(value));
attributeSet.appendChild(attribute);

%===============================================================================
function urnFile = file2urn(fileName)
%FILE2URN converts a file name to a Universal Resource Name
%   URN = FILE2URN(FILENAME) where FILENAME is a full path to a file

if strncmp(fileName,'file:///',8)
    % Test: c:/foo/bar -> file:///c:/foo/bar
    urnFile = fileName;

else
    % RFC 2141 URN Syntax specifies "%" "/" "?" "#" as key characters.
    % We do not need to escape the character "/" because file systems do not allow
    % this characters in directory names.
    fileName = strrep(fileName,'%','%25');
    fileName = strrep(fileName,'?','%3F');
    fileName = strrep(fileName,'#','%23');
    fileName = strrep(fileName,' ','%20');

    if strncmp(fileName,'/',1)
        % Test: /root/dir/file -> file:///root/dir/file
        % Test: /root/folder with space/file -> 
        %       file:///root/dir/folder%20with%20space/file
        fileName = strrep(fileName,'\','/');
        urnFile = ['file://' fileName];
    else
        % Test: \\server\root\dir\dir -> file://///server/root/dir/dir
        % Test: c:\dir\dir            -> file:///c:/dir/dir
        fileName = strrep(fileName,'\','/');
        urnFile = ['file:///' fileName];
    end
end

%===============================================================================
% All these subfunctions are for equation handling.
%===============================================================================
function dom = createEquationImages(dom,imageDir,prefix,format,outputDir)
% Render equations as images to be included in the document.

switch format
    case 'latex'
        return
    case {'docbook','pdf'}
        ext = '.bmp';
    otherwise
        ext = '.png';
end

% Setup.
baseImageName = fullfile(imageDir,prefix);
[tempfigure,temptext] = getRenderingFigure;

% Loop over each equation.
equationList = dom.getElementsByTagName('equation');
for i = 1:getLength(equationList)
    equationNode = equationList.item(i-1);
    equationText = char(equationNode.getTextContent);
    fullFilename = [baseImageName '_' hashEquation(equationText) ext];
    % Check to see if this equation needs to be rendered.
    if ~isempty(dir(fullFilename))
        % We've already got it on disk.  Use it.
        [height,width,~] = size(imread(fullFilename));
        swapTexForImg(dom,equationNode,outputDir,fullFilename,equationText,width,height)
    else
        % We need to render it.
        [x,texWarning] = renderTex(equationText,tempfigure,temptext);
        if isempty(texWarning)
            % Now shrink it down to get anti-aliasing.
            newSize = ceil(size(x)/2);
            frame.cdata = internal.matlab.publish.make_thumbnail(x,newSize(1:2));
            frame.colormap = [];
            % Rendering succeeded.  Write out the image and use it.
            internal.matlab.publish.writeImage(fullFilename,ext(2:end),frame,[],[])
            % Put a link to the image in the DOM.
%             swapTexForImg(dom,equationNode,outputDir,fullFilename,equationText,newSize(2),newSize(1))
            scale = 3;
            swapTexForImg(dom,equationNode,outputDir,fullFilename,equationText,newSize(2)/scale,newSize(1)/scale)
        else
            % Rendering failed.  Add error message.
            beep
            errorNode = dom.createElement('pre');
            errorNode.setAttribute('class','error')
            errorNode.appendChild(dom.createTextNode(texWarning));
            % Insert the error after the equation.  This would be easier if
            % there were an insertAfter node method.
            pNode = equationNode.getParentNode;
            if isempty(pNode.getNextSibling)
                pNode.getParentNode.appendChild(errorNode);
            else
                pNode.getParentNode.insertBefore(errorNode,pNode.getNextSibling);
            end
        end
    end
end

% Cleanup.
close(tempfigure)

%===============================================================================
function swapTexForImg(dom,equationNode,outputDir,fullFilename,equationText,width,height)
% Swap the TeX equation for the IMG.
equationNode.removeChild(equationNode.getFirstChild);
imgNode = dom.createElement('img');
imgNode.setAttribute('alt',equationText);
imgNode.setAttribute('src',strrep(fullFilename,[outputDir filesep],''));
imgNode.setAttribute('class','equation');
scale = internal.matlab.publish.getImageScale();
if scale ~= 1
    imgNode.setAttribute('scale',num2str(scale));
    width = round(width/scale);
    height = round(height/scale);
end
imgNode.setAttribute('width',sprintf('%ipx',width));
imgNode.setAttribute('height',sprintf('%ipx',height));
equationNode.appendChild(imgNode);


%===============================================================================
function [tempfigure,temptext] = getRenderingFigure

% Create a figure for rendering the equation, if needed.
tag = ['helper figure for ' mfilename];
tempfigure = findall(0,'type','figure','tag',tag);
if isempty(tempfigure)
    figurePos = get(0,'ScreenSize');
    if ispc
        % Set it off-screen since we have to make it visible before printing.
        % Move it over and down plus a little bit to keep the edge from showing.
        figurePos(1:2) = figurePos(3:4)+100;
    end
    % Create a new figure.
    tempfigure = figure( ...
        'HandleVisibility','off', ...
        'IntegerHandle','off', ...
        'Visible','off', ...
        'PaperPositionMode', 'auto', ...
        'PaperOrientation', 'portrait', ...
        'Color','w', ...
        'Position',figurePos, ...
        'Tag',tag);
    tempaxes = axes('position',[0 0 1 1], ...
        'Parent',tempfigure, ...
        'XTick',[],'ytick',[], ...
        'XLim',[0 1],'ylim',[0 1], ...
        'Visible','off');
    temptext = text('Parent',tempaxes,'Position',[.5 .5], ...
        'HorizontalAlignment','center','FontSize',26, ...
        'Interpreter','latex');
else
    % Use existing figure.
    tempaxes = findobj(tempfigure,'type','axes');
    temptext = findobj(tempaxes,'type','text');
end

%===============================================================================
function [x,texWarning] = renderTex(equationText,tempfigure,temptext)

% Setup.
[lastMsg,lastId] = lastwarn('');
set(temptext,'string',strrep(equationText,char(10),' '));

% Snap.
x = print(tempfigure, '-RGBImage', '-r0');

% Check for warnings.
texWarning = lastwarn;
lastwarn(lastMsg,lastId)
set(temptext,'string','');

% Trim, but keep the baseline-adjusted-middle in the middle.
if isempty(texWarning)
    % Sometimes the first pixel isn't white.  Crop that out.
    x(1,:,:) = [];
    x(:,1,:) = [];
    % Crop out the rest of the whitespace border.
    [i,j] = find(sum(double(x),3)~=765);
    x = x(min(i):max(i),min(j):max(j),:);
    if isempty(x)
        % The image is empty.  Return something so IMWRITE doesn't complain.
        x = 255*ones(1,3,'uint8');
    end
end

%===============================================================================
% End of equation handling subfunctions.
%===============================================================================

%===============================================================================
function [codeoutput, includeWarning] = includeCode(filename)
codeoutput = '';
includeWarning = '';
try
    if isempty(filename)
        error(pm('NoFileSpecified'));
    end
    codeToEval = ['type ', filename];
    codeoutput = evalc(codeToEval);
catch ME
    includeWarning = ME.message;
end

%===============================================================================
function m = pm(id,varargin)
m = message(['MATLAB:publish:' id],varargin{:});
