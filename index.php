<?php

error_reporting(0);
// error_reporting(E_ALL);

if (!isset($xsl)) {
  $xsl = 'main.xsl';
}

$query = $_GET['f'];

if (preg_match("/_/", $query)) {
    header("HTTP/1.1 301 Moved Permanently");
    header("Location: https://blog.othree.net".preg_replace("/_/", "-", $query));
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
$canonical = 'https://blog.othree.net' . explode('?', $_SERVER['REQUEST_URI'])[0];

if ($xsl == 'amp.xsl') {
  $canonical = preg_replace('/amp\/$/', '', $canonical);
}

$format = "html";
$target_file = substr($query, 1);
$hash_file = substr($target_file, 0, -4) . '.md5';
$html_file = substr($target_file, 0, -4) . '.html';

if (is_file($target_file)) {
    if (!is_file($hash_file) || filemtime($target_file) > filemtime($hash_file)) {
        $hash = hash_file('md5', $target_file);
        file_put_contents($hash_file, $hash);
    } else {
        $hash = file_get_contents($hash_file);
    }
}

$request_hash = $_SERVER['HTTP_IF_NONE_MATCH'];

if (isset($request_hash) && $request_hash == 'W/"'.$hash.'"') {
    header("Cache-Control: max-age=3600, public");
    header("Expires: ".gmdate('D, d M Y H:i:s \G\M\T', time() + 3600));
    header("HTTP/1.0 304 Not Modified");
    exit;
} else {
    header("ETag: \"".$hash."\"");
}

$UA = $_SERVER['HTTP_USER_AGENT'];

//output string
if ($format == "html") {
    if (preg_match("/application\/xhtml\+xml/", $_SERVER['HTTP_ACCEPT'] || preg_match("/W3C/", $UA))) $format = 'xhtml';
    //compitable fix for IE or nonIE
    $patterns = array("/<(script|textarea|iframe)((\s+[\w-]+=(\w+|\"[^\"]*\"|\'[^\']*\'))*)\/>/",
        "/([\"\'])\/>/",
        "/ *<(\/?(pre|code))> */is",
        "/&(?!(amp|lt|gt|nbsp);)/");
    $replacements = array("<\\1\\2></\\1>",
        "\\1 />",
        "<\\1>",
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
    $raw_output = '';

    if (file_exists($html_file) && file_exists($md5_file) && filemtime($html_file) > filemtime($md5_time)) {
        $raw_output = file_get_contents($html_file);
    } else {
        $raw_output = xslt($target_file, $xsl, $canonical, $format, $dpr, $w);
        file_put_contents($html_file, $raw_output);
    }

    $output = preg_replace($patterns, $replacements, $raw_output);
} else if ($format == "xml") {
    $handle = fopen($target_file, "r");
    $output = fread($handle, filesize($target_file));

    fclose($handle);

    if (preg_match("/IE/", $UA)) {
	header("Content-type: text/xml; charset=UTF-8");
    } else {
	header("Content-type: application/xml; charset=UTF-8");
    }
}

echo $output;


//xsl transform function
function xslt($xml, $xsl, $canonical, $mime, $dpr, $w) {
    if (preg_match("/^[78]/",phpversion()) && (extension_loaded('xsl') || dl("xsl".$suffix))) {
    // if (preg_match("/^5/",phpversion()) && (extension_loaded('xsl'))) {
        $xmlo = new DOMDocument; // from /ext/dom
        $xmlo->load($xml);
        $xslo = new DOMDocument;
        $xslo->load($xsl);

        // Configure the transformer
        $proc = new XSLTProcessor;

        $proc->importStyleSheet($xslo); // attach the xsl rules
        $proc->setParameter('blog.othree.net', 'ext', '');
        $proc->setParameter('blog.othree.net', 'canonical', $canonical);
        $proc->setParameter('blog.othree.net', 'mime', $mime);
        $proc->setParameter('blog.othree.net', 'dpr', $dpr);
        $proc->setParameter('blog.othree.net', 'w', $w);
        return $proc->transformToXML($xmlo); // actual transformation
    } else {
        header("Content-type: text/html; charset=UTF-8");
        echo "We have some problem. Please try again later";
        exit;
    }
}

?>
