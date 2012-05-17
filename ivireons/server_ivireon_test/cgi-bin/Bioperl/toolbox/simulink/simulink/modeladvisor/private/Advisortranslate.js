<script>
<!--

function expandGroup(caller) {
var targetId, targetElement ;
targetId = caller.id + "d" ;
targetElement = document.getElementById(targetId) ;
if (targetElement.style.display == "none") {
   targetElement.style.display = "" ;
   caller.src = "minus.png" ;
 } else {
   targetElement.style.display = "none" ;
   caller.src = "plus.png" ;
 }
}

function updateVisibleChecks()
{

var showFailed = document.getElementById("Failed Checkbox").checked;
var showPassed = document.getElementById("Passed Checkbox").checked;
var showWarning = document.getElementById("Warning Checkbox").checked;
var showNotRun = document.getElementById("Not Run Checkbox").checked;
var allshowFlag = showFailed && showPassed && showWarning && showNotRun;
var passedChecks = document.getElementsByName("Passed Check");
var failedChecks = document.getElementsByName("Failed Check");
var warningChecks = document.getElementsByName("Warning Check");
var notRunChecks = document.getElementsByName("Not Run Check");
var i;

if(failedChecks==null){failedChecks = 0;}
if(passedChecks==null){passedChecks = 0;}
if(warningChecks==null){warningChecks = 0;}
if(notRunChecks==null){notRunChecks = 0;}

for(i = 0; i < passedChecks.length; i++)
{
    passedChecks[i].style.display = "none";
}     
for(i = 0; i < failedChecks.length; i++)
{
    failedChecks[i].style.display = "none";
}     
for(i = 0; i < warningChecks.length; i++)
{
    warningChecks[i].style.display = "none";
}     
for(i = 0; i < notRunChecks.length; i++)
{
    notRunChecks[i].style.display = "none";
}     

if(showFailed || allshowFlag)
{
     for(i = 0; i < failedChecks.length; i++)
    {
		failedChecks[i].style.display = "";
    }     
}

if(showPassed || allshowFlag)
{
     for(i = 0; i < passedChecks.length; i++)
    {
		passedChecks[i].style.display = "";
    }     
}

if(showWarning || allshowFlag)
{
     for(i = 0; i < warningChecks.length; i++)
    {
		warningChecks[i].style.display = "";
    }     
}

if(showNotRun || allshowFlag)
{
     for(i = 0; i < notRunChecks.length; i++)
    {
		notRunChecks[i].style.display = "";
    }     
}
}

function MATableShrink(o,tagNameStr,tagNameStr1)
{

var temp = document.getElementsByName(tagNameStr);
if (temp[0].style.display == "") 
{
    temp[0].style.display = "none";
    o.innerHTML = '<img src="plus.png"/>';
    temp = document.getElementsByName(tagNameStr1);
    if(temp[0] != undefined)
    {
        temp[0].style.display = "";
    }
} 
else 
{
    temp[0].style.display = "";
    o.innerHTML = '<img src="minus.png"/>';
    temp = document.getElementsByName(tagNameStr1);
    if(temp[0] != undefined)
    {
        temp[0].style.display = "none";
    }
}
}

function selectGroup(group) {
var i; 
// when groupid is o_1ck, find every thing start with o_1.
var targetId = new RegExp(group.id.substr(0,group.id.length-2) + "\\w+");
//var targetId = /out_2\w+/;
var matchResult;
var elementsArray = document.forms[0].elements;
for (i=0; i< elementsArray.length; i++) {
  if (elementsArray[i].type == "checkbox")  {
   if (elementsArray[i].disabled == false) {     
     //if ((elementsArray[i].id == targetId) ) {
     matchResult = elementsArray[i].id.match(targetId);
     if (matchResult != null) {
       elementsArray[i].checked=group.checked;
     }
    }
   }
}  
}

// set focus to first text element of first form in the page
function sf(){
var i; //must declare local loop counter to avoid default global declaration
var elementsArray = document.forms[0].elements;
for(i=0; i < elementsArray.length; i++) {
  if ((elementsArray[i].type == "text") && ((elementsArray[i].name != "Model"))) {
    elementsArray[i].focus();
    break;    
  }
 }
}

//set initial state for each selection element in the page
function initiateState() {
var i;
var elementsArray = document.forms[0].elements;
for (i=0; i< elementsArray.length; i++) {
  if ((elementsArray[i].type == "select-one") ) {
    elementsArray[i].click();
  }
}  
}

//translate special characters into escape sequence
function subEncode(srcString) {
  var srcList = new Array('z', '(', ')', '?', '&', '$', '|', '^', '{' , '}','\'','\"','\\', '[', ']', '/', '#', '<', '>', '.', '+', '=', '~', '@', '%', '`', ',', ' ', '*', ':', '!', ':');
  var dstList = new Array('z0','z1','z2','z3','z4','z5','z6','z7','z8','z9','za','zb','zc','zd','ze','zf','zg','zh','zi','zj','zk','zl','zm','zn','zo','zp','zq','zs','zt','zu','zv','zw');
  var dstString;
  var i; //must declare local loop counter to avoid default global declaration
  dstString = '';
  for (i=0; i < srcString.length; i++) {
   c = srcString.charAt(i);
   newc = c;
   for (j=0; j < srcList.length; j++) {
     if (c==srcList[j]) {
       newc = dstList[j];
       }
     }
   dstString+= newc;
   }
  return dstString;
}
  
// encode each "text" field of the form
function htmlEncode(form) {
var elementsArray = form.elements;
var i; //must declare loop counter to avoid default global declaration
for(i=0; i < elementsArray.length; i++) {
  if ((elementsArray[i].type == "text") || (elementsArray[i].type == "select") || (elementsArray[i].type == "submit")) {
    elementsArray[i].value=subEncode(elementsArray[i].value);
  }
}
//  form.MatchCase.click();
}

// make sure only one parameter is checked on update parameter page
function uncheckOthers(form, thischeckbox) {
var elementsArray = form.elements;
var i; //must declare loop counter to avoid default global declaration
if (thischeckbox.checked) {
  for(i=0; i < elementsArray.length; i++) {
    if (elementsArray[i].type == "checkbox") 
      if ((elementsArray[i].checked) && (elementsArray[i].name.substring(0,12)=="paramChecked") && (elementsArray[i].name != thischeckbox.name)) {
        elementsArray[i].checked=false;
      }
    }
  }
}

// select/unselect all found objects in the table
function selectAll(form, select) {
var elementsArray = form.elements;
var i; //must declare loop counter to avoid default global declaration
for(i=0; i < elementsArray.length; i++) {
  if (elementsArray[i].type == "checkbox")  {
   if (elementsArray[i].disabled == false) {
    if (select) 
      elementsArray[i].checked=true
    else
      elementsArray[i].checked=false
   }
  }
}
}

// -->
</script>