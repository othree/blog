<?php
/* vim: set expandtab tabstop=4 shiftwidth=4 softtabstop=4: */

/**
 * @summary@
 *
 * By using previously installed SAXON or AltovaXML, this class allows the user
 * to execute XSLT 2.0 transformations within PHP. Should work on all platforms.
 *
 * PHP version 5
 *
 * @package    @name@
 * @category   XML
 * @author     Vasil Rangelov <boen.robot@gmail.com>
 * @copyright  2007 Vasil Rangelov
 * @license    http://www.gnu.org/copyleft/lesser.html  LGPL License 2.1
 * @link       http://xslt2processor.sourceforge.net
 * @version    Release: @version@
 */

/**
 * Used in {@link XML_XSLT2Processor::importStylesheet()} to use the stylesheet
 * specified by the "xml-stylesheet" processing instruction.
 */
define('XML_XSLT2PROCESSOR_PI', true);

/**
* Error holder
*
* This class is used as a holder for error information. It has no methods
* and the following properties.
*/
class XML_XSLT2Processor_Error
{
    /**
    * The error's code. Only populated on SAXON errors and internal error
    * messages.
    * @var int|string
    */ 
    public $code;
    /**
    * The column where the error occurred. Only populated in AltovaXML
    * and some SAXON errors.
    * @var int
    */ 
    public $column;
    /**
    * The filepath, or empty if the XML was loaded by libxml.
    * @var string
    */
    public $file;
    /**
    * The severity of the error. For compatability with the original
    * XSL class, one of the LIBXML_ERR_* constants is used as a value.
    * @var int
    */
    public $level;
    /**
    * The line where the error occurred. 
    * @var int
    */
    public $line;
    /**
    * The error message.
    * @var string
    */
    public $message;
}

/**
 * The main class which this package defines.
 */
class XML_XSLT2Processor
{
    /**
     * Shows the last command that XML_XSLT2Processor attempted to execute
     * on the (JAVA-)CLI interface. Empty by default and remains that way
     * when another interface is used. Useful when debugging.
     * Available since version 0.1.3.
     * @var string
     */
    public $command;
    /**
     * An associative array of options for use in subsequent
     * transformations. Unknown options and values will be ignored.
     * Available since version 0.3.0.
     * @var array
     */
    public $options = array();
    /**#@+
     * @var string
     */
    protected $stylesheet, $processor, $interface, $processorPath,
            $processorVersion, $runtime;
    /**#@+
     * @var object
     */
    protected $instance;
    protected $errors;
    /**#@+
     * @var array
     */
    protected $params = array();
    protected $tmpFiles = array();
    /**
     * Shows the status with which the last (JAVA-)CLI execution finished.
     * @var int
     */
    protected $status;
    /**
     * Turn a URL into a filepath
     *
     * Because this package deals with the command line and yet aims to be as
     * simple as possible, there was a need for a function to turn URLs into
     * filepaths. This is this solution. It's not exactly a very good one,
     * which is why checks are performed along the way.
     * @access private
     * @param string $url The adress that will be turned into a file path.
     * @param string $base A base filepath, against which relative URIs will be
     * resolved.
     * @return string The equivalent file path of the supplier URL with proper
     * OS slashes, and with a prepended base if it's relative.
     */
    private static function _url2filepath($url, $base = null)
    {
        if ($base === null) {
            $base = getcwd();
        }
        $durl = urldecode($url);
        $fs = '/';
        $fsr = '\/';
        if (preg_match("#^$fsr#", $durl)) {
            if (file_exists($fs)) {
                //This is a UNIX file path.
                return $url;
            }
            //If it's a path relative to the document root.
            $result = $_SERVER['DOCUMENT_ROOT'] . $durl;
        }elseif (preg_match('#^file\:\/\/\/#', $durl)) {
            //If it uses the file protocol to target the current machine.
            $result = strtr(substr($durl, 8), '|', ':');
        }elseif (preg_match('#^file\:\/#', $durl)) {
            //If it uses the file protocol to target the current machine.
            $result = strtr(substr($durl, 6), '|', ':');
        }else {//Everything else is (assumed to be) a relative path.
            $result = $base . DIRECTORY_SEPARATOR . $durl;
        }
        //Return the filepath with the proper OS slashes.
        return (preg_match("#$fsr#", $base) ? $result : strtr($result, $fs, '\\'));
    }
    
    /**
     * @access private
     * @param $string the string from which the substring will be extracted.
     * @param $after the string after which the substring will be extracted.
     * @param $before the string before which the substring will be extracted.
     * @return string The matched substring.
     */
    private static function _substring_between($string, $after, $before = null)
    {
        if ($after !== null) {
            $string = substr(strstr($string, $after), strlen($after));
        }
        if ($before !== null) {
            $string = strrev(substr(strstr(strrev($string), strrev($before)), strlen($before)));
        }
        return $string;
    }
    
    /**
     * Creates an error log entry
     * @access private
     * @param string $error The error message to write.
     * @param bool $internal Whether the error is internal or not.
     */
    private function _createErrorLogEntry($error, $internal = false) {
        $errorLog = new DOMDocument('1.0', 'UTF-8');
        $root = '<errorLog/>';
        if (!defined('XML_XSLT2PROCESSOR_ERROR_LOG')) {
            define('XML_XSLT2PROCESSOR_ERROR_LOG', tempnam(getcwd(), 'ERROR_LOG_'));
            $this->tmpFiles[] = XML_XSLT2PROCESSOR_ERROR_LOG;
            $errorLog->loadXML($root);
            $errorLog->save(XML_XSLT2PROCESSOR_ERROR_LOG);
        }
        if(!is_file(XML_XSLT2PROCESSOR_ERROR_LOG)) {
            file_put_contents(XML_XSLT2PROCESSOR_ERROR_LOG, $root);
        }
        $errorLog->load(XML_XSLT2PROCESSOR_ERROR_LOG);
        $errorLogInstance = $errorLog->createElement('instance', $error);
        foreach ($this->tmpFiles as $file) {
            $errorLogInstance->appendChild($errorLog->createElement('tmpFile', $file));
        }
        $errorLogInstance->setAttribute('processor', ($internal === false ? $this->processor : '__INTERNAL__'));
        $errorLogInstance->setAttribute('interface', $this->interface);
        $errorLog->documentElement->appendChild($errorLogInstance);
        $errorLog->save(XML_XSLT2PROCESSOR_ERROR_LOG);
    }
    
    /**
     * Validates a string against a specified schema datatype.
     *
     * @param string $input The string to validate.
     * @param string $type The schema datatype to validate against.
     * @return bool Returns TRUE on success or FALSE on failure.
     */
    private function _validAgainstSchemaType($input, $type = 'anySimpleType') {
        if (is_string($input)) {
            $doc = "<i>$input</i>";
        }else {
            return false;
        }
        $dom = new DOMDocument;
        $dom->loadXML($doc);
        return @$dom->schemaValidateSource('<x:schema xmlns:x="http://www.w3.org/2001/XMLSchema"><x:element name="i" type="x:' . $type . '"/></x:schema>');
    }

    /**
     * Creates a new XML_XSLT2Processor object
     *
     * Creates a new XML_XSLT2Processor object.
     * @param string $processor The desired XSLT 2.0 processor to use.
     * Only "AltovaXML" and "SAXON" are supported. Since v0.5.0, you can also
     * specify "SAXON8" or "SAXON9" to fine tune the SAXON version. Default is
     * "SAXON", which is locked into the latest SAXON version supported
     * (currently - 9). This value is case insensitive.
     * @param string $processorPath The location of the XSLT 2.0 processor
     * executable or JAVA archive. If omitted (set to NULL), the PATH will be
     * used with the default command of the processor. When SAXON is used, the
     * SAXON_HOME environmental variable takes precendance over the PATH if
     * present. Since v0.5.2, when AltovaXML on the COM interface is used, this
     * is used as the DCOM server. Since v0.5.3, this can also be an associative
     * array with the keys "processor" and "runtime". The key "processor" is
     * equivalent to using a string, and "runtime" is applicable only to the
     * JAVA-CLI interface, where it points to the path to the JRE executable.
     * @param string $interface The interface by which you want to use the
     * specified XSLT 2.0 processor. Default is "CLI". If you want to use a
     * processor from a JAVA archive, you need to use "JAVA-CLI" instead. For
     * the COM interface, use "COM" as a value.
     */
    public function __construct($processor = 'SAXON', $processorPath = null, $interface = 'CLI')
    {
        if (preg_match('/^SAXON/i', $processor)) {
            $this->processor = 'SAXON';
            $pv = $this->_substring_between(strtoupper($processor), 'SAXON');
            $this->processorVersion = (empty($pv) ? '9he' : $pv);
        }elseif (preg_match('/^AltovaXML$/i', $processor)) {
            $this->processor = 'AltovaXML';
        }else {
            throw new Exception('Unsupported XSLT processor provided to XML_XSLT2Processor::__construct()', 1);
        }
        
        //"|\.NET" will be added once issues with actually testing it are over.
        if (preg_match('/^(JAVA|(JAVA\-)?CLI|COM)$/', $interface)) {
            $this->interface = $interface;
            if ($interface === 'COM' && $this->processor === 'AltovaXML') {
                if (!extension_loaded('com_dotnet')) {
                    throw new Exception('The COM interface requires the COM extension, but the COM extension is not available', 6);
                }else {
                    $this->instance = new COM('AltovaXML.Application', $processorPath);
                }
                return;
            }elseif (!(preg_match('/^(JAVA|(JAVA\-)?CLI)$/', $interface) && $this->processor === 'SAXON') && !($interface === 'CLI' && $this->processor === 'AltovaXML')) {
                throw new Exception("The supplied XSLT 2.0 processor ({this->processor}) does not support the supplied interface ({$interface}) provided to XML_XSLT2Processor::__construct()", 5);
            }
        }else {
            throw new Exception('Unsupported interface for XSLT 2.0 processors provided to XML_XSLT2Processor::__construct()', 3);
        }

            $runtimeFound = $processorPathFound = false;
            if ($interface === 'CLI') {
                $runtimeFound = true;
            }
            if (is_string($processorPath) || (is_array($processorPath) && !empty($processorPath['processor']))) {
                $this->processorPath = is_string($processorPath) ? $this->_url2filepath($processorPath) : $this->_url2filepath($processorPath['processor']);
                if ((!is_executable($this->processorPath) && !(bool)preg_match('/^JAVA|\.NET/', $interface)) || (!is_file($this->processorPath) && preg_match('/^JAVA|\.NET/', $interface))) {
                    $this->processorPath = null;
                    throw new Exception('Invalid path to XSLT processor binary given to XML_XSLT2Processor::__construct()', 2);
                }
                $processorPathFound = true;
            }
            if (!$runtimeFound && is_array($processorPath) && !empty($processorPath['runtime'])) {
                $this->runtime = $this->_url2filepath($processorPath['runtime']);
                if (!is_executable($this->runtime)) {
                    $this->runtime = null;
                    throw new Exception('Invalid path to JRE given to XML_XSLT2Processor::__construct()', 7);
                }
                $runtimeFound = true;
            }
            if ($runtimeFound && $processorPathFound) {
                return;
            }
            $execFile = $this->processor === 'SAXON' ? ($interface === 'CLI' ? 'Transform.exe' : "saxon{$this->processorVersion}.jar") : 'AltovaXML.exe';
            $sysPath = array_merge(array(getcwd()), ($this->processor === 'SAXON' ? explode(PATH_SEPARATOR, getenv('SAXON_HOME')) : array()), explode(PATH_SEPARATOR, getenv('PATH')));
            $sysExt = explode(PATH_SEPARATOR, getenv('PATHEXT'));
            if (is_array($sysExt)) {
                array_map('strtolower', $sysExt);
            }
            $isReal = $interface === 'CLI' ? 'is_executable' : 'is_file';
            foreach ($sysPath as $possiblePath) {
                if (!$processorPathFound && $isReal($possiblePath . DIRECTORY_SEPARATOR . $execFile)) {
                    $this->processorPath = $possiblePath . DIRECTORY_SEPARATOR . $execFile;
                    $processorPathFound = true;
                }
                if (!$runtimeFound) {
                    if (empty($sysExt)) {
                        if (is_executable($possiblePath . DIRECTORY_SEPARATOR . 'java')) {
                            $this->runtime = $possiblePath . DIRECTORY_SEPARATOR . 'java';
                            $runtimeFound = true;
                        }
                    }else {
                        foreach ($sysExt as $possibleExt) {
                            if (is_executable($possiblePath . DIRECTORY_SEPARATOR . 'java' . $possibleExt)) {
                                $this->runtime = $possiblePath . DIRECTORY_SEPARATOR . 'java' . $possibleExt;
                                $runtimeFound = true;
                            }
                        }
                    }
                }
                if ($processorPathFound && $runtimeFound) {
                    return;
                }
            }
            if (!$processorPathFound) {
                throw new Exception('Unable to automatically resolve path to XSLT processor binary in XML_XSLT2Processor::__construct()', 4);
            }
            if (!$runtimeFound) {
                throw new Exception('Unable to automatically resolve path to JRE binary in XML_XSLT2Processor::__construct()', 4);
            }
    }

    /**
     * Determine if the desired XSLT processor has EXSLT support
     *
     * This method determines if the desired
     * XSLT processor has EXSLT support.
     * @return bool Returns TRUE when the processor is SAXON or FALSE
     * on AltovaXML. Unfortunately, current XSLT processors don't
     * seem to provide any further information about EXSLT support
     * they have, making this sort of "pseudo" implementation
     * of the original function.
     */
    public function hasExsltSupport()
    {
        switch($this->processor) {
        case 'SAXON':
            return true;
        case 'AltovaXML':
            return false;
        }
    }

    /**
     * Import stylesheet
     *
     * This method imports the specified stylesheet into the
     * XML_XSLT2Processor for transformations.
     * @param mixed $stylesheet The imported stylesheet as a DOMDocument
     * object or a string, representing the location of the file.
     * This parameter can also use the {@link XML_XSLT2PROCESSOR_PI} constant as
     * a value, in which case the stylesheet will be looked for in the
     * processing instruction of the source XML file.
     * @return bool Returns TRUE if the stylesheet exists. If an object is
     * supplied, it returns TRUE if it's any DOMDocument object. FALSE on error.
     * Prior to version 0.3.3, no value was returned.
     */
    public function importStylesheet($stylesheet)
    {
        try {
            if ($stylesheet instanceof DOMDocument) {
                $this->stylesheet = tempnam((($stylesheetLocation = $this->_url2filepath($stylesheet->documentURI)) === realpath(getcwd() . DIRECTORY_SEPARATOR) ? getcwd() : dirname($stylesheetLocation)), 'XSL_TEMP');
                file_put_contents($this->stylesheet, $stylesheet->saveXML());
                $this->tmpFiles[] = $this->stylesheet;
                return true;
            }elseif ($stylesheet === XML_XSLT2PROCESSOR_PI) {
                $this->stylesheet = XML_XSLT2PROCESSOR_PI;
                return true;
            }elseif (is_string($stylesheet)) {
                if (is_file($stylesheet)) {
                    $this->stylesheet = $this->_url2filepath($stylesheet);
                    return true;
                }else {
                    throw new Exception('The stylesheet "' . $stylesheet . '" was not found at the specified location.', 101);
                }
            }else {
                throw new Exception('Invalid argument for stylesheet supplied. If you have tried to supply a DOMDocument object, it is possible that the XSLT file is not a well formed XML document. Check with the libxml funcitons for details.', 102);
            }
        }
        catch (Exception $e) {
            $trace = $e->getTrace();
            $this->_createErrorLogEntry('<m c="' . $e->getCode() . '" f="' . $trace[count($trace) - 1]['file'] . '" l="' . $trace[count($trace) - 1]['line'] . '">' . $e->getMessage() . '</m>', true);
            return false;
        }
    }

    /**
     * Set value for a parameter
     *
     * Sets the value of one or more parameters to be used in subsequent
     * transformations with XML_XSLT2Processor. If the parameter doesn't exist
     * in the stylesheet, or is in unsupported mode, it will be ignored.
     * @param string $namespace The namespace of the parameter that will be set.
     * @param mixed $name The local name of the XSLT parameter.
     * @param string $value The new value of the XSLT parameter.
     * @param string $mode Specifies a mode to pass the parameter as.
     *
     * The value can be "STRING" (the default), in which case the value is
     * literally passed (almost... "<",">","&","'" are escaped from the command
     * line) or "SAFE-STRING" in which case all characters are escaped. This is
     * useful to pass special characters which can't be otherwise entered in the
     * command line (pretty much any non ASCII character). The value of this
     * argument can also be "FILE" in which case the $value is treated as a path
     * to a file, the contents of which will be used as the value for the
     * parameter.
     *
     * Additionally, AltovaXML supports "EXPRESSION" in which the value is not
     * escaped at all, but is treated as an XPath expression.
     *
     * SAXON doesn't support "EXPRESSION", but supports "OUTPUT" which sets the
     * parameter as if specified by the <xsl:output/> element.
     *
     * Since version 0.5.0, the value of this parameter can also be 'OPTION', in
     * which case an option for this processor will be set. For a description of
     * each option name and its possible values, see
     * {@link XML_XSLT2Processor::options}.
     * @return bool Returns TRUE on success or FALSE on failure.
     * @see XML_XSLT2Processor::getParameter()
     * @see XML_XSLT2Processor::removeParameter()
     */
    public function setParameter($namespace, $name, $value = null, $mode = null)
    {
        try {
            if ((is_array($name) && (is_null($value) || is_string($value))) && !is_null($mode)) {
                throw new Exception('Forth argument supplied to XML_XSLT2Processor::setParameter() but was not expected.', 201);
            }
            if (!is_null($namespace) && !$this->_validAgainstSchemaType($namespace, 'anyURI')) {
                throw new Exception('The supplied namespace is not a valid URI.', 202);
            }
            if (!is_array($name) && !is_null($value)) {
                $name = array($name => $value);
                $value = $mode;
                unset($mode);
            }
            if ($value !== 'OPTION') {
                $trueParams = array();
                $valErrors = array();
                foreach ($name as $param=>$paramValue) {
                    if (!is_string($param) || !$this->_validAgainstSchemaType($param, 'NCName')) {
                        $valErrors[] = array(203, 'Invalid parameter name supplied to XML_XSLT2Processor::setParameter(). Parameter names must be NCNames.');
                    }elseif (!is_scalar($paramValue) && (!is_object($paramValue) || !method_exists($paramValue, '__toString'))) {
                        $valErrors[] = array(204, 'The value of the parameter "' . $param . '" supplied to XML_XSLT2Processor::setParameter() could not be converted to a string. You need to specify a scalar value, or an object that implements the "__toString" magic method.');
                    }else {
                        $trueParams[$param] = (string) $paramValue;
                    }
                }
                if (!empty($trueParams)) {
                    $this->params[] = array($namespace, $trueParams, (is_null($value) ? 'STRING' : $value));
                }
                if (empty($valErrors)) {
                    return true;
                }else {
                    throw new Exception(serialize($valErrors), 0);
                }
            }elseif ($namespace !== null) {
                throw new Exception('The supplied option(s) to XML_XSLT2Processor::setParameter() are not in a known namespace. Try to use NULL instead.', 205);
            }else {
                $options = array(
                    'SAXON' => array(
                        'TREE_MODEL' => array('TINY', 'LINKED'),
                        'STRIP_WHITE_SPACE' => array('NONE', 'ALL', 'IGNORABLE'),
                        'DTD_VALIDATION' => array(true, false),
                        'SCHEMA_VALIDATION' => array(true, false, 'LAX'),
                        'OUTPUT_VALIDATION' => array(true, false),
                        'ERROR_LEVEL' => array('SILENT', 'WARN', 'ERROR'),
                        'XML_VERSION' => array('1.0', '1.1'),
                        'DISABLE_EXTENSION_FUNCTIONS' => array(true, false),
                        'VERSION_WARNING' => array(true, false),
                        'SCHEMA_AWARE' => array(true, false)
                    ),
                    'AltovaXML' => array(
                        'XSLT_STACK_SIZE' => 100
                    )
                );
                $trueOptions = array();
                $valErrors = array();
                $transConst = create_function('$member', 'return ($member === false ? "FALSE" : ($member === true ? "TRUE" : ($member === null ? "NULL" : "\'$member\'")));');
                foreach ($name as $option => $optionValue) {
                    if (!array_key_exists($option, $options[$this->processor])) {
                        $valErrors[] = array(206, 'The supplied option "' . $option . '" to XML_XSLT2Processor::setParameter() is not supported by this XSLT processor.');
                    }else {
                        if (!((is_array($options[$this->processor][$option]) && in_array($optionValue, $options[$this->processor][$option], true)) || (is_int($options[$this->processor][$option]) && $optionValue >= $options[$this->processor][$option]))) {
                            $valErrors[] = array(207, 'The supplied to XML_XSLT2Processor::setParameter() value "' . $transConst($optionValue) . '" is not valid for the option "' . $option . '". ' . (is_array($options[$this->processor][$option]) ? 'Allowed values for this option are ' . implode(', ', array_map($transConst, $options[$this->processor][$option])) : 'You need to specify a value larger than or equal to ' . $options[$this->processor][$option]) . '.');
                        }else {
                            $this->options[$option] = $optionValue;
                        }
                    }
                }
                if (empty($valErrors)) {
                    return true;
                }else {
                    throw new Exception(serialize($valErrors), 0);
                }
            }
        }
        catch (Exception $e) {
            $trace = $e->getTrace();
            $file = $trace[count($trace) - 1]['file'];
            $line = $trace[count($trace) - 1]['line'];
            if ($e->getCode() !== 0) {
                $this->_createErrorLogEntry('<m c="' . $e->getCode() . '" f="' . $file . '" l="' . $line . '" s="' . LIBXML_ERR_WARNING .'">' . $e->getMessage() . '</m>', true);
            }else {
                $preMessage = '<m f="' . $file . '" l="' . $line . '" s="' . LIBXML_ERR_WARNING .'"';
                foreach (unserialize($e->getMessage()) as $error) {
                    $this->_createErrorLogEntry($preMessage . ' c="' . $error[0] . '">' . $error[1] . '</m>', true);
                }
            }
            return false;
        }
    }

    /**
     * Get value of a parameter
     *
     * Gets the value of a parameter if previously set by
     * {@link XML_XSLT2Processor::setParameter}.
     * @param string $namespace The namespace URI of the XSLT parameter. Note
     * that while namespace is not applied with AltovaXML, it must be used in
     * order to be fetched.
     * @param string $name The local name of the XSLT parameter.
     * @param string $mode Specifies a mode the parameter must be in. If the
     * parameter was set with a value different then "STRING", this parameter
     * must be specified in order to get the expected value. For detailed
     * description of each mode, look in
     * {@link XML_XSLT2Processor::setParameter()}.
     * @return string The value of the parameter.
     * @see XML_XSLT2Processor::setParameter()
     * @see XML_XSLT2Processor::removeParameter()
     */
    public function getParameter($namespace, $name, $mode = 'STRING')
    {
        if ($mode == 'OPTION') {
            return $namespace !== null ? null : @$this->options[(string) $name];
        }
        $fetched = array();
        foreach ($this->params as $param) {
            if ($param[0] == $namespace && key($param[1]) == $name && $param[2] == $mode) {
                $fetched[] = current($param[1]);
            }
        }
        return array_pop($fetched);
    }

    /**
     * Remove parameter
     *
     * Removes the value of a parameter if previously set by
     * {@link XML_XSLT2Processor::setParameter()}. This will make the processor
     * use the default value for the parameter as specified in the stylesheet.
     * @param string $namespace The namespace URI of the XSLT parameter. Note
     * that while namespace is not applied with AltovaXML, it must be used in
     * order to be removed.
     * @param string $name The local name of the XSLT parameter.
     * @param string $mode Specifies a mode the parameter must be in. If the
     * parameter was set with a value different then "STRING", this parameter
     * must be specified in order to remove the expected value. For detailed
     * description of each mode, look in
     * {@link XML_XSLT2Processor::setParameter()}.
     * @return bool Returns TRUE on success or FALSE on failure.
     * @see XML_XSLT2Processor::getParameter()
     * @see XML_XSLT2Processor::setParameter()
     */
    public function removeParameter($namespace, $name, $mode = 'STRING')
    {
        if ($mode == 'OPTION') {
            if ($namespace !== null) {
                return false;
            }
            $existedBefore = @array_key_exists((string) $name, $this->options);
            unset($this->options[(string) $name]);
            return ($existedBefore ? true : false);
        }
        $paramsBefore = count($this->params);
        foreach ($this->params as $instance => $param) {
            if ($param[0] == $namespace && key($param[1]) == $name && $param[2] == $mode) {
                unset($this->params[$instance]);
            }
        }
        if ($paramsBefore === count($this->params)) {
            return false;
        }else {
            return true;
        }
    }

    /**
     * Transform to URI
     *
     * Transforms the input source document specified by the argument to this
     * function to a URI by using the stylesheet specified by
     * {@link XML_XSLT2Processor::importStylesheet()}. If you use SAXON, you can
     * also transform a folder of input documents with the same stylesheet to
     * another folder where the output documents will be written. Note that both
     * arguments must be folders in that case.
     * @param mixed $xml The document to be transformed as a DOMDocument object
     * or a string, representing the location of the file/folder.
     * @param string $uri The desired location of the output file. If using
     * SAXON to do a folder to folder transformation, beware that the output
     * folder must already exist.
     * @return int Returns the number of bytes written or FALSE on error. If
     * used with SAXON to transform a folder of input documents to a folder with
     * output documents, it returns TRUE, regardless of how many files were
     * successfully transformed.
     * @see XML_XSLT2Processor::transformToDoc()
     * @see XML_XSLT2Processor::transformToXML()
     */
    public function transformToURI($xml, $uri)
    {
        $output = in_array($uri, $this->tmpFiles, true) ? $uri : $this->_url2filepath($uri);
        //load the XML file
        if (!$xml instanceof DOMDocument) {
            try {
                if (is_string($xml)) {
                    $conditionSourceFolder = is_dir($xml);
                    $conditionOutputFolder = is_dir($output);
                    if ($conditionSourceFile = is_file($xml) || ($conditionSourceFolder && $conditionOutputFolder && $this->processor === 'SAXON')) {
                        $source = $this->_url2filepath($xml);
                    }else {
                        //Only triggered on errors
                        if ($conditionSourceFolder && $conditionOutputFolder && $this->processor !== 'SAXON') {
                            throw new Exception('The folder transformation feature is only available to SAXON.', 401);
                        }elseif (in_array($uri, $this->tmpFiles, true) || $this->processor !== 'SAXON' || ($this->processor === 'SAXON' && !($conditionOutputFolder || $conditionSourceFolder))) {
                            if (!$conditionSourceFile) {
                                throw new Exception('The source file was not found at the specified location.', 402);
                            }
                        }else {
                            if (!$conditionSourceFolder) {
                                throw new Exception('The source folder was not found at the specified location.', 403);
                            }elseif (!$conditionOutputFolder) {
                                throw new Exception('The output folder was not found at the specified location. You must create it before the transformation.', 404);
                            }
                        }
                    }
                }else {
                    throw new Exception('Invalid argument for source document supplied. If you have tried to supply a DOMDocument object, it is possible that the XML file is not well formed. Check with the libxml funcitons for details.', 405);
                }
            }
            catch (Exception $e) {
                $trace = $e->getTrace();
                $this->_createErrorLogEntry('<m c="' . $e->getCode() . '" f="' . $trace[count($trace) - 1]['file'] . '" l="' . $trace[count($trace) - 1]['line'] . '">' . $e->getMessage() . '</m>', true);
                return false;
            }
        }else {
            $source = tempnam(($this->_url2filepath($xml->documentURI) === getcwd() . DIRECTORY_SEPARATOR ? getcwd() : dirname($this->_url2filepath($xml->documentURI))), 'XML_TEMP');
            file_put_contents($source, $xml->saveXML());
            $this->tmpFiles[] = $source;
        }
        $commandOptions = ' ';
        /* Select the stylesheet from the PI if specified. It may not make sence
        but this is done here, because only now we actually know which is the
        source XML file. */
        if ($this->stylesheet === XML_XSLT2PROCESSOR_PI) {
            //SAXON/(JAVA-)CLI has a native support for this which we'll use.
            if ($this->processor === 'SAXON' && preg_match('/CLI$/', $this->interface)) {
                $commandOptions .= ' -a ';
            }else {
                //An attempt to provide a support for this in other processors.
                if ($xml instanceof DOMDocument) {
                    $input = $xml;
                    unset($xml);
                }elseif (is_string($source)) {
                    $input = new DOMDocument;
                    $input->load($source);
                }
                $xpi = new DOMXPath($input);
                $piList = $xpi->query('/processing-instruction("xml-stylesheet")');
                $piStylesheet = '';
                for ($i=0; $i<$piList->length; $i++) {
                    $piStylesheet .= '<s ' . $piList->item($i)->data . '/>';
                }
                $xps = new DOMXPath(@DOMDocument::loadXML('<l>' . $piStylesheet . '</l>'));
                $xslpi = @$xps->query('/l//s[@type="text/xsl" or @type="application/xml" or @type="text/xml"][1]/@href')->item(0)->nodeValue;
                if (is_file($rStylesheet = $this->_url2filepath($xslpi, (($stylesheetLocation = $this->_url2filepath($input->documentURI)) === getcwd() . DIRECTORY_SEPARATOR ? getcwd() : dirname($stylesheetLocation))))) {
                    $this->stylesheet = $rStylesheet;
                }else {
                    $this->_createErrorLogEntry('<m c="501" f="' . $source . '">The processing instruction was not properly resolved to an existing XSLT stylesheet. There may not be an appropriate XML processing instruction or the existing XML processing instruction leading to the XSLT stylesheet may contain wrong data, or the stylesheet may not exist at the resolved location (' . $rStylesheet . ').</m>', true);
                    return false;
                }
            }
        }
        if (preg_match('/CLI$/', $this->interface)) {
            $params = ' ';
            $inputs = array('source' => realpath($source), 'stylesheet' => realpath($this->stylesheet), 'output' => $output);
            $inputs = str_replace(' ', '" "', $inputs);
            if ($this->processor === 'SAXON') {
                //Prepare the SAXON parameters.
                foreach ($this->params as $param) {
                    $name = key($param[1]);
                    $value = current($param[1]);
                    switch ($param[2]) {
                    case 'STRING':
                        $mode = null;
                        break;
                    case 'SAFE-STRING':
                        $mode = '+';
                        $paramDom = new DOMDocument('1.0', 'UTF-8');
                        $paramDomE = $paramDom->createElement('a', $value);
                        $paramDom->appendChild($paramDomE);
                        $paramTmpUri = tempnam(getcwd(), 'PARAM_TEMP_' . $name);
                        $paramDom->save($paramTmpUri);
                        $this->tmpFiles[] = $paramTmpUri;
                        $value = $paramTmpUri;
                        break;
                    case 'OUTPUT':
                        $mode = '!';
                        break;
                    case 'FILE':
                        $mode = '+';
                        $value = $this->_url2filepath($value);
                        break;
                    default:
                        //Go to the next parameter if set to unsupported mode.
                        continue 2;
                    }
                    $params .= '"' . (!$mode == '!' ? $mode . '{' . $param[0] . '}' : $mode) . $name . '=' . preg_replace('/\\\$/m', '\\\\\\', str_replace(array('"', '&', '<', '>'), array('\"', '"&"', '"<"', '">"'), $value)) . '" ';
                }
                //Set the SAXON options.
                if (!empty($this->options) && is_array($this->options)) {
                    if (isset($this->options['SCHEMA_AWARE']) && $this->options['SCHEMA_AWARE'] === true) {
                        $commandOptions .= ' -sa ';
                    }
                    switch($this->processorVersion) {
                    case 8:
                        foreach ($this->options as $option=>$value) {
                            switch ($option) {
                            case 'TREE_MODEL':
                                switch ($value) {
                                case 'TINY':
                                    $commandOptions .= ' -dt ';
                                    break 2;
                                case 'LINKED':
                                    $commandOptions .= ' -ds ';
                                    break 2;
                                default:
                                    continue 2;
                                }
                            case 'STRIP_WHITE_SPACE':
                                switch ($value) {
                                case 'NONE':
                                    $commandOptions .= ' -snone ';
                                    break 2;
                                case 'ALL':
                                    $commandOptions .= ' -sall ';
                                    break 2;
                                case 'IGNORABLE':
                                    $commandOptions .= ' -signorable ';
                                    break 2;
                                default:
                                    continue 2;
                                }
                            case 'DTD_VALIDATION':
                                if ($value === true) {
                                    $commandOptions .= ' -v ';
                                }
                                break;
                            case 'SCHEMA_VALIDATION':
                                $commandOptions .= ($value === true ? ' -val ' : ($value === 'LAX' ? ' -vlax ' : ''));
                                break;
                            case 'OUTPUT_VALIDATION':
                                if ($value === false) {
                                    $commandOptions .= ' -vw ';
                                }
                                break;
                            case 'ERROR_LEVEL':
                                switch ($value) {
                                case 'SILENT':
                                    $commandOptions .= ' -w0 ';
                                    break 2;
                                case 'WARN':
                                    $commandOptions .= ' -w1 ';
                                    break 2;
                                case 'ERROR':
                                    $commandOptions .= ' -w2 ';
                                    break 2;
                                default:
                                    continue 2;
                                }
                            case 'XML_VERSION':
                                if ($value === '1.1') {
                                    $commandOptions .= ' -1.1 ';
                                }
                                break;
                            case 'DISABLE_EXTENSION_FUNCTIONS':
                                if ($value === true) {
                                    $commandOptions .= ' -noext ';
                                }
                                break;
                            case 'VERSION_WARNING':
                                if ($value === false) {
                                    $commandOptions .= ' -novw ';
                                }
                                break;
                            default:
                                continue 2;
                            }
                        }
                        break;
                    case 9:
                    default:
                        foreach ($this->options as $option=>$value) {
                            switch ($option) {
                            case 'TREE_MODEL':
                                switch ($value) {
                                case 'TINY':
                                    $commandOptions .= ' -tree:tiny ';
                                    break 2;
                                case 'LINKED':
                                    $commandOptions .= ' -tree:linked ';
                                    break 2;
                                default:
                                    continue 2;
                                }
                            case 'STRIP_WHITE_SPACE':
                                switch ($value) {
                                case 'NONE':
                                    $commandOptions .= ' -strip:none ';
                                    break 2;
                                case 'ALL':
                                    $commandOptions .= ' -strip:all ';
                                    break 2;
                                case 'IGNORABLE':
                                    $commandOptions .= ' -strip:ignorable ';
                                    break 2;
                                default:
                                    continue 2;
                                }
                            case 'DTD_VALIDATION':
                                $commandOptions .= $value === true ? ' -dtd:on ' : ($value === false ? ' -dtd:off ' : '');
                                break;
                            case 'SCHEMA_VALIDATION':
                                $commandOptions .= $value === true ? ' -val:strict ' : ($value === 'LAX' ? ' -val:lax ' : '');
                                break;
                            case 'OUTPUT_VALIDATION':
                                $commandOptions .= $value === true ? ' -outval:fatal ' : ($value === false ? ' -outval:recover ' : '');
                                break;
                            case 'ERROR_LEVEL':
                                switch ($value) {
                                case 'SILENT':
                                    $commandOptions .= ' -warnings:silent ';
                                    break 2;
                                case 'WARN':
                                    $commandOptions .= ' -warnings:recover ';
                                    break 2;
                                case 'ERROR':
                                    $commandOptions .= ' -warnings:fatal ';
                                    break 2;
                                default:
                                    continue 2;
                                }
                            case 'XML_VERSION':
                                switch($value) {
                                case '1.0':
                                    $commandOptions .= ' -xmlversion:1.0 ';
                                    break 2;
                                case '1.1':
                                    $commandOptions .= ' -xmlversion:1.1 ';
                                    break 2;
                                default:
                                    continue 2;
                                }
                            case 'DISABLE_EXTENSION_FUNCTIONS':
                                $commandOptions .= $value === true ? ' -ext:off ' : ($value === false ? ' -ext:on ' : '');
                                break;
                            case 'VERSION_WARNING':
                                $commandOptions .= $value === true ? ' -versionmsg:on ' : ($value === false ? ' -versionmsg:off ' : '');
                                break;
                            default:
                                continue 2;
                            }
                        }
                        break;
                    }
                }
                //Assamble the SAXON command.
                $isJAVACLI = $this->interface == 'JAVA-CLI';
                $this->command = ($isJAVACLI ? escapeshellarg($this->runtime) . ' -cp ' : null) . escapeshellarg(($isJAVACLI ? dirname(__FILE__) . DIRECTORY_SEPARATOR . 'XSLT2Processor.jar' . PATH_SEPARATOR : null) . $this->processorPath) . ($isJAVACLI ? ' XSLT2Processor.saxon' : null) . $commandOptions . ' -o' . ($this->processorVersion != 8 ? ':' : ' ') . $inputs['output'] . ($this->processorVersion != 8 ? ' -s:' : ' ') . $inputs['source'] . ($this->stylesheet !== XML_XSLT2PROCESSOR_PI ? ($this->processorVersion != 8 ? ' -xsl:' : ' ') . $inputs['stylesheet'] : null) . ' ' . $params;
            }elseif ($this->processor === 'AltovaXML') {
                //Prepare the AltovaXML parameters.
                foreach ($this->params as $param) {
                    //Ensure the parameter is set in one of the supported modes.
                    if (preg_match('/^(EXPRESSION|FILE|(SAFE\-)?STRING)$/', $param[2])) {
                        $value = current($param[1]);
                        $params .= ' -param ' . key($param[1]) . '="';
                        switch ($param[2]) {
                        case 'EXPRESSION':
                            $params .= $value;
                            break;
                        case 'STRING':
                            $params .= '\'' . str_replace(array('"', '&', '<', '>', '\''), array('\"', '"&"', '"<"', '">"', '"\'"\''), $value) . '\'';
                            break;
                        case 'SAFE-STRING':
                            $valueFile = tempnam(getcwd(), 'PARAM_TEMP');
                            $this->tmpFiles[] = $valueFile;
                            file_put_contents($valueFile, "<a>$value</a>");
                            $params .= "string(document('$valueFile'))";
                            break;
                        case 'FILE':
                            $params .= "document('{$this->_url2filepath($value)}')";
                        }
                        $params .= '" ';
                    }
                }
                //Set the AltovaXML options.
                if (!empty($this->options) && is_array($this->options)) {
                    foreach ($this->options as $option=>$value) {
                        switch ($option) {
                        case 'XSLT_STACK_SIZE':
                            if (is_int($value) && $value >= 100) {
                                $commandOptions .= ' -xslstack ' . $value;
                            }
                            break 2;
                        default:
                            continue 2;
                        }
                    }
                }
                //Assamble the AltovaXML command.
                $this->command = escapeshellarg($this->processorPath) . ' -xslt2 ' . $inputs['stylesheet'] . ' -in ' . $inputs['source'] . ' -out ' . $inputs['output'] . $commandOptions . ' ' . $params;
            }
            //Execute the assabled command and get it's status.
            $processorInstance = proc_open((DIRECTORY_SEPARATOR === '\\' ? '"' . $this->command . '"' : $this->command), array(1 => array('pipe', 'w'), 2 => array('pipe', 'w')), $pipes);
            $processorResult = stream_get_contents($pipes[1]);
            $processorErrors = stream_get_contents($pipes[2]);
            $this->status = proc_close($processorInstance);
            if (!empty($processorErrors)) {
                $this->_createErrorLogEntry($processorErrors);
            }
            return $this->status === 0 ? (file_exists($output) ? (!is_dir($output) ? filesize($output) : true) : false) : false;
        }elseif (($this->interface === 'COM' || $this->interface === '.NET') && $this->processor === 'AltovaXML') {
            try {
                $proc = $this->instance->XSLT2;
                //Prepare the AltovaXML parameters.
                foreach ($this->params as $param) {
                    $name = key($param[1]);
                    $value = current($param[1]);
                    switch ($param[2]) {
                    case 'EXPRESSION':
                        $proc->AddExternalParameter($name, $value);
                        break;
                    case 'STRING':
                        $proc->AddExternalParameter($name, "'$value'");
                        break;
                    case 'SAFE-STRING':
                        $valueFile = tempnam(getcwd(), 'PARAM_TEMP');
                        $this->tmpFiles[] = $valueFile;
                        file_put_contents($valueFile, "<a>$value</a>");
                        $proc->AddExternalParameter($name, "string(document('$valueFile'))");
                        break;
                    case 'FILE':
                        $proc->AddExternalParameter($name, "document('{$this->_url2filepath($value)}')");
                        break;
                    }
                }
                //Specify the XML and XSLT files.
                $proc->InputXMLFileName = realpath($source);
                $proc->XSLFileName = realpath($this->stylesheet);
                //Set the AltovaXML Options.
                if (!empty($this->options) && is_array($this->options)) {
                    foreach ($this->options as $option=>$value) {
                        switch ($option) {
                        case 'XSLT_STACK_SIZE':
                            if (is_int($value) && $value >= 100) {
                                $proc->XSLStackSize = $value;
                            }
                            break;
                        default:
                            continue 2;
                        }
                    }
                }
                $proc->Execute($output);
                $proc->ClearExternalParameterList();
                $proc->XSLStackSize = 1000;
                return filesize($output);
            }
            catch (Exception $e) {
                $this->_createErrorLogEntry($proc->LastErrorMessage);
                return false;
            }
        }
    }

    /**
     * Transform to XML
     *
     * Transforms the source node to a string applying the stylesheet given by
     * the {@link XML_XSLT2Processor::importStylesheet()} method.
     * @param mixed $xml The document to be transformed as a DOMDocument object
     * or a string, representing the location of the file.
     * @return string The result of the transformation as a string or FALSE on
     * error.
     * @see XML_XSLT2Processor::transformToDoc()
     * @see XML_XSLT2Processor::transformToURI()
     */
    public function transformToXML($xml)
    {
        $tmpResult = tempnam(getcwd(), 'RESULT_TEMP');
        $this->tmpFiles[] = $tmpResult;
        $return = $this->transformToURI($xml, $tmpResult);
        return $return !== false ? file_get_contents($tmpResult) : false;
    }

    /**
     * Transform to DOMDocument
     *
     * Transforms the input source document specified by the argument to this
     * function to a DOMDocument by using the stylesheet specified by
     * {@link XML_XSLT2Processor::importStylesheet()}.
     * @param mixed $xml The document to be transformed as a DOMDocument object
     * or a string, representing the location of the file.
     * @return DOMDocument The result of the transformation as a DOMDocument or
     * FALSE on error.
     * @see XML_XSLT2Processor::transformToURI()
     * @see XML_XSLT2Processor::transformToXML()
     */
    public function transformToDoc($xml)
    {
        return ($doc = @DOMDocument::loadXML($result = $this->transformToXML($xml))) === false ? @DOMDocument::loadHTML($result) : $doc;
    }
    
    /**
     * Retrieve an array of errors or a chosen error.
     *
     * Get all errors that occurred during the script's execution. Optionally
     * get a single error, specified by an index. This function may be called
     * statically.
     * @param int $index The error to fetch. If omitted or set to a non-integer
     * value, all errors will be returned in an array. If is set and is not
     * negative, only the error at that index will be returned. If set and is
     * negative, that error from the end will be returned.
     * @return mixed An array with {@link XML_XSLT2Processor_Error} objects as
     * each member's value, a single XML_XSLT2Processor_Error object if an index
     * is specified, or FALSE if there are no errors.
     * @see XML_XSLT2Processor::clearErrors()
     * @see XML_XSLT2Processor_Error
     */
    public static function getErrors($index = null)
    {
        if (!defined('XML_XSLT2PROCESSOR_ERROR_LOG') || (defined('XML_XSLT2PROCESSOR_ERROR_LOG') && !is_file(constant('XML_XSLT2PROCESSOR_ERROR_LOG')))) {
            return false;
        }else {
            $errors = $tmpFiles = array();
            $errorLog = new DOMDocument;
            $errorLog->load(XML_XSLT2PROCESSOR_ERROR_LOG);
            //Parse the errors
            $rawErrors = $errorLog->getElementsByTagName('instance');
            for ($e=0, $el = $rawErrors->length; $e < $el; $e++) {
                $error = $rawErrors->item($e);
                //Regenerate the tmpFiles array
                $rawTmpFiles = $error->getElementsByTagName('tmpFile');
                for ($i=0, $il=$rawTmpFiles->length; $i < $il; $i++) {
                    $tmpFiles[] = $rawTmpFiles->item($i)->nodeValue;
                }
                switch ($error->getAttribute('processor')) {
                    case 'SAXON':
                        if ($error->getAttribute('interface') === 'CLI') {
                          $errorText = preg_split('/(Error|Warning)\:?/', $error->firstChild->nodeValue, -1, PREG_SPLIT_NO_EMPTY | PREG_SPLIT_DELIM_CAPTURE);
                          for ($i=1; $i < count($errorText); $i = $i + 2) {
                              $errorObject = new XML_XSLT2Processor_Error;
                              $errorLine = explode("\n", $errorText[$i]);
                              $errorObject->level = ($errorText[$i - 1] == 'Error' ? LIBXML_ERR_FATAL : LIBXML_ERR_WARNING);
                              $errorObject->line = (int) self::_substring_between($errorLine[0], ' on line ', ' of');
                              $errorObject->code = ($errorObject->level === LIBXML_ERR_FATAL ? trim(self::_substring_between($errorLine[1], '  ', ': ')) : null);
                              if (preg_match('/^SXXP[0-9]{4}/', $errorObject->code)) {
                                  $file = self::_url2filepath(self::_substring_between($errorLine[0], ' of ', ":"));
                                  $errorObject->file = (!in_array($file, $tmpFiles) ? $file : null);
                                  $errorObject->column = (int) self::_substring_between($errorLine[0], ' column ', ' of');
                              }else {
                                  $file = self::_url2filepath(self::_substring_between($errorText[$i], ' of ', ":\n"));
                                  $errorObject->file = (!in_array($file, $tmpFiles) ? $file : null);
                              }
                              array_shift($errorLine);
                              if (($i == count($errorText) - 1) && (is_int(strpos($errorLine[count($errorLine) - 2], 'Failed to compile stylesheet.')) || is_int(strpos($errorLine[count($errorLine) - 2], "Transformation failed: Run-time errors were reported\r")))) {
                                  unset($errorLine[count($errorLine) - 2]);
                              }
                              $errorObject->message = trim(substr(implode("\n", $errorLine), strlen('  ' . ($errorObject->level === LIBXML_ERR_FATAL ? $errorObject->code . ': ' : null))));
                              $errors[] = $errorObject;
                          }
                          continue 2;
                        }
                    case '__INTERNAL__':
                        $errorDoc = new DOMDocument;
                        if (!@$errorDoc->loadXML('<l>' . html_entity_decode($error->firstChild->nodeValue, ENT_NOQUOTES, 'UTF-8') . '</l>')) {
                            echo file_get_contents(XML_XSLT2PROCESSOR_ERROR_LOG);
                        }
                        $errorDocRootChilds = $errorDoc->documentElement->childNodes;
                        for ($c = 0, $cl = $errorDocRootChilds->length; $c<$cl; $c++) {
                            $errorObject = new XML_XSLT2Processor_Error;
                            $currError = $errorDocRootChilds->item($c);
                            if ($currError->nodeType !== XML_ELEMENT_NODE) {
                                continue;
                            }
                            $errorObject->message = $currError->textContent;
                            $column = $currError->getAttribute('p');
                            $errorObject->column = empty($column) ? null : (int) $column;
                            $code = $currError->getAttribute('c');
                            $errorObject->code = empty($code) ? null : (is_int($code) ? (int) $code : $code);
                            $file = $currError->getAttribute('f');
                            $errorObject->file = (!in_array($file, $tmpFiles) ? $file : null);
                            $level = $currError->getAttribute('s');
                            $errorObject->level = (int) empty($level) ? LIBXML_ERR_FATAL : $level;
                            $errorObject->line = (int) $currError->getAttribute('l');
                            $errors[] = $errorObject;
                        }
                        continue 2;
                    case 'AltovaXML':
                        $errorObject = new XML_XSLT2Processor_Error;
                        $errorText = trim($error->firstChild->nodeValue);
                        $errorLine = explode("\n", $errorText);
                        $errorObject->level = LIBXML_ERR_FATAL;
                        $file = @trim($errorLine[count($errorLine) - 2]);
                        $errorObject->file = (!in_array($file, $tmpFiles) ? $file : null);
                        $errorObject->line = (int) self::_substring_between($errorLine[count($errorLine) - 1], 'Line ', ',');
                        $errorObject->column = (int) self::_substring_between($errorLine[count($errorLine) - 1], 'Character ');
                        $errorObject->message = trim(implode("\n", array_splice($errorLine, 0, -2)));
                        if (preg_match('/^([A-Z]{4}[0-9]{4})\: (.*)/m', $errorObject->message, $messageParts)) {
                            $errorObject->code = $messageParts[1];
                            $errorObject->message = $messageParts[2];
                        }
                        $errors[] = $errorObject;
                        continue 2;
                    default:
                        continue 2;
                }
            }
            return empty($errors) ? false : (is_int($index) ? ($index >= 0 ? $errors[$index] : $errors[count($errors) + $index]) : $errors);
        }
    }
    
    /**
     * Clear the error buffer.
     *
     * Clear the error log of all errors that occurred during the script's
     * execution until that moment.
     * @return void
     * @see XML_XSLT2Processor::getErrors()
     */
    public static function clearErrors() {
        if (defined('XML_XSLT2PROCESSOR_ERROR_LOG') && is_file(constant('XML_XSLT2PROCESSOR_ERROR_LOG'))) {
            unlink(XML_XSLT2PROCESSOR_ERROR_LOG);
        }
    }

    /**
     * Destroyes the temporary files used by this class, if any.
     */
    public function __destruct()
    {
        foreach ($this->tmpFiles as $file) {
            if (is_file($file)) {
                unlink($file);
            }
        }
    }
}
?>
