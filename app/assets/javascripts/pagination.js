if (history && history.pushState) {
  $(function () {
    $(document).on('click', '.pagination a, th a', function (e) {
      $(".pagination").html("Page is loading...");
      $.get(this.href, null, null, 'script');
      history.pushState(null, document.title, this.href);
      //e.preventDefault();
      return false;
    });
    /*$(document).on('submit','#search_form', function(){
     $.get(this.action, $(this).serialize(), null, 'script');
     return false;
     })*/
    $(document).on('input', '#search_form input', function () {
      $.get($('#search_form').attr('action'), $('#search_form').serialize(), null, 'script');
      history.replaceState(null, document.title, $('#search_form').attr('action') + "?" + $('#search_form').serialize());
      return false;
    });

    $(window).bind("popstate", function() {
      $.getScript(location.href);
    });

    $(window).scroll(function () {
      var url = $('.pagination .next a').attr('href');
      if (url && $(window).scrollTop() > $(document).height() - $(window).height() - 50) {
        $(".pagination").html("Page is loading...");
        $.getScript(url + '?endless=true');
      }
    })

  })
}