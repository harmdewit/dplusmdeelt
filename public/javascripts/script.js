$('document').ready(function(){
	
	var page = 0;
	var total = $('#slider_container .container_12').length - 1;
	var container_slider = $('#slider_container');
	var page_margin = ($(window).width() - 960) / 2 + 1;
	var slide_length = 960 + page_margin

	container_slider.children('.page').css('margin-left', page_margin);
	
	function navigate() {
		$(container_slider).css('left', (page* -slide_length) + 'px')
		
		var nav_pages = $('#page_nav').children().children()
		nav_pages.css('background-color', '#6990cb')
		nav_pages.css('color', '#fff')

		var active_page = $('#page_nav').children().children("." + page)
		active_page.css('background-color', '#fff')
		active_page.css('color', '#6990cb')

		if (page == 0) {
			$('#previous_date').css('display', 'block')
			$('#previous_arrow').css('display', 'none')
		} else {
			$('#previous_date').css('display', 'none')
			$('#previous_arrow').css('display', 'block')
		}
				
		if (page == total) {
			$('#next_date').css('display', 'block')
			$('#next_arrow').css('display', 'none')
			
		} else {
			$('#next_date').css('display', 'none')
			$('#next_arrow').css('display', 'block')
		}
		
		window.location.hash = '#page_' + page
	}
	


	$('#next_arrow').click(function() {		
		if (page < total) {
			page++;
		}
		navigate()
		return false;
	});
	
	$('#previous_arrow').click(function() {		
		if (page > 0) {
			page--;
		}
		navigate()
 		return false;
	});
	
	$('#page_nav').children().children().click(function() {
		regex = /#page_(\d)/
		result = regex.exec(this, '$1')
		page = result[1]
		
		navigate()
	});

	// Navigate to page stated in url hash
	if (window.location.hash) {
		if (window.location.hash == '#first') {
			page = 0
		} else if (window.location.hash == '#last') {
			page = total
		} else {
			regex_result = /#page_(\d)/.exec(window.location.hash)
			page = regex_result[1]
		}
	} else if (window.location.pathname == '/'){
		page = total
	}
	navigate()

	
	// Depriciated
	$('#clickme_javascript').click(function() {

		if (page < total - 1) {
			page++;
			// $(container_slider.children()[page - 1]).animate({opacity: '0'}, 400, function() {
				$(container_slider).animate({left: page*(-slide_length)}, 200 ) //, function() {
					// $(container_slider.children()).css({opacity: '100'})
				//})
			// });



		} else {
		 	// $(container_slider.children()).css({opacity: '100'})
			// $(container_slider.children()[page]).animate({opacity: '0'}, 400, function() { 
				$(container_slider).animate({left: '0'}, 1000)//, function() {
				 	// $(container_slider.children()).css({opacity: '100'})
				// });
			// });
			container_slider.removeClass('slider_container_' + page_for_animation) 
			container_slider.addClass('slider_container_' + 0)
			page = 0;
		}

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