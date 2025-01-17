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
?>
<?php
$modules = preg_split ('/,/', T3Common::node_data($block));
$parent = T3Common::node_attributes ($block, 'parent', 'middle');
$style = $this->getBlockStyle ($block, $parent);
if (!$this->countModules (T3Common::node_data($block))) return;
?>
<?php foreach ($modules as $module) : 
	if ($this->countModules($module)) : 
	?>
		<jdoc:include type="module" name="<?php echo $module ?>" style="<?php echo $style ?>" />		
<?php endif; 
endforeach ?>
