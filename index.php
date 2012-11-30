<?php

error_reporting(0);
// error_reporting(E_ALL);

// include "XML_XSLT2Processor/XSLT2Processor.php";

if (preg_match("/_/", getenv('QUERY_STRING'))) {
    header("HTTP/1.1 301 Moved Permanently");
    header("Location: http://blog.othree.net".preg_replace("/_/", "-", getenv('QUERY_STRING')));
    exit();
}

$dpr = 1;
if ($_COOKIE['devicePixelRatio']) {
    $dpr = floatval($_COOKIE['devicePixelRatio']);
}

//get local path
$self_path = preg_replace("!index\.php!", "", getenv('SCRIPT_NAME'));
$query_string = preg_replace("!^".$self_path."!", "", getenv('QUERY_STRING'));

//get target file path
if (preg_match("/^feeds|rss\/?$/", $query_string)) $format = "xml";
else $format = (preg_match("/([^\.\/]+)$/", $query_string, $matches))?$matches[0]:"html";
$ext = ($format == "html")?"xml":$format;
if (preg_match("/rss\/?$/", $query_string)) {
    $query_string = preg_replace("/rss\/?/", "", $query_string);
    $ext = "rss.xml";
}

$query_string = preg_replace("/[\.\/]?(".$format.")?+$/", "", $query_string);
if ($query_string == "") $target_file = "index.".$ext;
else $target_file = $query_string."/index.".$ext;
if (!is_file($target_file))
    $target_file = $query_string.".".$ext;
if (!is_file($target_file)) {
    $target_file = "about/404.".$ext;
}
if ($target_file == "about/404.".$ext) {
    $not_found = true;
}

//output string
if ($format == "html") {
    if (preg_match("/application\/xhtml\+xml/",getenv('HTTP_ACCEPT')) || preg_match("/W3C/", getenv('HTTP_USER_AGENT'))) $format = 'xhtml';
    //compitable fix for IE or nonIE
    $patterns = array("/<(script|textarea|iframe)((\s+\w+=(\w+|\"[^\"]*\"|\'[^\']*\'))*)\/>/",
        "/([\"\'])\/>/",
        "/ *<(\/?(pre|code))> */is",
        "/\s*<(\/?a)((\s+\w+=(\w+|\"[^\"]*\"|\'[^\']*\'))*)>\s*/",
        "/&(?!(amp|lt|gt|nbsp);)/");
    $replacements = array("<\\1\\2></\\1>",
        "\\1 />",
        "<\\1>",
        "<\\1\\2>",
        "&amp;");
    if (!preg_match("/IE/", getenv('HTTP_USER_AGENT'))) {
        array_push($patterns, "/\s*<(\/?(pre|code))>\s*/is");
        array_push($replacements, "<\\1>");
    }
    //compatible with xhtml and html
    if ($format == "xhtml") {
        array_push($patterns, "/\s*<meta http-equiv=.*>/");
        array_push($replacements, "");
        //header("Content-type: application/xhtml+xml; charset=UTF-8");
        header("Content-type: text/html; charset=UTF-8");
    } else {
        //change to XHTML 1.0 strict
        array_push($patterns, "/<\?xml version=\"1.0\" encoding=\"UTF-8\"\?>\n/",
            "/<!DOCTYPE html PUBLIC \"-\/\/W3C\/\/DTD XHTML 1.1\/\/EN\" \"http:\/\/www.w3.org\/TR\/xhtml11\/DTD\/xhtml11.dtd\">/",
            "/application\/xhtml\+xml/",
            "/xml:lang=\"([a-z]{2}(\-[A-Z]{2})?+)\"/",
            "/<\!\[CDATA\[/",
            "/\]\]>/");
        array_push($replacements, "",
            "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\">",
            "text/html",
            "lang=\"\\1\" xml:lang=\"\\1\"",
            "<!--",
            "-->");
        header("Content-type: text/html; charset=UTF-8");
    }
    //xsl transform
    $output = preg_replace($patterns, $replacements, xslt($target_file, "main.xsl", $format, $dpr) );
} else if ($format == "xml") {
    $handle = fopen($target_file, "r");
    $output = fread($handle, filesize($target_file));
    fclose($handle);
    if (preg_match("/IE/", getenv('HTTP_USER_AGENT'))) sheader("Content-type: text/xml; charset=UTF-8");
    else header("Content-type: application/xml; charset=UTF-8");
}

if ($not_found) {
    header("HTTP/1.0 404 Not Found");
}

echo $output;


//xsl transform function
function xslt($xml, $xsl, $mime, $dpr) {
    if (preg_match("/^5/",phpversion()) && (extension_loaded('xsl') || dl("xsl".$suffix))) {
        $xmlo = new DOMDocument; // from /ext/dom
        $xmlo->load($xml);
        $xslo = new DOMDocument;
        $xslo->load($xsl);

        // Configure the transformer 
        $proc = new XSLTProcessor;

        // $proc = new XML_XSLT2Processor('SAXON9', './saxon/saxon9he.jar', 'JAVA-CLI');

        $proc->importStyleSheet($xslo); // attach the xsl rules
        $proc->setParameter('blog.othree.net', 'ext', '');
        $proc->setParameter('blog.othree.net', 'mime', $mime);
        $proc->setParameter('blog.othree.net', 'dpr', $dpr);
        return $proc->transformToXML($xmlo); // actual transformation
    } else {
        header("Content-type: text/html; charset=UTF-8");
        echo "We have some problem. Try <a href=\"http://blog.othree.net/xml\">alternative version</a>";
        exit;
    }
}

?>
