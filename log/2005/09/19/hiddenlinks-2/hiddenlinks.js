// HiddenLinks //
// http://blog.othree.net
// code is based on some function in "Nice titles" (http://www.kryogenix.org/code/browser/nicetitle/)

// settings

var hllinks = new Array(
Array("主控台", "http://othree.net/mt/mt.cgi", ""),
Array("反向連結", "/refer/", ""),
Array("WIKI", "http://othree.net/wiki/", "")
);

var	disableO = false; //disable fade in fade out ?
var	autofocus = false; //auto focus on


// codes

if(!document.createElementNS)
{
	document.createElementNS = function(ns,elt)
	{
		return document.createElement(elt);
	}
}

var body, hlW, hlH, iP, tH;
var hlFlag = isO = ts = ss = 0, period = 600; //micro second

var XHTMLNS = "http://www.w3.org/1999/xhtml";
var browser = new Browser();

addEvent(this, "load", hlInitial);

function hlInitial ()
{
	if (!document.createElementNS || !document.getElementsByTagName) return;
	body = document.getElementsByTagName("body")[0];
	isO = (body.style.opacity == '' && !disableO);

	tA = document.createElementNS(XHTMLNS, 'div');
	tA.id = "hlArea";
	addEvent(tA, "mouseover", hlMouseIn);
	addEvent(tA, "mouseout", hlMouseOut);
	body.appendChild(tA);

	tList = document.createElementNS(XHTMLNS, 'ul');
	tList.id = "hlList";

	for (i=0;i<hllinks.length;i++)
	{
		tL = document.createElementNS(XHTMLNS, 'a');
		tL.href = hllinks[i][1];
		tL.title = hllinks[i][2];
		tL.tabIndex = 3000+i;
		tL.appendChild(document.createTextNode(hllinks[i][0]));
		tLI = document.createElementNS(XHTMLNS, 'li');
		tLI.appendChild(tL);
		tList.appendChild(tLI);
	}

	tD = document.createElementNS(XHTMLNS, 'div');
	tD.id = "hlDiv";
	tD.className = "inner";
	tD.appendChild(tList);

	tS = document.createElementNS(XHTMLNS, 'div');
	tS.id = "hlShadow";
	tS.className = "ydsf";
	tS.appendChild(tD);
	body.appendChild(tS);

	hlW = parseInt(tS.offsetWidth);
	hlH = parseInt(tS.offsetHeight);
	tS = tS.style;

	tS.display = "none";
	tS.opacity = !isO;
	iP = (isO)?-50:-hlH-10;
	tH = 10-iP;
	tS.top = iP+"px"
}

function hlMouseMove (evt)
{
	pos = getMousePosition(evt);
	hlFlag = (pos[0] > body.clientWidth - hlW - 25 && pos[1] < hlH + 25);
	if (!hlFlag) setTimeout("hlGo(0);", 600);
}

function hlMouseIn ()
{
	if (!ts) hlFlag = 1,setTimeout("hlGo(1);", 600);
}
function hlMouseOut ()
{
	hlFlag = (ts);
}

function hlGo (type)
{
	if (!ts && !(type ^ hlFlag))
	{
		(type)?(tS.display = "block",delEvent(tA, "mouseover", hlMouseIn)):delEvent(body, "mousemove", hlMouseMove);
		ss = ts = new Date().getTime();
		this.Interval = setInterval("hlMove("+type+");", 20);
	}
}

function hlMove (type)
{
	ts = new Date().getTime();
	p = (ts-ss)/period;
	p = (p>1)?1:p;
	p = (type)?p:1-p;
	tS.top = iP+Math.sin(p*Math.PI/2)*tH+"px";
	if (isO) tS.opacity = p*0.96;
	if (!(p - type))
	{
		if (type && autofocus) tList.firstChild.firstChild.focus();
		ts = 0;
		clearInterval(this.Interval);
		(type)?addEvent(body, "mousemove", hlMouseMove):(tS.display = "none",addEvent(tA, "mouseover", hlMouseIn));
	}
}

// functions from "Nice titles"

function getMousePosition (event)
{
	if (browser.isIE)
	{
		x = window.event.clientX + document.documentElement.scrollLeft + document.body.scrollLeft;
		y = window.event.clientY + document.documentElement.scrollTop + document.body.scrollTop;
	}
	if (browser.isNS)
	{
		x = event.clientX + window.scrollX;
		y = event.clientY + window.scrollY;
	}
	return [x,y];
}

// Determine browser and version.

function Browser ()
{
// blah, browser detect, but mouse-position stuff doesn't work any other way
	var ua, s, i;

	this.isIE = false;
	this.isNS = false;
	this.version = null;

	ua = navigator.userAgent;

	s = "MSIE";
	if ((i = ua.indexOf(s)) >= 0)
	{
		this.isIE = true;
		this.version = parseFloat(ua.substr(i + s.length));
		return;
	}
	s = "Netscape6/";
	if ((i = ua.indexOf(s)) >= 0)
	{
		this.isNS = true;
		this.version = parseFloat(ua.substr(i + s.length));
		return;
	}
	// Treat any other "Gecko" browser as NS 6.1.
	s = "Gecko";
	if ((i = ua.indexOf(s)) >= 0)
	{
		this.isNS = true;
		this.version = 6.1;
		return;
	}
}

// Add an eventListener to browsers that can do it somehow.
// Originally by the amazing Scott Andrew.
function addEvent (obj, evType, fn)
{
	if (obj.addEventListener)
	{
		obj.addEventListener(evType, fn, false);
		return true;
	}
	else if (obj.attachEvent)
	{
		var r = obj.attachEvent("on"+evType, fn);
		return r;
	}
	else return false;
}

function delEvent (obj, evType, fn)
{
	if (obj.removeEventListener)
	{
		obj.removeEventListener(evType, fn, false);
		return true;
	}
	else if (obj.detachEvent)
	{
		var r = obj.detachEvent("on"+evType, fn);
		return r;
	}
	else return false;
}