$('button').hover(function(){
   var $this = $(this);
   var $prevAll = $(this).prevAll();
   
   var className = $this.attr("class") + "-hover";
   
   $this.addClass(className);
   $prevAll.addClass(className);
}, function() {
   var $this = $(this);
   var $prevAll = $(this).prevAll();
   
   $this.removeClass("detractor-hover passive-hover promoter-hover");
   $prevAll.removeClass("detractor-hover passive-hover promoter-hover");
});