
//javascript file for controller action things#show
$(".things.show").ready(function() {

  config_show();
  colorLegend();
  displayOverallStats();

  $('.sub-nav dd').click(function (evt) {
    changeActiveClass(evt);
  });

  $('.daily').click(function (evt) {
    displayDailyStats(15);
  });

  $('.monthly').click(function (evt) {
    displayMonthlyStats(12);
  });

  $('.yearly').click(function (evt) {
    displayYearlyStats();  
  });

  $('.overall').click(function (evt) {
    displayOverallStats();
  });
});



$(".things.index").ready(function() {
  $('a.add').each(function() {
    var href = $(this).attr('href');
    var inner = $(this).html();
    var newLink = '<p class="add" data-href="' + href + '">' + inner + '</p>';
    $(this).replaceWith(newLink);
  });

  $('p.add').each(function() {
    $(this).click(function(elem) {
      var url = $(this).attr('data-href') + '.json';

      $.ajax({
        type: "POST",
        url: url,
        success: function(response) {
          $(elem.currentTarget).closest('.panel').find('.count').html(response.events_count);
        }
      });
    });
  });
});
