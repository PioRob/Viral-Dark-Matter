<?php
/**
 * @version		$Id: blog.php 17187 2010-05-19 11:18:22Z infograf768 $
 * @package		Joomla.Site
 * @subpackage	com_content
 * @copyright	Copyright (C) 2005 - 2010 Open Source Matters, Inc. All rights reserved.
 * @license		GNU General Public License version 2 or later; see LICENSE.txt
 */

// no direct access
defined('_JEXEC') or die;

JHtml::addIncludePath(JPATH_COMPONENT.'/helpers');

$pageClass = $this->params->get('pageclass_sfx');
?>

<div class="blog<?php echo $pageClass;?>">
<?php if ($this->params->get('show_page_heading')!=0 or $this->params->get('show_category_title')): ?>
<h1 class="componentheading">

<?php if ( $this->params->get('show_page_heading')!=0) : ?>
	<?php echo $this->escape($this->params->get('page_heading')); ?>
<?php endif; ?>
	<?php if ($this->params->get('show_category_title')) :?>


	<?php	echo '<span class="subheading-category">'.$this->category->title.'</span>'; ?>
	<?php endif; ?>

</h1>
<?php endif; ?>




<?php if ($this->params->get('show_description', 1) || $this->params->def('show_description_image', 1)) : ?>
	<div class="category-desc clearfix">
	<?php if ($this->params->get('show_description_image') && $this->category->getParams()->get('image')) : ?>
		<img src="<?php echo $this->category->getParams()->get('image'); ?>"/>
	<?php endif; ?>
	<?php if ($this->params->get('show_description') && $this->category->description) : ?>
		<?php echo JHtml::_('content.prepare', $this->category->description); ?>
	<?php endif; ?>
	</div>
<?php endif; ?>



<?php $leadingcount=0 ; ?>
<?php if (!empty($this->lead_items)) : ?>
<div class="items-leading clearfix">
	<?php foreach ($this->lead_items as &$item) : ?>
		<div class="leading leading-<?php echo $leadingcount; ?><?php echo $item->state == 0 ? 'class="system-unpublished"' : null; ?>">
			<?php
				$this->item = &$item;
				echo $this->loadTemplate('item');
			?>
		</div>
		<?php
			$leadingcount++;
		?>
	<?php endforeach; ?>
</div>
<?php endif; ?>
<?php
	$introcount=(count($this->intro_items));
	$counter=0;
?>
<?php if (!empty($this->intro_items)) : ?>

	<?php foreach ($this->intro_items as $key => &$item) : ?>
	<?php
		$key= ($key-$leadingcount)+1;
		$rowcount=( ((int)$key-1) %	(int) $this->columns) +1;
		$row = $counter / $this->columns ;

		if ($rowcount==1) : ?>
	<div class="items-row cols-<?php echo (int) $this->columns;?> <?php echo 'row-'.$row ; ?> clearfix">
	<?php endif; ?>
	<div class="item column-<?php echo $rowcount;?><?php echo $item->state == 0 ? ' system-unpublished' : null; ?>">
		<div class="contentpaneopen">
		<?php
			$this->item = &$item;
			echo $this->loadTemplate('item');
		?>
		</div>
	</div>
	<?php $counter++; ?>
	<?php if (($rowcount == $this->columns) or ($counter ==$introcount)): ?>
				<!--span class="row-separator"></span-->
				</div>

			<?php endif; ?>
	<?php endforeach; ?>


<?php endif; ?>

<?php if (!empty($this->link_items)) : ?>

	<?php echo $this->loadTemplate('links'); ?>

<?php endif; ?>


	<?php if (is_array($this->children[$this->category->id]) && count($this->children[$this->category->id]) > 0 && $this->maxLevel != 0) : ?>
		<div class="cat-children">
		<h3>
<?php echo JTEXT::_('JGLOBAL_SUBCATEGORIES'); ?>
</h3>
			<?php echo $this->loadTemplate('children'); ?>
		</div>
	<?php endif; ?>

<?php if (($this->params->def('show_pagination', 1) == 1  || ($this->params->get('show_pagination') == 2)) && ($this->pagination->get('pages.total') > 1)) : ?>
		<div class="pagination clearfix">
						<?php  if ($this->params->def('show_pagination_results', 1)) : ?>
						<p class="counter">
								<?php echo $this->pagination->getPagesCounter(); ?>
						</p>

				<?php endif; ?>
				<?php echo $this->pagination->getPagesLinks(); ?>
		</div>
<?php  endif; ?>

</div>
