//javascript file for controller action things#index
$(".things.index").ready(function() {

  //color all cardlinks border-tops

  $('.pushup').each(function() {
    var owner = $(this).closest('li.card').find('.owner').html();
    $(this).css('border-color', getColorFromUsername(owner, 1));
  });


  //replace all links with paragraphs
  $('.add').each(function() {
    var href = $(this).attr('href');
    $(this).attr('data-href', href);
    $(this).attr('href', 'javascript:;');
  });

  //bind click-event to paragraphs and unbind after paragraph is clicked
  $('a.add').each(function() {
    $(this).on('click', addEvent);
    $(this).click(function(elem) {
      $(this).off('click', addEvent);
    });
  });

  //send ajax-request and rebind click event after request is complete
  function addEvent(elem) {
    var url = $(this).attr('data-href') + '.json';

    $.ajax({
      type: "POST",
      url: url,
      success: function(response) {
        $(elem.currentTarget).closest('li.card').find('.count').html(response.events_count);
      },
      complete: function() {
        $(elem.currentTarget).on('click',addEvent);
      }
    });
  }

});