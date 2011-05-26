$('document').ready(function(){
	
	var counter = 0;
	var total = $('#slider_container .container_12').length - 1;
	var container_slider = $('#slider_container');
	var page_margin = ($(window).width() - 960) / 2 + 1;
	var slide_length = 960 + page_margin
	// alert(page_margin);
	container_slider.children('.page').css('margin-left', page_margin);
	
	$('#total').html(total);	

	$('#next_arrow').click(function() {		
		if (counter < total) {
			counter++;
			$(container_slider).css('left', (counter * -slide_length) + 'px');
	 		$('#counter').html(counter);

		} else {
			counter = 0;
			$(container_slider).css('left', (counter * -slide_length) + 'px');
	 		$('#counter').html(counter);
		}
		return false;
	});
	
	$('#previous_arrow').click(function() {		
		if (counter > 0) {
			counter--;
			$(container_slider).css('left', (counter * -slide_length) + 'px');
			$('#counter').html(counter);
		} else {
			counter = 0;
			$(container_slider).css('left', (counter * -slide_length) + 'px');
		}
 		return false;
	});
	
	$('#page_nav').children().children().click(function() {
		regex = /#page_(\d)/
		result = regex.exec(this, '$1')
		$(slider_container).css('left', (result[1] * -slide_length) + 'px')
		$('#counter').html(result[1]);
		return false;
 		
	});

	// Navigate to page stated in url hash
	if (window.location.hash) {
		counter = /#page_(\d)/.exec(window.location.hash)
		$(slider_container).css('left', (counter[1] * -slide_length) + 'px')
	}


	$('#clickme_javascript').click(function() {

		if (counter < total - 1) {
			counter++;
			// $(container_slider.children()[counter - 1]).animate({opacity: '0'}, 400, function() {
				$(container_slider).animate({left: counter*(-slide_length)}, 200 ) //, function() {
					// $(container_slider.children()).css({opacity: '100'})
				//})
			// });



		} else {
		 	// $(container_slider.children()).css({opacity: '100'})
			// $(container_slider.children()[counter]).animate({opacity: '0'}, 400, function() { 
				$(container_slider).animate({left: '0'}, 1000)//, function() {
				 	// $(container_slider.children()).css({opacity: '100'})
				// });
			// });
			container_slider.removeClass('slider_container_' + counter_for_animation) 
			container_slider.addClass('slider_container_' + 0)
			counter = 0;
		}
 		$('#counter').html(counter + 1);

		return false;
	});
	
	
	/* This is basic - uses default settings */
	
	$("a.gallery_item").fancybox({
		'transitionIn'	:	'elastic',
		'transitionOut'	:	'elastic',
		'titlePosition'		: 'outside',
		'overlayColor'		: '#000',
		'overlayOpacity'	: 0.9
	});
	
	
	
	// We only want these styles applied when javascript is enabled
	$('div.navigation').css({'width' : '300px', 'float' : 'left'});
	$('div.content').css('display', 'block');

	// Initially set opacity on thumbs and add
	// additional styling for hover effect on thumbs
	var onMouseOutOpacity = 0.67;
	$('.thumbs_container ul.thumbs li').opacityrollover({
		mouseOutOpacity:	 onMouseOutOpacity,
		mouseOverOpacity:	1.0,
		fadeSpeed:				 'fast',
		exemptionSelector: '.selected'
	});
	
	// Initialize Advanced Galleriffic Gallery
	var gallery = $('.thumbs_container').galleriffic({
		delay:										 2500,
		numThumbs:								 20,
		preloadAhead:							10,
		enableTopPager:						false,
		enableBottomPager:				 false,
		maxPagesToShow:						7,
		imageContainerSel:				 '#slideshow',
		controlsContainerSel:			'#controls',
		captionContainerSel:			 '#caption',
		loadingContainerSel:			 '#loading',
		renderSSControls:					true,
		renderNavControls:				 true,
		playLinkText:							'Play Slideshow',
		pauseLinkText:						 'Pause Slideshow',
		prevLinkText:							'‹ Previous Photo',
		nextLinkText:							'Next Photo ›',
		nextPageLinkText:					'Next ›',
		prevPageLinkText:					'‹ Prev',
		enableHistory:						 false,
		autoStart:								 false,
		syncTransitions:					 true,
		defaultTransitionDuration: 900,
		onSlideChange:						 function(prevIndex, nextIndex) {
			// 'this' refers to the gallery, which is an extension of $('#thumbs')
			this.find('ul.thumbs').children()
				.eq(prevIndex).fadeTo('fast', onMouseOutOpacity).end()
				.eq(nextIndex).fadeTo('fast', 1.0);
		},
		onPageTransitionOut:			 function(callback) {
			this.fadeTo('fast', 0.0, callback);
		},
		onPageTransitionIn:				function() {
			this.fadeTo('fast', 1.0);
		}
	});
});