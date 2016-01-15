<?php

error_reporting(0);
// error_reporting(E_ALL);

// include "XML_XSLT2Processor/XSLT2Processor.php";

if (preg_match("/_/", getenv('QUERY_STRING'))) {
    header("HTTP/1.1 301 Moved Permanently");
    header("Location: https://blog.othree.net".preg_replace("/_/", "-", getenv('QUERY_STRING')));
    exit();
}

$dpr = 1;
if ($_COOKIE['devicePixelRatio']) {
    $dpr = floatval($_COOKIE['devicePixelRatio']);
}
$w = 'm';
if (isset($_COOKIE['w']) && intval($_COOKIE['w']) < 768) {
    $w = 's';
} else if ((include 'Mobile_Detect.php') == 'OK') {
    $detect = new Mobile_Detect();
    if ($detect->isMobile() && !$detect->isTablet()) {
        $w = 's';
    }
}

//get local path
$self_path = preg_replace("!index\.php!", "", getenv('SCRIPT_NAME'));
$query_string = preg_replace("!^".$self_path."!", "", getenv('QUERY_STRING'));
$canonical = 'https://blog.othree.net/' . $query_string;

//get target file path
if (preg_match("/^feeds|rss\/?$/", $query_string)) $format = "xml";
else $format = (preg_match("/([^\.\/]+)$/", $query_string, $matches))?$matches[0]:"html";
$ext = ($format == "html")?"xml":$format;
if (preg_match("/rss\/?$/", $query_string)) {
    $query_string = preg_replace("/rss\/?/", "", $query_string);
    $ext = "rss.xml";
}

$query_string = preg_replace("/[\.\/]?(".$format.")?+$/", "", $query_string);
if ($query_string == "") {
    $hash_file = "index.md5";
    $target_file = "index.".$ext;
}
else {
    $hash_file = $query_string."/index.md5";
    $target_file = $query_string."/index.".$ext;
}
if (!is_file($target_file)) {
    $hash_file = $query_string.".md5";
    $target_file = $query_string.".".$ext;
}
if (!is_file($target_file)) {
    $hash_file = "about/404.md5";
    $target_file = "about/404.".$ext;
}
if ($target_file == "about/404.".$ext) {
    $not_found = true;
}
if (is_file($target_file)) {
    if (!is_file($hash_file) || filemtime($target_file) > filemtime($hash_file)) {
        $hash = hash_file('md5', $target_file);
        file_put_contents($hash_file, $hash);
    } else {
        $hash = file_get_contents($hash_file);
    }
}

$request_hash = $_SERVER['HTTP_IF_NONE_MATCH'];
if (isset($request_hash) && $request_hash == '"'.$hash.'"') {
    header("Cache-Control: max-age=3600, public");
    header("Expires: ".gmdate('D, d M Y H:i:s \G\M\T', time() + 3600));
    header("HTTP/1.0 304 Not Modified");
    exit;
} else {
    header("ETag: \"".$hash."\"");
}

$UA = getenv('HTTP_USER_AGENT');

//output string
if ($format == "html") {
    if (preg_match("/application\/xhtml\+xml/",getenv('HTTP_ACCEPT')) || preg_match("/W3C/", $UA)) $format = 'xhtml';
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
    if (!preg_match("/IE/", $UA)) {
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
    $output = preg_replace($patterns, $replacements, xslt($target_file, "main.xsl", $canonical, $format, $dpr, $w) );
} else if ($format == "xml") {
    $handle = fopen($target_file, "r");
    $output = fread($handle, filesize($target_file));
    fclose($handle);
    if (preg_match("/IE/", $UA)) sheader("Content-type: text/xml; charset=UTF-8");
    else header("Content-type: application/xml; charset=UTF-8");
}

if ($not_found) {
    header("HTTP/1.0 404 Not Found");
}

header("Cache-Control: max-age=3600, public");
// header("Cache-Control: no-cache");
header("Expires: ".gmdate('D, d M Y H:i:s \G\M\T', time() + 3600));

$CSP = 'Content-Security-Policy';
if (preg_match("/MSIE/", $UA)) {
    $CSP = 'X-Content-Security-Policy';
}
if (preg_match("/Webkit/", $UA)) {
    $CSP = 'X-WebKit-CSP';
}

// header($CSP.": default-src 'self'; style-src 'self' 'unsafe-inline'; script-src 'self' 'unsafe-eval' 'unsafe-inline' *.disqus.com *.disquscdn.com ssl.google-analytics.com https://speakerdeck.com https://apis.google.com; connect-src *.justfont.com *.disqus.com; font-src *.justfont.com themes.googleusercontent.com; img-src 'self' *.disqus.com *.disquscdn.com http://*.static.flickr.com *.static.flickr.com *.staticflickr.com https://ssl.google-analytics.com; frame-src disqus.com *.google.com www.facebook.com platform.twitter.com speakerdeck.com www.youtube.com http://embed.ted.com;");
header($CSP.": default-src 'none'; script-src 'self' *.twitter.com *.disqus.com *.disquscdn.com ssl.google-analytics.com speakerdeck.com apis.google.com; style-src 'self' platform.twitter.com *.disquscdn.com; img-src 'self' pbs.twimg.com *.twitter.com *.disqus.com *.disquscdn.com *.static.flickr.com *.static.flickr.com *.staticflickr.com ssl.google-analytics.com data:; frame-src embed-ssl.ted.com syndication.twitter.com disqus.com *.google.com www.facebook.com platform.twitter.com speakerdeck.com www.youtube.com http://embed.ted.com; font-src themes.googleusercontent.com; connect-src 'self' *.disqus.com");

header('link: </stylesheets/bootstrap/css/bootstrap.min.css>; rel=preload; as=stylesheet', false);
header('link: </stylesheets/bootstrap/css/bootstrap-responsive.min.css>; rel=preload; as=stylesheet', false);
header('link: </stylesheets/othree.min.css>; rel=preload; as=stylesheet', false);

echo $output;


//xsl transform function
function xslt($xml, $xsl, $canonical, $mime, $dpr, $w) {
    if (preg_match("/^5/",phpversion()) && (extension_loaded('xsl') || dl("xsl".$suffix))) {
    // if (preg_match("/^5/",phpversion()) && (extension_loaded('xsl'))) {
        $xmlo = new DOMDocument; // from /ext/dom
        $xmlo->load($xml);
        $xslo = new DOMDocument;
        $xslo->load($xsl);

        // Configure the transformer
        $proc = new XSLTProcessor;

        // $proc = new XML_XSLT2Processor('SAXON9', './saxon/saxon9he.jar', 'JAVA-CLI');

        $proc->importStyleSheet($xslo); // attach the xsl rules
        $proc->setParameter('blog.othree.net', 'ext', '');
        $proc->setParameter('blog.othree.net', 'canonical', $canonical);
        $proc->setParameter('blog.othree.net', 'mime', $mime);
        $proc->setParameter('blog.othree.net', 'dpr', $dpr);
        $proc->setParameter('blog.othree.net', 'w', $w);
        return $proc->transformToXML($xmlo); // actual transformation
    } else {
        header("Content-type: text/html; charset=UTF-8");
        echo "We have some problem. Try <a href=\"http://blog.othree.net/xml\">alternative version</a>";
        exit;
    }
}

?>
