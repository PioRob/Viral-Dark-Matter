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
t3import ('core.libs.Browser');
$browser = new Browser();
if (!$browser->isMobile()) return; 
$handheld_view = $this->getParam('ui');
$switch_to = $handheld_view=='desktop'?'default':'desktop';
$text = $handheld_view=='desktop'?'MOBILE_VERSION':'DESKTOP_VERSION';
?>

<a class="ja-tool-switchlayout" href="<?php echo JURI::base()?>?ui=<?php echo $switch_to?>" title="<?php echo JText::_($text)?>"><span><?php echo JText::_($text)?></span></a>