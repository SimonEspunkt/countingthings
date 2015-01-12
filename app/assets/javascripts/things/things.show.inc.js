//general setup goes in here
function config_show() {
  moment.locale('de');
}


//
// dailyStats
//
function displayDailyStats(numberOfDays) {

  data = {
    type: 'daily',
    length: numberOfDays
  };

  $.ajax({
    type: "GET",
    url: url(),
    data: data,
    beforeSend: function(evt) {
      $('.detailpage').each(function() {
        if (!$(this).hasClass('hide')) {
          $(this).addClass('hide');
        }
      })

      $('#dailypage').removeClass('hide');
    },
    success: function(response) {
      var stats = prepareDailyStats(response, numberOfDays);
      renderDailyStats(stats);
    }
  });
}


function prepareDailyStats(data, amountOfDays) {
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


function renderDailyStats(stats) {
  var options = {
    responsive: true
  }

  var data = new Object();
  data.labels = stats[0].dates;
  data.datasets = [];

  for (var d = 0; d < stats.length; d++ ) {

    //console.log(getColorFromUsername(stats[d].user_email, 1))

    var dataset = new Object();
    dataset.label = stats[d].user_email;
    dataset.fillColor = getColorFromUsername(stats[d].user_email, 0.5);
    dataset.strokeColor = getColorFromUsername(stats[d].user_email, 0.8);
    dataset.highlightFill = getColorFromUsername(stats[d].user_email, 0.75);
    dataset.highlightStroke = getColorFromUsername(stats[d].user_email, 1);
    dataset.data = stats[d].events;

    data.datasets[d] = dataset;
  }

  var ctx = $("#dailyChart").get(0).getContext("2d")
  var dailyChart = new Chart(ctx).Bar(data, options)
}


//
// overall stats
//
function displayOverallStats() {

  data = {
    type: 'overall'
  }

  $.ajax({
    type: "GET",
    url:url(),
    data: data,
    beforeSend: function(evt) {
      $('.detailpage').each(function() {
        if (!$(this).hasClass('hide')) {
          $(this).addClass('hide');
        }
      })

      $('#overallpage').removeClass('hide');
    },
    success: function(response) {
      var stats = prepareOverallStats(response);
      renderOverallStats(stats);
    }
  })
}


function prepareOverallStats(data) {
  var stats = [];

  var user_count = data.users.length;
  var evt_count = data.userevents.length;

  for (var u = 0; u < user_count; u++) { 
    var dataset = new Object();
    dataset.user_id = data.users[u].id;
    dataset.user_email = data.users[u].email;

    for (var evt in data.userevents) {
      var key = dataset.user_id;

      if (data.userevents[key]) {
        dataset.amount = data.userevents[key];
      } else {
        dataset.amount = 0;
      }
    }
    stats[u] = dataset;
  }

  return stats;
}


function renderOverallStats(stats) {
  var options = {
    responsive: true,
    percentageInnerCutout: 30
  }

  var data = []
  
  for (var d = 0; d < stats.length; d++ ) {
    var dataset = new Object();
    dataset.label = stats[d].user_email;
    dataset.color = getColorFromUsername(stats[d].user_email, 0.8);
    dataset.highlight = getColorFromUsername(stats[d].user_email, 1);
    dataset.value = stats[d].amount;
    data[d] = dataset;
  }

  var ctx = $("#overallChart").get(0).getContext("2d")
  //var overallChart = new Chart(ctx).PolarArea(data, options)
  var overallChart = new Chart(ctx).Doughnut(data, options)
}


//
// yearly stats
//
function displayYearlyStats() {

  data = {
    type: 'yearly'
  }

  $.ajax({
    type: "GET",
    url:url(),
    data: data,
    beforeSend: function(evt) {
      $('.detailpage').each(function() {
        if (!$(this).hasClass('hide')) {
          $(this).addClass('hide');
        }
      })

      $('#yearlypage').removeClass('hide');
    },
    success: function(response) {
      var stats = prepareYearlyStats(response);
      renderYearlyStats(stats);
    }
  })
}

function prepareYearlyStats(data) {
  var stats = [];

  var user_count = data.users.length;
  var evt_count = data.userevents.length;

  var yearsArray = data.datarange;

  for (var u = 0; u < user_count; u++) { 
    var dataset = new Object();
    dataset.user_id = data.users[u].id;
    dataset.user_email = data.users[u].email;
    dataset.years = [];

    var dateArr = [];

    for (var year = 0; year < yearsArray.length; year++) {
      for (var evt in data.userevents) {
        var key = '[' + dataset.user_id + ', "' + yearsArray[year] + '"]';

        if (data.userevents[key]) {
          dateArr[year] = data.userevents[key];
        } else {
          dateArr[year] = 0;
        }
      }
      dataset.years[year] = yearsArray[year];
    }

    dataset.events = dateArr;
    stats[u] = dataset;
  }

  return stats;
}


function renderYearlyStats(stats) {
  var options = {
    responsive: true,
    barValueSpacing: 10
  }

  var data = new Object();
  data.labels = stats[0].years;
  data.datasets = [];

  for (var d = 0; d < stats.length; d++ ) {
    var dataset = new Object();
    dataset.label = stats[d].user_email;
    dataset.fillColor = getColorFromUsername(stats[d].user_email, 0.5);
    dataset.strokeColor = getColorFromUsername(stats[d].user_email, 0.8);
    dataset.highlightFill = getColorFromUsername(stats[d].user_email, 0.75);
    dataset.highlightStroke = getColorFromUsername(stats[d].user_email, 1);
    dataset.data = stats[d].events;

    data.datasets[d] = dataset;
  }

  var ctx = $("#yearlyChart").get(0).getContext("2d")
  var yearlyChart = new Chart(ctx).Bar(data, options)
}


//
// monthly stats
//
function displayMonthlyStats(numberOfMonths) {

  data = {
    type: 'monthly',
    length: numberOfMonths
  };

  $.ajax({
    type: "GET",
    url: url(),
    data: data,
    beforeSend: function(evt) {
      $('.detailpage').each(function() {
        if (!$(this).hasClass('hide')) {
          $(this).addClass('hide');
        }
      })

      $('#monthlypage').removeClass('hide');
    },
    success: function(response) {
      var stats = prepareMonthlyStats(response, numberOfMonths);
      renderMonthlyStats(stats);
    }
  });
}


function prepareMonthlyStats(data, amountOfMonths) {
  var stats = [];

  var user_count = data.users.length;
  var evt_count = data.userevents.length;

  var monthsArray = arrayOfMonthsFromNow(amountOfMonths);

  for (var u = 0; u < user_count; u++) { 
    var dataset = new Object();
    dataset.user_id = data.users[u].id;
    dataset.user_email = data.users[u].email;
    dataset.months = [];

    var dateArr = [];

    for (var month = 0; month < amountOfMonths; month++) {
      for (var evt in data.userevents) {
        var key = '[' + dataset.user_id + ', "' + monthsArray[month].format('YYYY-MM') + '"]';

        if (data.userevents[key]) {
          dateArr[month] = data.userevents[key];
        } else {
          dateArr[month] = 0;
        }
      }
      dataset.months[month] = monthsArray[month].format('YYYY-MM');
    }

    dataset.events = dateArr;
    stats[u] = dataset;
  }

  return stats;
}


function renderMonthlyStats(stats) {
  var options = {
    responsive: true
  }

  var data = new Object();
  data.labels = stats[0].months;
  data.datasets = [];

  for (var d = 0; d < stats.length; d++ ) {

    var dataset = new Object();
    dataset.label = stats[d].user_email;
    dataset.fillColor = getColorFromUsername(stats[d].user_email, 0.5);
    dataset.strokeColor = getColorFromUsername(stats[d].user_email, 0.8);
    dataset.highlightFill = getColorFromUsername(stats[d].user_email, 0.75);
    dataset.highlightStroke = getColorFromUsername(stats[d].user_email, 1);
    dataset.data = stats[d].events;

    data.datasets[d] = dataset;
  }

  var ctx = $("#monthlyChart").get(0).getContext("2d")
  var monthlyChart = new Chart(ctx).Bar(data, options)
}




//
// helper functions
//
function colorLegend() {
  $('.username').each(function() {
    var color = getColorFromUsername($(this).html().trim(),1);
    $(this).prev('.legend').css('background-color', color);

    //$(this).prepend('<span class="legend left" style="background-color:' + color + '"></span>')
  });
}

function changeActiveClass(evt) {
  $('.sub-nav dd').each(function() {
    if($(this).hasClass('active')) {
      $(this).removeClass('active');
    }
  });

  $(evt.currentTarget).addClass('active');
}

function arrayOfDaysFromNow(amountOfDays) {
  return arrayOfTimeFromNow(amountOfDays, 'days')
}


function arrayOfMonthsFromNow(amountOfMonths) {
  return arrayOfTimeFromNow(amountOfMonths, 'months')
}


function arrayOfTimeFromNow(amount, timeunit) {
  var resultArr = [];
  for (var i = 0; i <= amount-1; i++) {
    resultArr[i] = moment().subtract(i, timeunit);
  }
  return resultArr.reverse();
}

function url() {
  var prefix = $('#thingname').attr('data-thing-id');
  var url = 'statistic.json';
  return prefix + '/' + url;
}


function getBaseColorFromUsername(username) {
  var colorArr = [];
  var numberOfParts = 3
  var parts = splitStringInParts(username, numberOfParts);
  for (i = 0; i < numberOfParts; i++) {
    colorArr[i] = (210 - (255 % (getNonVowelCount(parts[i])) * 30));
  }
  return colorArr;
}


function getColorFromUsername(username, alpha) {
  var colorArr = getBaseColorFromUsername(username)
  return "rgba(" + colorArr + ',' + alpha + ')';
}


function getNonVowelCount(string) {
  return string.match(/[^aeiouAEIOU@\.02468]/gi).length
}


function splitStringInParts(string, parts) {
  var n = Math.round(string.length / parts);
  var regex = new RegExp('.{1,' + n + '}', 'g');
  return string.match(regex);
}