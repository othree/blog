// HideLinks 
//
// Published at http://blog.othree.net/
//

var hllinks = new Array(
Array("主控台", "http://othree.net/mt/mt.cgi"),
Array("反向連結", "/refer/"),
Array("WIKI", "http://othree.net/wiki/")
);

var body;
var hlDiv;
var hlShadow;

var hlWidth = 100;
var hlRowHeight = 25;
var hlHeight = hllinks.length * hlRowHeight;
var hlSize = 20;

var hlvx = 4;
var hlvy = 2;

var hlFlag = false;
var hlZoomFlag = false;
var hlZoomingFlag = false;


this.addEventListener("load", hlInitial, false);


function hlInitial()
{

	body = document.getElementsByTagName("body")[0];

	var theArea = document.createElement('div');
	theArea.setAttribute("id", "hlArea");
	theArea.setAttribute("style", "position: fixed; top: 0; right: 0; width: "+ hlSize + "px; height: "+ hlSize + "px; background-color: transparent;");
	theArea.addEventListener("mouseover", hlMouseIn, false);
	theArea.addEventListener("mouseout", hlMouseOut, false);
	body.appendChild(theArea);

	var theList = document.createElement('ul');
	theList.setAttribute("id", "hlList");
	theList.setAttribute("style", "list-style: none; padding: 0; margin: 0;");

	for (i=0;i<hllinks.length;i++)
	{
		var theLink = document.createElement('a');
		theLink.setAttribute("href", hllinks[i][1]);
		theLink.setAttribute("style", "text-align: center; line-height: "+hlRowHeight+"px; height: "+hlRowHeight+"px;");
		var theLinkText = document.createTextNode(hllinks[i][0]);
		theLink.appendChild(theLinkText);
		var theListItem = document.createElement('li');
		theListItem.setAttribute("style", "list-style: none; padding: 0; margin: 0;;");
		theListItem.appendChild(theLink);
		theList.appendChild(theListItem);
	}

	var theDiv = document.createElement('div');
	theDiv.setAttribute("id", "hlDiv");
	theDiv.setAttribute("style", "position: fixed; top: 5px; right: 9px; width: 0px; height: 0px; background-color: #fff; border: 1px solid black; overflow: hidden; opacity: 1; z-index: 20; display: none;");
	theDiv.appendChild(theList);

	var theShadow = document.createElement('div');
	theShadow.setAttribute("id", "hlShadow");
	theShadow.setAttribute("style", "position: fixed; top: 9px; right: 5px; width: 0px; height: 0px; background-color: #000; border: 1px solid #000; overflow: hidden; opacity: 0.3; z-index: 10; display: none;");
	body.appendChild(theShadow);
	body.appendChild(theDiv);

	hlDiv = document.getElementById('hlDiv');
	hlShadow = document.getElementById('hlShadow');

}

function hlMouseMove (evt)
{
	if (evt.clientX < body.clientWidth - hlWidth - 9 || evt.clientY > hlHeight + 9 + 10)
	{
		setTimeout("hlMenuHide();", 350);
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
		setTimeout("hlHide();", 400);
	}
}
function hlShow ()
{
	if (hlFlag == true)
	{
		hlZoomingFlag = true;
		hlDiv.style.display = "block";
		hlShadow.style.display = "block";
		hlZoomIn();
	}
}
function hlHide ()
{
	if (hlZoomingFlag == false)
	{
		body.removeEventListener("mousemove", hlMouseMove, false);
		hlZoomingFlag = true;
		hlZoomOut();
	}
}

function hlZoomOut()
{
	hlPixelWidth = parseInt(hlDiv.style.width.replace('px', ''));
	hlPixelHeight = parseInt(hlDiv.style.height.replace('px', ''));
	widthFlag = hlPixelWidth/hlPixelHeight >= hlvx/hlvy;
	heightFlag = hlPixelHeight/hlPixelWidth >= hlvx/hlvy;
	hlZoomFlag = false;
	if (hlPixelWidth > 0 && (widthFlag || !widthFlag && !heightFlag))
	{
		hlDiv.style.width = (hlPixelWidth - hlvx < 0)?0 + "px":hlPixelWidth - hlvx + "px";
		hlShadow.style.width = hlDiv.style.width;
	}
	if (hlPixelHeight > 0 && (heightFlag || !heightFlag && !widthFlag))
	{
		hlDiv.style.height = (hlPixelHeight - hlvy < 0)?0 + "px":hlPixelHeight - hlvy + "px";
		hlShadow.style.height = hlDiv.style.height;
	}
	if (hlPixelWidth * hlPixelHeight > 0)
	{
		hlZoomFlag = true;
	}
	if (hlZoomFlag == true)
	{
		setTimeout("hlZoomOut();",10);
	}
	else
	{
		hlDiv.style.display = "none";
		hlShadow.style.display = "none";
		hlZoomingFlag = false;
	}
}

function hlZoomIn()
{
	hlPixelWidth = parseInt(hlDiv.style.width.replace('px', ''));
	hlPixelHeight = parseInt(hlDiv.style.height.replace('px', ''));
	hlZoomFlag = false;
	if (hlPixelWidth < hlWidth)
	{
		hlZoomFlag = true;
		hlDiv.style.width = (hlPixelWidth + hlvx > hlWidth)?hlWidth + "px":hlPixelWidth + hlvx + "px";
		hlShadow.style.width = hlDiv.style.width;
	}
	if (hlPixelHeight < hlHeight)
	{
		hlZoomFlag = true;
		hlDiv.style.height = (hlPixelHeight + hlvy > hlHeight)?hlHeight + "px":hlPixelHeight + hlvy + "px";
		hlShadow.style.height = hlDiv.style.height;
	}
	if (hlZoomFlag == true)
	{
		setTimeout("hlZoomIn();",10);
	}
	else
	{
		hlZoomingFlag = false;
		body.addEventListener("mousemove", hlMouseMove, false);
	}
}
