$(function(){
  $(document).on('click','.pagination a, th a',function(){
    $(".pagination").html("Page is loading...");
    $.get(this.href, null, null, 'script');
    return false;
  });
  /*$(document).on('submit','#search_form', function(){
    $.get(this.action, $(this).serialize(), null, 'script');
    return false;
  })*/
  $(document).on('input','#search_form input', function() {
    $.get($('#search_form').attr('action'), $('#search_form').serialize(), null, 'script');
    return false;
  });
})