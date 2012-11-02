// HiddenLinks //
//
// Published by O3noBLOG
//               http://blog.othree.net
//


addEvent(this, "load", hlInitial);

var hllinks = new Array(
Array("Google", "http://www.google.com/"),
Array("TOP", "/"),
Array("other", "URI here")
);

    if(!document.createElementNS)
    {
        document.createElementNS = function(ns,elt) {
            return document.createElement(elt);
        }
    }


var body;
var hlDiv;
var hlShadow;

var hlWidth;
var hlHeight;

var hlFlag = false;
var hlZoomFlag = false;
var hlZoomingFlag = false;

var XHTMLNS = "http://www.w3.org/1999/xhtml";
var browser = new Browser();

function hlInitial()
{
    if (!document.createElementNS || !document.getElementsByTagName) return;
	body = document.getElementsByTagName("body")[0];
	theArea = document.createElementNS(XHTMLNS, 'div');

	theArea.setAttribute("id", "hlArea");
	addEvent(theArea, "mouseover", hlMouseIn);
	addEvent(theArea, "mouseout", hlMouseOut);
	body.appendChild(theArea);

	var theList = document.createElementNS(XHTMLNS, 'ul');
	theList.setAttribute("id", "hlList");

	for (i=0;i<hllinks.length;i++)
	{
		var theLink = document.createElementNS(XHTMLNS, 'a');
		theLink.setAttribute("href", hllinks[i][1]);
		var theLinkText = document.createTextNode(hllinks[i][0]);
		theLink.appendChild(theLinkText);
		var theListItem = document.createElementNS(XHTMLNS, 'li');
		theListItem.appendChild(theLink);
		theList.appendChild(theListItem);
	}

	var theDiv = document.createElementNS(XHTMLNS, 'div');
	theDiv.setAttribute("id", "hlDiv");
	theDiv.className = "inner";
	theDiv.appendChild(theList);

	var theShadow = document.createElementNS(XHTMLNS, 'div');
	theShadow.setAttribute("id", "hlShadow");
	theShadow.className = "ydsf";
	theShadow.appendChild(theDiv);
	body.appendChild(theShadow);

	hlDiv = document.getElementById('hlDiv');
	hlShadow = document.getElementById('hlShadow');
	hlWidth = parseInt(hlShadow.offsetWidth);
	hlHeight = parseInt(hlShadow.offsetHeight);
	hlShadow.style.display = "none";
	hlShadow.style.opacity = "0";
	hlShadow.style.top = (-hlHeight)+"px";
}

function hlMouseMove (evt)
{
	pos = getMousePosition(evt);
	if (pos[0] < body.clientWidth - hlWidth - 10 || pos[1] > hlHeight + 25)
	{
		setTimeout("hlMenuHide();", 800);
		hlFlag = false;
	}
	else
	{
		hlFlag = true;
	}
}

function hlMouseIn ()
{
	if (hlZoomingFlag == false)
	{
		hlFlag = true;
		setTimeout("hlShow();", 1000);
	}
}
function hlMouseOut ()
{
	if (hlZoomingFlag == false)
	{
		hlFlag = false;
	}
}
function hlMenuHide ()
{
	if (hlZoomingFlag == false && hlFlag == false)
	{
		hlHide();
	}
}
function hlShow ()
{
	if (hlFlag == true)
	{
		hlMovingFlag = true;
		hlShadow.style.display = "block";
		hlMoveIn();
		hlFadeIn();
	}
}
function hlHide ()
{
	if (hlZoomingFlag == false && hlMovingFlag == false)
	{
		delEvent(body, "mousemove", hlMouseMove);
		hlMovingFlag = true;
		hlMoveOut();
		hlFadeOut();
	}
}

function hlMoveIn ()
{
		Y = parseInt(hlShadow.style.top) + 5;
		hlShadow.style.top = ((Y > 10)?10:Y) + "px";
		if (Y < 10)
		{
			setTimeout("hlMoveIn();", 25);
		}
		else
		{
			hlMovingFlag = false;
			addEvent(body, "mousemove", hlMouseMove);
		}
}

function hlMoveOut ()
{
		Y = parseInt(hlShadow.style.top) - 5;
		hlShadow.style.top = ((Y < (-hlHeight-10))?(-hlHeight-10):Y) + "px";
		if (Y > (-hlHeight-10))
		{
			setTimeout("hlMoveOut();", 25);
		}
		else
		{
			hlMovingFlag = false;
			hlShadow.style.display = "none";
		}
}

function hlFadeIn ()
{
		O = parseFloat(hlShadow.style.opacity)+0.04;
		hlShadow.style.opacity = (O < 0.95)?O:0.95;
		if ( O < 0.95 )
		{
			setTimeout("hlFadeIn();", 25);
		}
}

function hlFadeOut ()
{
		O = parseFloat(hlShadow.style.opacity)-0.04;
		hlShadow.style.opacity = (O > 0)?O:0;
		if ( O > 0 )
		{
			setTimeout("hlFadeOut();", 25);
		}
}

function getMousePosition(event) {
  if (browser.isIE) {
    x = window.event.clientX + document.documentElement.scrollLeft
      + document.body.scrollLeft;
    y = window.event.clientY + document.documentElement.scrollTop
      + document.body.scrollTop;
  }
  if (browser.isNS) {
    x = event.clientX + window.scrollX;
    y = event.clientY + window.scrollY;
  }
  return [x,y];
}

// Determine browser and version.

function Browser() {
// blah, browser detect, but mouse-position stuff doesn't work any other way
  var ua, s, i;

  this.isIE    = false;
  this.isNS    = false;
  this.version = null;

  ua = navigator.userAgent;

  s = "MSIE";
  if ((i = ua.indexOf(s)) >= 0) {
    this.isIE = true;
    this.version = parseFloat(ua.substr(i + s.length));
    return;
  }

  s = "Netscape6/";
  if ((i = ua.indexOf(s)) >= 0) {
    this.isNS = true;
    this.version = parseFloat(ua.substr(i + s.length));
    return;
  }

  // Treat any other "Gecko" browser as NS 6.1.

  s = "Gecko";
  if ((i = ua.indexOf(s)) >= 0) {
    this.isNS = true;
    this.version = 6.1;
    return;
  }
}

// Add an eventListener to browsers that can do it somehow.
// Originally by the amazing Scott Andrew.
function addEvent(obj, evType, fn){
  if (obj.addEventListener){
    obj.addEventListener(evType, fn, false);
    return true;
  } else if (obj.attachEvent){
	var r = obj.attachEvent("on"+evType, fn);
    return r;
  } else {
	return false;
  }
}

function delEvent(obj, evType, fn){
  if (obj.removeEventListener){
    obj.removeEventListener(evType, fn, false);
    return true;
  } else if (obj.detachEvent){
	var r = obj.detachEvent("on"+evType, fn);
    return r;
  } else {
	return false;
  }
}