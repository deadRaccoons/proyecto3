AAcom.modules.utilities=function(AAUI){var genericPopupUtility={popup:function(windowUrl,windowName,windowSize,windowWidth,windowHeight){var windowLeft=0,windowTop=0,windowFeatures="",windowObject=null;windowUrl=windowUrl||"";windowName=windowName||"";windowSize=windowSize||"MEDIUM";windowWidth=windowWidth||this.defaultWidth;windowHeight=windowHeight||this.defaultHeight;windowSize=windowSize.toUpperCase();windowWidth=parseInt(windowWidth);windowHeight=parseInt(windowHeight);switch(windowSize){case"SMALL":windowWidth=300;windowHeight=300;break;case"MEDIUM":windowWidth=this.defaultWidth;windowHeight=this.defaultHeight;break;case"LARGE":windowWidth=850;windowHeight=500;break;case"SCREEN":windowWidth=$j(window).width()-50;windowHeight=$j(window).height()-50;break;}windowLeft=Math.floor(screen.availWidth/2)-Math.floor(windowWidth/2);windowTop=Math.floor(screen.availHeight/2)-Math.floor(windowHeight/2);if(windowSize==="SCREEN"){windowFeatures="location=1, status=1, scrollbars=1, menubar=1, toolbar=1, resizable=1";}else{windowFeatures="location=0, status=0, scrollbars=1, menubar=0, toolbar=0, resizable=1";}windowFeatures=windowFeatures+",width="+windowWidth+",height="+windowHeight+",top="+windowTop+",left="+windowLeft;if($j("html").hasClass("lt-ie10")){windowName="popupWindow";}windowObject=window.open(windowUrl,windowName,windowFeatures);if(windowObject!==null){windowObject.focus();return windowObject;}},defaultWidth:675,defaultHeight:500};AAUI.genericPopup=function(element){element.on("click",function(){var size="";if(!$j(this).attr("data-size")){switch(true){case $j(this).hasClass("aa-pop-win-sm"):size="SMALL";break;case $j(this).hasClass("aa-pop-win-med"):size="MEDIUM";break;case $j(this).hasClass("aa-pop-win-lrg"):size="LARGE";break;case $j(this).hasClass("aa-pop-win-new"):size="SCREEN";break;default:size="MEDIUM";}}else{size=$j(this).attr("data-size");}genericPopupUtility.popup($j(this).attr("href"),$j(this).attr("title"),size,$j(this).attr("data-width"),$j(this).attr("data-height"));return false;});};AAUI.genericManualPopup=function(windowUrl,windowName,windowSize){genericPopupUtitlity.popup(windowURL,windowName,windowSize,0,0);};};