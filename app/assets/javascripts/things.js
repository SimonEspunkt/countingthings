
//javascript file for controller action things#show
$(".things.show").ready(function() {

  config();


  $.ajax({
    type: "GET",
    url: url(),
    success: function(response) {
      displayDailyStats(response, 5);
    }
  });

});

//general setup goes in here
function config() {
  moment.locale('de');
}


function arrayOfDaysFromNow(amountOfDays) {
  var resultArr = [];
  for (var i = 0; i <= amountOfDays-1; i++) {
    resultArr[i] = moment().subtract(i, 'days');
  }
  return resultArr.reverse();
}


function url() {
  var prefix = $('#thingname').attr('data-thing-id');
  var url = 'statistic.json';
  return prefix + '/' + url;
}

function displayDailyStats(data, amountOfDays) {
  var stats = prepareStats(data, amountOfDays);
  renderStats(stats);
}


function prepareStats(data, amountOfDays) {
  var stats = [];

  var user_count = data.users.length;
  var evt_count = data.userevents.length;

  var daysArray = arrayOfDaysFromNow(amountOfDays);

  for (var u = 0; u < user_count; u++) { 
    var dataset = new Object();
    dataset.user_id = data.users[u].id;
    dataset.user_email = data.users[u].email;
    dataset.dates = [];

    var dateArr = [];

    for (var day = 0; day < amountOfDays; day++) {
      for (var evt in data.userevents) {
        var key = '[' + dataset.user_id + ', "' + daysArray[day].format('YYYY-MM-DD') + '"]';

        if (data.userevents[key]) {
          dateArr[day] = data.userevents[key];
        } else {
          dateArr[day] = 0;
        }
      }
      dataset.dates[day] = daysArray[day].format('YYYY-MM-DD');
    }

    dataset.events = dateArr;
    stats[u] = dataset;
  }

  return stats;
}



function renderStats(stats) {
  var options = {
    responsive: true
  }

  var data = new Object();
  data.labels = stats[0].dates;
  data.datasets = [];

  for (var d = 0; d < stats.length; d++ ) {
    var dataset = new Object();
    dataset.label = stats[d].user_email;
    dataset.fillColor = "rgba(220,220,220,0.2)";
    dataset.strokeColor = "rgba(220,220,220,1)";
    dataset.pointColor = "rgba(220,220,220,1)";
    dataset.pointStrokeColor = "#fff";
    dataset.pointHighlightFill = "#fff";
    dataset.pointHighlightStroke = "rgba(220,220,220,1)";
    dataset.data = stats[d].events;

    data.datasets[d] = dataset;
  }
  console.log(data);


  var ctx = $("#myChart").get(0).getContext("2d")
  var myNewChart = new Chart(ctx).Line(data, options)
}