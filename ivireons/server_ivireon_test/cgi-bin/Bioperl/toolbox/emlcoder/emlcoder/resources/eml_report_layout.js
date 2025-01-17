// Copyright 2008-2009 The MathWorks, Inc.

queries = {};

$(document).ready(function () {
    // Pre-execute some basic queries for future use.
    queries.body = $("html > body");
    queries.center = $("> div.center",queries.body);
    queries.west = $("> div.west",queries.body);
    queries.south = $("> div.south",queries.body);
    queries.aux = $("> div.aux", queries.body);

    queries.summary = $("> div#summarybody", queries.south);
    queries.messages = $("> div#messagesbody", queries.south);
    queries.watchlist = $("> div#watchlistbody", queries.south);
    queries.buildlog = $("> div#buildlog1body", queries.south);
    queries.ccode = $("> div#ccodebody", queries.west);
    queries.ccoderows = $("tr.ccode", queries.ccode);
    
    // Make the tab logic.
    tabify($("> ul > li > span", queries.south));
    tabify($("> ul > li > span", queries.west)); 

    // These correspond to the tab links (i.e. the span you click on to activate the tab).
    queries.mcodelink = $('> ul > li > span#MATLABcode', queries.west);
    queries.callstacklink = $('> ul > li > span#callstack', queries.west);
    queries.ccodelink = $('> ul > li > span#ccode', queries.west);
    queries.summarylink = $('> ul > li > span#summary', queries.south);
    queries.messageslink = $('> ul > li > span#messages', queries.south);
    queries.watchlistlink = $('> ul > li > span#watchlist', queries.south);
    queries.watchloadlink = $('> ul > li > span#watchload', queries.south);
    queries.buildloglink = $('> ul > li > span#buildlog1', queries.south);
    queries.watchTable = $(".grid", queries.watchlist);
    
    setupFunctionList();
    setupCallStack();
    setupLayout();

    setupMessages();    
    
    // Sets up all of the tooltips, page loading, etc.
    setupInteractions();
    
    selectMCodeTab();
});

// Add the tablesorter.
function setupMessages() {
    queries.msgTable = $(".grid", queries.messages);
    queries.msgTable.tablesorter({
        widgets: ['zebra'],
        debug: false,
        // define a custom text extraction function
        textExtraction: function(node) {
            // extract data from markup and return it
            var $node = $(node);
            if ($node.hasClass("failed")) {
                return "0";
            } else if ($node.hasClass("warning")) {
                return "1";
            } else if ($node.hasClass("msgorder")) {
                $node = $node.contents();
            }
            return $node.html();
        }
    });
}

// Make the tablesorter object on the watchlist, and make the rows collapsible.
function setupWatchList() {
    queries.watchTable = $(".grid", queries.watchlist);
    $('a.field',queries.watchTable).each(function() {
        var id = this.getAttribute("id");
        if (id != undefined && id != "") {
            $(this).css("margin-left", parseInt(id) * 12 + "px");
        }
    });
    queries.watchTable.tablesorter({
        headers: {0: {sorter: false}},
        widgets: ['zebra'],
        debug: false,
        // define a custom text extraction function
        textExtraction: function(node) {
            // extract data from markup and return it
            var result = node.getAttribute("id");
            if (result != undefined && result != "") {
                return result;
            }
            if (node.childNodes[0] && node.childNodes[0].hasChildNodes()) {
                return node.childNodes[0].innerHTML;
            }
            return node.innerHTML;
        }
    });
}

// Make the tabs; "link" is the set of "li" nodes for the tab pane.
function tabLinkMouseDown($this) {
    $this.parent().addClass("ui-tabs-selected").siblings("li").removeClass("ui-tabs-selected");
    $this.parent().parent().siblings("div.ui-tabs-panel").addClass("hidden").filter("[id^="+$this.attr("id")+"]").removeClass("hidden");
}

function tabify(link) {
    link.mousedown(function() {
        tabLinkMouseDown($(this));
        
        if (watchListTabSelected()) {
            loadWatchData(activeFcn.id);
        }
    });
}

// Some simple helper functions to select a particular tab.
function selectCenterPanel() {
    $('a',queries.center).filter(':first').focus();
}

function selectMCodeTab() {
    queries.mcodelink.mousedown();
    queries.filterenable.focus();
}

function selectCallStackTab() {
    queries.callstacklink.mousedown();
    $('li a',queries.callstackbody).filter(':first').focus();
}

function selectCCodeTab() {
    if (isCCodeTabVisible()) {
        queries.ccodelink.mousedown();
        $('td a',queries.ccoderows).filter(':first').focus();
    }
}

// Use this to unselect the code tab if it is focused
function unselectCCodeTab() {
    if (queries.ccodelink.parent().hasClass("ui-tabs-selected"))
        selectMCodeTab();
}

function selectSummaryTab() {
    queries.summarylink.mousedown();
    $('td a',queries.summary).filter(':first').focus();
}

function selectMessagesTab() {
    queries.messageslink.mousedown();
    $('a',queries.messages).filter(':first').focus();
}

function watchListTabSelected() {
    return queries.watchlistlink.parent().hasClass("ui-tabs-selected");
}

function focusWatchListTab() {
    $('th a',queries.watchTable).filter(':first').focus();
}
function selectWatchListTab() {
    if (isWatchListTabVisible()) {
        queries.watchlistlink.mousedown();
        focusWatchListTab();
    }
}

function selectBuildLogTab() {
    if (isBuildLogTabVisible()) {
        queries.buildloglink.mousedown();
        $('td a',queries.buildlog).filter(':first').focus();
    }
}

// Some utilities to show/hide tabs ("visible" is a boolean value)
function isBuildLogTabVisible() {
    return isTabVisible(queries.buildloglink);
}
function isCCodeTabVisible() {
    return isTabVisible(queries.ccodelink);
}
function isWatchListTabVisible() {
    return isTabVisible(queries.watchlistlink);
}
function setWatchListTabVisible(visible) {
    setTabVisible(queries.watchlistlink, visible, queries.summarylink);
}

function isTabVisible($link) {
    return !$link.parent().hasClass("hidden");
}

function setTabVisible(link, visible, alternate) {
    var obj = link.parent();
    if (visible) {
        obj.removeClass("hidden");
    } else {
        obj.addClass("hidden");
        if (obj.hasClass("ui-tabs-selected")) {
            obj.removeClass("ui-tabs-selected");
            alternate.addClass("ui-tabs-selected");
            alternate.mousedown();
        }
    }
}

function setupFunctionList() {
    // Pre-execute and store some basic queries.
    queries.fcnlist = $(">div#MATLABcodebody", queries.west);
    queries.myscriptlist = $(">div.myscript-list", queries.fcnlist);
    queries.myfunclist = $(">table.myfunc-list", queries.fcnlist);
    queries.filtertbl = $(">.myfunc-filter-tbl", queries.fcnlist);
    queries.filterenable = $("input.filterenable", queries.filtertbl);
    
    // Make some CSS adjustments of the script parse errors table is visible.
    if (queries.myscriptlist.length > 0) {
        queries.myfunclist.css("top", queries.myscriptlist.height() + queries.filtertbl.height());
    }
    
    // Logic for the function filtering
    var selectfilterby = $("select.myfunc-filterby", queries.filtertbl);
    var selectwl = $("select.wl", queries.filtertbl); 
    var selectwloperator = $("select.wl-operator", queries.filtertbl);
    var inputs = $("td.input > div > div", queries.filtertbl);
    var rows = $(">table.myfunc-list tr", queries.fcnlist);
    var enablers = selectfilterby.add(selectwl).add(selectwloperator).add($("select.myfunc-filter", queries.filtertbl));
    var filtercounter = $(">.myfunc-count", queries.fcnlist);
    var labels = $(".myfunc-filterby-lbl, .myfunc-filterstr-lbl", queries.filtertbl).add(filtercounter);
    
    var filterFunctionList = function() {
        if (!queries.filterenable.is(":checked")) {
            enablers.attr("disabled", "disabled");
            rows.removeClass("filtered");
            $('a',rows).attr('href','#');
            labels.addClass("filtered");
        } else {
            enablers.attr("disabled", "");
            labels.removeClass("filtered");
        
            var id = $("option:selected", selectfilterby).attr("id");
            var fcns = "-1";
            var fcnids = [];
            if (id == "wl") {
                if ($("option:selected", selectwloperator).attr("id") == "eq") {
                    fcns = $("option:selected", selectwl).attr("id");
                    fcnids = fcns.split(" ");
                } else {
                    rows.show();
                }
            } else {
                fcns = $("select.myfunc-filter." + id + " option:selected", queries.filtertbl).attr("value");
                if (fcns)
                    fcnids = fcns.split(" ");
                else
                    fcnids = [];
            }
            
            $('a',rows).removeAttr('href');
            rows.addClass("filtered");
            for (var i = 0; i < fcnids.length; i++) {
                $('a',rows.filter('[id*="' + encodeFunctionIDfilter(fcnids[i]) + '"]').removeClass("filtered"))
                    .attr('href','#');
            }
        }
        var count = rows.length - rows.filter(".filtered").length;
        filtercounter.text("Filter matches: " + count + "/" + rows.length + " functions");
    }
    
    var selectChanged = function() {
        inputs.hide().filter("." + $("select.myfunc-filterby option:selected").attr("id")).show();
        filterFunctionList();
    };
    var operatorChanged = function() {
        if ($("select.wl-operator option:selected").attr("id") != "eq") {
            $("input.wl").show();
            $("select.wl").hide();
        } else {
            $("input.wl").hide();
            $("select.wl").show();
        }
        filterFunctionList();
    };
    
    // Add the events to handle updating the filtered function list whenever the options change.
    selectfilterby.change(selectChanged).keyup(selectChanged).trigger("change");
    selectwloperator.change(operatorChanged).keyup(operatorChanged).trigger("change");
    selectwl.change(filterFunctionList).keyup(filterFunctionList).trigger("change");
    selectfilterby.change(filterFunctionList).keyup(filterFunctionList);
    $("select.myfunc-filter", queries.filtertbl).change(filterFunctionList).keyup(filterFunctionList);
    queries.filterenable
        .change(filterFunctionList)
        .click(filterFunctionList)
        .keyup(filterFunctionList)
        .mouseout(filterFunctionList);

    // Manually add hovering to target code list table rows.
    queries.ccoderows.hover(function() {
        $(this).addClass("fcnid-hover");
    }, function() {
        $(this).removeClass("fcnid-hover");
    });
}

var initializeCallTree = function($root) {
    $('li.node>a', $root).mouseup(function(){
        var $this = $(this);
        if ($this.parent().hasClass('collapsed')) {
            toggleCallTreeNode($this.parent());
        }
        return false;
    });
    $('.node', $root).each(function(){
        var $node = $(this);

        if ($node.hasClass('collapsed')) {
            $('>ul',$node).hide();
        } else if (!$node.hasClass('uncollapsed')) {
            $node.addClass('uncollapsed');
        }

        $('>a',$node).before('<div class="trigger">&nbsp;');
        $('>.trigger', $node).click(function(){
            toggleCallTreeNode($node);
        }).css('float','left');
    });
    $('.leaf:last-child, .node:last-child', $root).addClass('last');
}
    
function toggleCallTreeNode($node)
{
    if ($node.hasClass('collapsed')) {
        if ($('>ul',$node).length > 0) {	        
            $('>ul',$node).show();
        } else {
            var strids = decodeFunctionID($('a',$node).attr("id"));
            $('ul',queries.allcalltreenodes.filter('#callstacknode' + parseInt(strids[1]))).clone(true).appendTo($node);
            initializeCallTree($('ul',$node));
        }
        $node.removeClass('collapsed').addClass('uncollapsed');
    } else {
        $node.removeClass('uncollapsed').addClass('collapsed');
        $('>ul',$node).hide();
    }
}

function makeCallStackTree(tree) {
    
    initializeCallTree(tree);
    toggleCallTreeNode($('.tree > .node:first-child'),tree);
}

function setupCallStack() {
    queries.callstackbody = $("> #callstackbody", queries.west);
    queries.allcalltreenodes = $("div.callstacknodes > ol.callstacknode", queries.callstackbody);
    makeCallStackTree($("> div.treewrapper > ol.tree", queries.callstackbody).get(0));
}

function setupLayout() {    
    //Make resizable west/south panes.
    var westwidth = 0;
    $('> ul > li', queries.west).each(function(n) {
        westwidth += $(this).width() + 4;
    });
    westwidth = Math.max(westwidth,220);
    var southwidth = 0;
    $('> ul > li', queries.south).each(function(n) {
        var $this = $(this);
        if (!$this.hasClass('hidden')) {
            southwidth += $(this).width() + 4;
        }
    });
    ilayout({
        spacing: 5,
        south: {
            size: Math.max(Math.floor($(document).height()*0.35),150),
            minsize: 150,
            minwidth: -southwidth
        },
        west: {
            size: westwidth+5,
            minsize: westwidth
        } 
    });
}

// A simple and custom layout manager to keep track of the three major panes (west, south, center).
function ilayout(custom_config)
{
    var defaultConfig = {
        parent: null,
        spacing: 5,

        south: null,
        west: null,
        center: null
    }

    var defaultPosition = {
        resizable: true,
        size: 150,
        minsize: 100,
        resizeFcn: null,
        
        element: jQuery(null),
        wrapper: jQuery(null)
    }
    var defaultSouth = $.extend({}, defaultPosition);
    var defaultWest  = $.extend({}, defaultPosition);

    var defaultCenter = {
        minWidth: 350,
        minHeight: 100,
        element: {}
    }

    var numCurCSS = function (object, property) {
        return parseInt(jQuery.curCSS(object[0], property, true), 10) || 0;
    }
    
    // Executed each time the layout is resized; it sets the sizes for each of the major components: west, south, center.
    var apply = function () {
        var center_top = config.spacing;
        var center_right = config.spacing;
        var center_bottom = config.spacing;
        var center_left = config.spacing;
        
        if (config.west.element.length) {
            config.west.element.css({
                position: 'absolute',
                overflow: 'hidden',
                zIndex: 1,
                top: config.spacing,
                bottom: config.spacing,
                left: config.spacing,
                width: config.west.size,
                height: 'auto'
            });
            config.west.wrapper.css({
                position:'absolute',
                overflow:'auto',
                top:0,
                left:0,
                bottom:0,
                width: config.west.size -
                    numCurCSS(config.west.wrapper, 'borderLeftWidth') -
                    numCurCSS(config.west.wrapper, 'borderRightWidth') -
                    numCurCSS(config.west.wrapper, 'paddingLeft') -
                    numCurCSS(config.west.wrapper, 'paddingRight') -
                    config.spacing
            });
            if ($.browser.msie) {
                config.west.element.width(config.west.size);
                config.west.element.height(config.parent.height() - config.spacing - 2*config.spacing);
                config.west.wrapper.width(config.west.size - config.spacing);
                config.west.wrapper.height(config.west.element.height());
            } else if ($.browser.opera) {
                config.west.element.height(config.parent.height() - center_top - center_bottom - numCurCSS(config.west.element, 'borderTopWidth') - numCurCSS(config.west.element, 'borderBottomWidth') - numCurCSS(config.west.element, 'paddingTop') - numCurCSS(config.west.element, 'paddingBottom'));
            }
            center_left += config.west.element.outerWidth();
        }



        if (config.south.element.length) {
            var width = 'auto';
            if (config.south.minwidth < 0) {
                // First time flag
                config.south.minwidth = -config.south.minwidth;
            } else {
                width = Math.max(config.south.minwidth, config.center.element.outerWidth());
            }
            config.south.element.css({
                position: 'absolute',
                overflow: 'hidden',
                zIndex: 1,
                top: 'auto',
                bottom: config.spacing,
                left: center_left,
                right: config.spacing,
                width: width
            });
            config.south.wrapper.css({
                overflow: 'auto',
                marginTop: config.spacing
            });
            if ($.browser.msie) {
                center_bottom += config.spacing;
                center_right += config.spacing;
                config.south.wrapper.width(config.parent.width() - center_right - center_left);
                config.south.wrapper.height(config.south.size - config.spacing);
                config.south.element.width(config.parent.width() - center_right - center_left);
                config.south.element.height(config.south.size);
            } else {
                config.south.element.css("height","auto");
                config.south.wrapper.height(config.south.size -
                    numCurCSS(config.south.wrapper, 'borderTopWidth') -
                    numCurCSS(config.south.wrapper, 'borderBottomWidth') -
                    numCurCSS(config.south.wrapper, 'paddingTop') -
                    numCurCSS(config.south.wrapper, 'paddingBottom') -
                    config.spacing);			
            }
            center_bottom += config.south.size;
        }


        if (config.center.element.length) {
            config.center.element.css({
                position: 'absolute',
                zIndex: 0,
                top: center_top ,
                right: center_right,
                bottom: center_bottom,
                left: center_left,
                overflow: 'auto'
            });
            if ($.browser.msie) {
                config.center.element.width(config.parent.width() - center_left - center_right);
                config.center.element.height(config.parent.height() - center_top - center_bottom);
            }
        }
    }

    var config = $.extend(defaultConfig, custom_config);
    var $window = jQuery(window);
    config.parent = queries.body;

    config.south = $.extend(defaultSouth, custom_config.south);
    config.south.wrapper = queries.south.wrap('<div class="south-wrapper"></div>');
    config.west = $.extend(defaultWest, custom_config.west);
    config.west.wrapper = queries.west.wrap('<div class="west-wrapper"></div>');

    config.center = $.extend(defaultCenter, custom_config.center);
    config.center.element = queries.center;

    config.south.element = config.south.wrapper.parent();
    config.west.element = config.west.wrapper.parent();

    config.parent.parent().css({
        height: '100%'
    });

    config.parent.css({
        position: 'relative',
        height: '100%',
        overflow: 'hidden',
        margin: 0,
        padding: 0
    });

    var updateResize = function(obj, handle) {
        if (handle == 's' || handle == 'n')
            obj.size = obj.element.outerHeight();
        else
            obj.size = obj.element.outerWidth();
        apply();
    }
    
    // Use the Jquery resizable object.
    var makeResizable = function (obj, handle) {
        if (typeof jQuery.fn.resizable == "function") {
            if (obj.resizable && obj.element.length) {
                var options = {
                    minHeight: obj.minsize,
                    maxHeight: config.parent.height() - config.center.minHeight - config.spacing,
                    minWidth: obj.minsize,
                    maxWidth: config.parent.width() - config.center.minWidth - config.spacing,
                    handles: handle,
                    ghost: false,
                    resize: function(evt,ui) {updateResize(obj,handle);},
                    stop: function(evt,ui) {updateResize(obj,handle);}
                };
                obj.element.resizable('destroy');
                obj.element.resizable(options);
                obj.element.resizable('enable');
            }
        }
    }

    // Handle browser resizing.
    $window.resize(function() {
        makeResizable(config.south, 'n');
        makeResizable(config.west, 'e');
        apply();
    }).trigger("resize");
}

// This executes whenever the user clicks on an MATLAB code link (i.e. a link to another inference function).
function fcnClick(evt) {
    // If the link was in the contents table, make sure the event corresponds to the row
    // and not the span.
    obj = $(evt.target ? evt.target : evt.srcElement);
    if (!obj.is("tr") && !obj.is("span"))
        obj = obj.parent();
    if (!obj.is("tr") && !obj.is("span"))
        obj = obj.parent();
        
    // Load up the file specified by the fcnid attribute
    openFunction(obj.attr("fcnid"));
}

// Executed whenever a C-code link is clicked.
function cFileClick(evt) {
    // If the link was in the contents table, make sure the event corresponds to the row
    // and not the span.
    obj = $(evt.target ? evt.target : evt.srcElement);
    if (!obj.is("tr"))
        obj = obj.parent();
    if (!obj.is("tr"))
        obj = obj.parent();
        
    // Load up the file specified by the file attribute.
    openFunction(obj.attr("id"));
}
