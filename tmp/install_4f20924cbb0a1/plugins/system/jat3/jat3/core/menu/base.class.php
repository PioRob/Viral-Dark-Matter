<?php
/**
 * ------------------------------------------------------------------------
 * JA T3 System plugin for Joomla 1.7
 * ------------------------------------------------------------------------
 * Copyright (C) 2004-2011 JoomlArt.com. All Rights Reserved.
 * @license GNU/GPLv3 http://www.gnu.org/licenses/gpl-3.0.html
 * Author: JoomlArt.com
 * Websites: http://www.joomlart.com - http://www.joomlancers.com.
 * ------------------------------------------------------------------------
 */

defined('_JEXEC') or die('Restricted access');

if (!defined ('_JA_BASE_MENU_CLASS')) {
	define ('_JA_BASE_MENU_CLASS', 1);

	class JAMenuBase extends JObject{
		var $_params = null;
		var $children = null;
		var $open = null;
		var $items = null;
		var $Itemid = 0;
		var $showSeparatedSub = false;
		var $_tmpl = null;
		var $_start = 1;

		function __construct( &$params ){
			$this->_params = $params;
			$this->Itemid = T3Common::getItemid ();
			//$this->loadMenu();
		}

		function createParameterObject($param, $path='', $type='menu') {
			 return new JParameter($param, $path);			
		}

		function getPageTitle ($params) {
			return $params->get ('page_title');
			
		}
		
		function  loadMenu(){
			$list		= array();
			$db			= JFactory::getDbo();
			$user		= JFactory::getUser();
			$app		= JFactory::getApplication();
			$menu		= $app->getMenu();
		
			//get user access level - used to check the access level setting for menu items
			$aid 		= $user->getAuthorisedViewLevels();
			// If no active menu, use default
			$active 	= ($menu->getActive()) ? $menu->getActive() : $menu->getDefault();
			//start - end for fetching menu items
			$start 		= (int) $this->getParam('startlevel');
			if ($start < 1) $start = 1; //first level
			$this->_start = $start;
			$end 		= (int) $this->getParam('endlevel');
				
			$this->open		= isset($active) ? $active->tree : array();
			
			$rows 		= $menu->getItems('menutype',$this->getParam('menutype'));

			if(!count($rows)) return;
    	    // first pass - collect children
    	    $children = array ();
    	    $cacheIndex = array();
 		    $this->items = array();
   	    	foreach ($rows as $index => $v) {
   	    		//bypass items not in range
				if (($start>0 && $start > $v->level)
					|| ($end>0 && $v->level > $end)
					|| ($start > 1 && !in_array($v->tree[0], $active->tree))
				) {
					continue;
				}
   	    		//1.6 compatible
   	    		if (isset ($v->title)) $v->name = $v->title; 
   	    		if (isset ($v->parent_id)) $v->parent = $v->parent_id;
   	    		 
				$v->name = str_replace ('&', '&amp;', str_replace ('&amp;', '&', $v->name));
    		    if (in_array($v->access, $aid)) {
    			    $pt = $v->parent;
    			    $list = @ $children[$pt] ? $children[$pt] : array ();
					
					$v->megaparams = new JObject();
					$v->jparams = $megaparams = new JObject(json_decode($v->params));
					if ($megaparams) {
						foreach (get_object_vars($megaparams) as $mega_name=>$mega_value) {
							if (preg_match ('/mega_(.+)/', $mega_name, $matches)) {								
								if ($matches[1] == 'colxw') {
						    		if (preg_match_all ('/([^\s]+)=([^\s]+)/', $mega_value, $colwmatches)) {
										for ($i=0;$i<count($colwmatches[0]);$i++) {
											$v->megaparams->set ($colwmatches[1][$i],$colwmatches[2][$i]);
										}
						    		}
								} else {
									if (is_array($mega_value)) $mega_value = implode (',', $mega_value);
									$v->megaparams->set ($matches[1], $mega_value);
								}
							}
						}
					}					
					
					//reset cols for group item
					//if ($v->megaparams->get('group')) $v->megaparams->set('cols', 1);
					
					if ($this->getParam('megamenu')) {
						$modules = $this->loadModules ($v->megaparams);
						//Update title: clear title if not show - Not clear title => causing none title when showing menu in other module
						//if (!$v->megaparams->get ('showtitle', 1)) $v->name = '';
						if ($modules && count($modules)>0) {
							$v->content = "";
							$total = count($modules);
							$cols =  min($v->megaparams->get('cols'), $total);
						
							for ($col=0;$col<$cols;$col++) {
								$pos = ($col == 0 ) ? 'first' : (($col == $cols-1) ? 'last' :'');
								if ($cols > 1) $v->content .= $this->beginSubMenuModules($v->id, 1, $pos, $col, true);
								$i = $col;
								while ($i<$total) {
									$mod = $modules[$i];
									if (!isset($mod->name)) $mod->name = $mod->module;
									$i += $cols;
									$mod_params = new JObject(json_decode($mod->params));
									$v->content .= "<jdoc:include type=\"module\" name=\"{$mod->name}\" title=\"{$mod->title}\" style=\"".$v->megaparams->get('style','jaxhtml')."\" />";
								}
								if ($cols > 1) $v->content .= $this->endSubMenuModules($v->id, 1, true);
							}
						
							$v->cols = $cols;
						
							$v->content = trim($v->content);
							$this->items[$v->id] = $v;
						}
					}
					
					$v->flink = $v->link;
					switch ($v->type)
					{
						case 'separator':
							// No further action needed.
							continue;
	
						case 'url':
							if ((strpos($v->link, 'index.php?') === 0) && (strpos($v->link, 'Itemid=') === false)) {
								// If this is an internal Joomla link, ensure the Itemid is set.
								$v->flink = $v->link.'&Itemid='.$v->id;
							}
							break;
	
						case 'alias':
							// If this is an alias use the item id stored in the parameters to make the link.
							$v->flink = 'index.php?Itemid='.$v->jparams->get('aliasoptions');
							break;
	
						default:
							$router = JSite::getRouter();
							if ($router->getMode() == JROUTER_MODE_SEF) {
								$v->flink = 'index.php?Itemid='.$v->id;
							} else {
								$v->flink .= '&Itemid='.$v->id;
							}
							break;
					}
					$v->url = $v->flink = JRoute::_($v->flink);
					

					// Handle SSL links
					$iParams = $this->createParameterObject($v->jparams);
					$iSecure = $iParams->def('secure', 0);
					if ($v->home == 1) {
						$v->url = JURI::base();
					} elseif (strcasecmp(substr($v->url, 0, 4), 'http') && (strpos($v->link, 'index.php?') !== false)) {
						$v->url = JRoute::_($v->url, true, $iSecure);
					} else {
						$v->url = str_replace('&', '&amp;', $v->url);
					}
					//calculate menu column
					if (!isset($v->clssfx)) {
						$v->clssfx = $iParams->get('pageclass_sfx', '');
						if ($v->megaparams->get('cols')) {
							$v->cols = $v->megaparams->get('cols');							
							$v->col = array();
							for ($i=0;$i<$v->cols;$i++) {
								if ($v->megaparams->get("col$i")) $v->col[$i]=$v->megaparams->get("col$i");
							}
						}
					}
					
					$v->_idx = count($list);									
					array_push($list, $v);
    			    $children[$pt] = $list;
					$cacheIndex[$v->id] = $index;
					$this->items[$v->id] = $v;
    		    }
    	    }
            $this->children = $children;

            //unset item load module but no content
    	    foreach ($this->items as $v) {
    	    	if (($v->megaparams->get('subcontent') || $v->megaparams->get('modid') || $v->megaparams->get('modname') || $v->megaparams->get('modpos'))
    	    		 && !isset($this->children[$v->id]) && (!isset($v->content) || !$v->content)) {
    	    		$this->remove_item($this->items[$v->id]);
    	    		unset($this->items[$v->id]);
    	    	}
    	    }
	    }
	    
		function remove_item ($item) {
			$result = array();
			foreach ($this->children[$item->parent] as $o) {
				if ($o->id != $item->id) {
					$result[] = $o;
				}
			}
			$this->children[$item->parent] = $result;
		}
				
	    function parseTitle ($title) {
	    	//replace escape character
	    	$title = str_replace (array('\\[','\\]'), array('%open%', '%close%'), $title);
	    	$regex = '/([^\[]*)\[([^\]]*)\](.*)$/';
	    	if (preg_match ($regex, $title, $matches)) {
	    		$title = $matches[1];
	    		$params = $matches[2];
	    		$desc = $matches[3];
	    	} else {
	    		$params = '';
	    		$desc = '';
	    	}
	    	$title = str_replace (array('%open%', '%close%'), array('[',']'), $title);
	    	$desc = str_replace (array('%open%', '%close%'), array('[',']'), $desc);
	    	$result = new JParameter('');
	    	$result->set('title', trim($title));
	    	$result->set('desc', trim($desc));
	    	if ($params) {
	    		if (preg_match_all ('/([^\s]+)=([^\s]+)/', $params, $matches)) {
					for ($i=0;$i<count($matches[0]);$i++) {
						$result->set ($matches[1][$i],$matches[2][$i]);
					}
	    		}
	    	}
	    	return $result;
	    }
	    
	    function loadModules($params) {
		    //Load module
		    $modules = array();
		    switch ($params->get ('subcontent')) {
		    	case 'mod':
		    		$ids = $params->get ('subcontent_mod_modules','');
		    		if (!$ids) $ids = $params->get ('subcontent-mod-modules',''); //compatible with old T3 params
		    		$ids = preg_split ('/,/', $ids); 
					foreach ($ids as $id) {
						if ($id && $module=$this->getModule ($id)) $modules[] = $module;
					}
					return $modules;
		    		break;
		    	case 'pos':
		    		$poses = $params->get ('subcontent_pos_positions','');
		    		if (!$poses) $poses = $params->get ('subcontent-pos-positions',''); //compatible with old T3 params
		    		$poses = preg_split ('/,/', $poses);
					foreach ($poses as $pos) {
						$modules = array_merge ($modules, $this->getModules ($pos));
					}
					return $modules;
		    		break;
		    	default:
		    		return $this->loadModules_ ($params); //load as old method
		    }
		    return null;
	    }
	    
	    function loadModules_($params) {
		    //Load module
		    $modules = array();
			if (($modid = $params->get('modid'))) {
				$ids = preg_split ('/,/', $modid);
				foreach ($ids as $id) {
					if ($module=$this->getModule ($id)) $modules[] = $module;
				}
				return $modules;
			} 
			
			if (($modname = $params->get('modname'))) {
				$names = preg_split ('/,/', $modname);
				foreach ($names as $name) {
					if (($module=$this->getModule (0, $name))) $modules[] = $module;
				}
				return $modules;
			}
			
			if (($modpos = $params->get('modpos'))) {
				$poses = preg_split ('/,/', $modpos);
				foreach ($poses as $pos) {
					$modules = array_merge ($modules, $this->getModules ($pos));
				}
				return $modules;
			}
			return null;
	    }
	    
		function getModules ($position) {
			return JModuleHelper::getModules ($position);
		}

		function getModule ($id=0, $name='') {
/*			
			$result		= null;
			$modules	=& JModuleHelper::_load();
			$total		= count($modules);
			for ($i = 0; $i < $total; $i++)
			{
				// Match the name of the module
				if ($modules[$i]->id == $id || $modules[$i]->name == $name)
				{
					return $modules[$i];
				}
			}
			return null;
*/
			$Itemid = $this->Itemid;
			$app	= JFactory::getApplication();
			$user	= JFactory::getUser();
			$groups	= implode(',', $user->authorisedLevels());
			$db		= JFactory::getDbo();

			//$query = new JDatabaseQuery;
			$query = $db->getQuery(true);
			$query->select('id, title, module, position, content, showtitle, params, mm.menuid');
			$query->from('#__modules AS m');
			$query->join('LEFT','#__modules_menu AS mm ON mm.moduleid = m.id');
			$query->where('m.published = 1');
			$query->where('m.id = '.$id);
			
			$date = JFactory::getDate();
			$now = $date->toMySQL();
			$nullDate = $db->getNullDate();
			$query->where('(m.publish_up = '.$db->Quote($nullDate).' OR m.publish_up <= '.$db->Quote($now).')');
			$query->where('(m.publish_down = '.$db->Quote($nullDate).' OR m.publish_down >= '.$db->Quote($now).')');
	
			$clientid = (int) $app->getClientId();
	
			if (!$user->authorise('core.admin',1)) {
				$query->where('m.access IN ('.$groups.')');
			}
			$query->where('m.client_id = '. $clientid);
			if (isset($Itemid)) {
				$query->where('(mm.menuid = '. (int) $Itemid .' OR mm.menuid <= 0)');
			}
			$query->order('position, ordering');
	
			// Filter by language
			if ($app->isSite() && $app->getLanguageFilter()) {
				$query->where('m.language in (' . $db->Quote(JFactory::getLanguage()->getTag()) . ',' . $db->Quote('*') . ')');
			}
	
			// Set the query
			$db->setQuery($query);
			$cache 		= JFactory::getCache ('com_modules', 'callback');
			$cacheid 	= md5(serialize(array($Itemid, $groups, $clientid, JFactory::getLanguage()->getTag(), $id)));
	
			$module = $cache->get(array($db, 'loadObject'), null, $cacheid, false);
			
			if (!$module) return null;
			
			$negId	= $Itemid ? -(int)$Itemid : false;
			// The module is excluded if there is an explicit prohibition, or if
			// the Itemid is missing or zero and the module is in exclude mode.
			$negHit	= ($negId === (int) $module->menuid)
					|| (!$negId && (int)$module->menuid < 0);

			// Only accept modules without explicit exclusions.
			if (!$negHit)
			{
				//determine if this is a custom module
				$file				= $module->module;
				$custom				= substr($file, 0, 4) == 'mod_' ?  0 : 1;
				$module->user		= $custom;
				// Custom module name is given by the title field, otherwise strip off "com_"
				$module->name		= $custom ? $module->title : substr($file, 4);
				$module->style		= null;
				$module->position	= strtolower($module->position);
				$clean[$module->id]	= $module;
			}
			return $module;
		}
		
		function genMenuItem($item, $level = 0, $pos = '', $ret = 0)
		{
			$data = '';
			$tmp = $item;
			$tmpname = ($this->getParam('megamenu') && !$tmp->megaparams->get ('showtitle', 1))?'':$tmp->name;
			// Print a link if it exists
			$active = $this->genClass ($tmp, $level, $pos);
			if ($active) $active = " class=\"$active\"";

			$id='id="menu' . $tmp->id . '"';
			$iParams = $item->jparams;
			$itembg = '';
			if ($this->getParam('menu_images') && $iParams->get('menu_image') && $iParams->get('menu_image') != -1) {
				if ($this->getParam('menu_background')) {
					$itembg = 'style="background-image:url('.JURI::base(true).'/'.$iParams->get('menu_image').');"';
					$txt = '<span class="menu-title">' . $tmpname . '</span>';
				} else {
					$txt = '<span class="menu-image"><img src="'.JURI::base(true).'/'.$iParams->get('menu_image').'" alt="'.$tmpname.'" title="'.$tmpname.'" /></span><span class="menu-title">' . $tmpname . '</span>';
				}
			} else {
				$txt = '<span class="menu-title">' . $tmpname . '</span>';
			}
			//Add page title to item
			if ($tmp->megaparams->get('desc')) {
				$txt .= '<span class="menu-desc">'. JText::_($tmp->megaparams->get('desc')).'</span>';
			}
			
			if (isset ($itembg) && $itembg) {
				$txt = "<span class=\"has-image\" $itembg>".$txt."</span>";
			}
			$title = "title=\"$tmpname\"";
			
			if ($tmp->type == 'menulink')
			{
				$menu = &JSite::getMenu();
				$alias_item = clone($menu->getItem($tmp->query['Itemid']));
				if (!$alias_item) {
					return false;
				} else {
					$tmp->url = $alias_item->link;
				}
			}
			if ($tmpname) {
				if ($tmp->type == 'separator')
				{
					$data = '<a href="#" '.$active.' '.$id.' '.$title.'>'.$txt.'</a>';				
				} else {
					if ($tmp->url != null)
					{
						switch ($tmp->browserNav)
						{
							default:
							case 0:
								// _top
								$data = '<a href="'.$tmp->url.'" '.$active.' '.$id.' '.$title.'>'.$txt.'</a>';
								break;
							case 1:
								// _blank
								$data = '<a href="'.$tmp->url.'" target="_blank" '.$active.' '.$id.' '.$title.'>'.$txt.'</a>';
								break;
							case 2:
								// window.open
								$attribs = 'toolbar=no,location=no,status=no,menubar=no,scrollbars=yes,resizable=yes,'.$this->getParam('window_open');
		  
								// hrm...this is a bit dickey
								$link = str_replace('index.php', 'index2.php', $tmp->url);
								$data = '<a href="'.$link.'" onclick="window.open(this.href,\'targetWindow\',\''.$attribs.'\');return false;" '.$active.' '.$id.' '.$title.'>'.$txt.'</a>';
								break;
						}
					} else {
						$data = '<a '.$active.' '.$id.' '.$title.'>'.$txt.'</a>';
					}
				}
			}
			
			//for megamenu
			if ($this->getParam ('megamenu')) {
				//For group
				if ($tmp->megaparams->get('group') && $data)
					$data = "<div class=\"group-title\">$data</div>";
				
				if (isset($item->content) && $item->content) {
					if ($item->megaparams->get('group')){
						$data .= "<div class=\"group-content\">{$item->content}</div>";
					}else{
						$data .= $this->beginMenuItems($item->id, $level+1, true);
						$data .= $item->content;
						$data .= $this->endMenuItems($item->id, $level+1, true);
					}
				}
			}
			
			if ($ret) return $data; else echo $data;				
		}

		function getParam($paramName, $default=null){
			$val = $this->_params->get($paramName, null);
			if (!$val) $val = $default;
			return $val;
		}

		function setParam($paramName, $paramValue){
			return $this->_params->set($paramName, $paramValue);
		}

		function beginMenu($startlevel=0, $endlevel = 10){
			echo "<div>";
		}
		function endMenu($startlevel=0, $endlevel = 10){
			echo "</div>";
		}

		function beginMenuItems($pid=0, $level=0){
			echo "<ul>";
		}
		function endMenuItems($pid=0, $level=0){
			echo "</ul>";
		}
		function beginSubMenuItems($pid=0, $level=0, $pos='', $i, $return = false){
			//for megamenu menu
		}
		function endSubMenuItems($pid=0, $level=0, $return = false){
			//for megamenu menu
		}

		function beginMenuItem($mitem=null, $level = 0, $pos = ''){
			$active = $this->genClass ($mitem, $level, $pos);
			if ($active) $active = " class=\"$active\"";
			echo "<li $active>";
		}
		function endMenuItem($mitem=null, $level = 0, $pos = ''){
			echo "</li>";
		}

		function genClass ($mitem, $level, $pos) {
			$iParams = $mitem->jparams;
			$active = in_array($mitem->id, $this->open);
			$cls = ($level?"":"menu-item{$mitem->_idx}"). ($active?" active":"").($pos?" $pos-item":"");
			if (@$this->children[$mitem->id] && (!$level || $level < $this->getParam ('endlevel'))) $cls .= " haschild";
			if ($mitem->megaparams->get('class')) $cls .= ' '.$mitem->megaparams->get('class');
			return $cls;
		}

		function hasSubMenu($level) {
			$pid = $this->getParentId ($level);
			if (!$pid) return false;
			return $this->hasSubItems ($pid);
		}
		function hasSubItems($id){
			if (@$this->children[$id]) return true;
			return false;
		}
		
		function getKey ($startlevel=0, $endlevel = -1) {
			$key = "$startlevel.{$this->Itemid}.".$this->getParam ('menutype').".".get_class ($this);
			return md5 ($key);
		}
		
		function genMenu($startlevel=0, $endlevel = -1){
			$this->setParam('startlevel', $startlevel);
			$this->setParam('endlevel', $endlevel==-1?10:$endlevel);
			$this->beginMenu($startlevel, $endlevel);

			$pid = $this->getParentId($this->getParam('startlevel'));
			if ($pid)
				$this->genMenuItems ($pid, $this->getParam('startlevel'));
				
			$this->endMenu($startlevel, $endlevel);
		}

		/*
		 $pid: parent id
		 $level: menu level
		 $pos: position of parent
		 */

		function genMenuItems($pid, $level) {
			if (@$this->children[$pid]) {
				//Detect description. If some items have description, must generate empty description for other items
				$hasDesc = false;
				foreach ($this->children[$pid] as $row) {
					if ($row->megaparams->get('desc')) {
						$hasDesc = true;
						break;
					}
				}
				if ($hasDesc) {
					//Update empty description with a space - &nbsp;
					foreach ($this->children[$pid] as $row) {
						if (!$row->megaparams->get('desc')) {
							$row->megaparams->set('desc', '&nbsp;');
						}
					}
				}
				
				$j = 0;
				$cols = $pid && $this->getParam('megamenu') && isset($this->items[$pid]) && isset($this->items[$pid]->cols) && $this->items[$pid]->cols ? $this->items[$pid]->cols : 1;				
				$total = count ($this->children[$pid]);
				$tmp = $pid && isset($this->items[$pid])?$this->items[$pid]:new stdclass();
				if ($cols > 1) {
					$fixitems = count($tmp->col);
					if ($fixitems < $cols) {
						$fixitem = array_sum($tmp->col);
						$leftitem = $total-$fixitem;
						$items = ceil ($leftitem/($cols-$fixitems));
						for ($m=0;$m<$cols && $leftitem > 0;$m++) {
							if (!isset($tmp->col[$m]) || !$tmp->col[$m]) { 
								if ($leftitem > $items) {
									$tmp->col[$m] = $items;
									$leftitem -= $items;
								} else {
									$tmp->col[$m] = $leftitem;
									$leftitem = 0;
								}
							}
						}
						
						$cols = count ($tmp->col);
						$tmp->cols = $cols;
					}
				} else {
					$tmp->col = array($total);
				}
				
				//recalculate the colw for this column if the first child is group
				for ($col=0,$j=0;$col<$cols && $j<$total;$col++) {
					$i = 0;
					$colw = 0;
					while ($i < $tmp->col[$col] && $j<$total) {
						$row = $this->children[$pid][$j];
						if ($row->megaparams->get('group') && $row->megaparams->get ('width', 0) > $colw) {
							$colw = $row->megaparams->get ('width');
						}
						$j++;$i++;
					}
					if ($colw && isset($this->items[$pid])) $this->items[$pid]->megaparams->set ('colw'.($col+1), $colw);
				}
				$this->beginMenuItems($pid, $level);
				for ($col=0,$j=0;$col<$cols && $j<$total;$col++) {
					$pos = ($col == 0 ) ? 'first' : (($col == $cols-1) ? 'last' :'');
					//recalculate the colw for this column if the first child is group
					if ($this->children[$pid][$j]->megaparams->get('group') && $this->children[$pid][$j]->megaparams->get ('width'))
						$this->items[$pid]->megaparams->set ('colw'.($col+1), $this->children[$pid][$j]->megaparams->get ('width'));
						
					$this->beginSubMenuItems($pid, $level, $pos, $col);
					$i = 0;
					while ($i < $tmp->col[$col] && $j<$total) {
					//foreach ($this->children[$pid] as $row) {
						$row = $this->children[$pid][$j];
						$pos = ($i == 0 ) ? 'first' : (($i == count($this->children[$pid])-1) ? 'last' :'');

						$this->beginMenuItem($row, $level, $pos);
						$this->genMenuItem( $row, $level, $pos);

						// show menu with menu expanded - submenus visible
						
						if ($this->getParam('megamenu') && $row->megaparams->get('group')) $this->genMenuItems( $row->id, $level ); //not increase level
						else if ($level < $this->getParam('endlevel')) $this->genMenuItems( $row->id, $level+1 );

						$this->endMenuItem($row, $level, $pos);
						$j++;$i++;
					}
					$this->endSubMenuItems($pid, $level);
				}
				$this->endMenuItems($pid, $level);
			}
		}

		function indentText($level, $text) {
			echo "\n";
			for ($i=0;$i<$level;++$i) echo "   ";
			echo $text;
		}

		function getParentId ($shiftlevel) {
			$level = $this->_start + $shiftlevel - 2;
			if ($level<0 || (count($this->open) <= $level)) return 1; //out of range
			return $this->open[$level];
		}

		function getParentText ($level) {
			$pid = $this->getParentId ($level);
			if ($pid) {
				return $this->items[$pid]->name;
			}else return "";
		}

		function genMenuHead () {
			if (isset($this->_css) && count($this->_css)) {
				foreach ($this->_css as $url)
					echo "<link href=\"{$url}\" rel=\"stylesheet\" type=\"text/css\" />";			
			}
			if (isset($this->_js) && count($this->_js)) {
				foreach ($this->_js as $url)
					echo "<script src=\"{$url}\" language=\"javascript\" type=\"text/javascript\"></script>";
			}
		}
	}
}