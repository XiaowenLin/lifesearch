var SprintIndexCounter = {
  // find all relevant cell not hiden rows
  select_tr: function(nth) {
    var res = $("tr:not(#sprints_total) td:nth-child(" + nth + ")").filter(':visible');
    return(res);
  },
  // get sum
  sum_up: function(nth) {
    var sum = 0;
    var arr = SprintIndexCounter.select_tr(nth);
    arr.each(function() {
      var value = parseFloat(jQuery.text($(this)));
      if (!isNaN(value)) {
        sum += value;
      };
    });
    return(sum);
  }
};
$(document).ready(function(){
  var total_hours = SprintIndexCounter.sum_up(6);
  $("#total_hours").html(total_hours);
  var total_happy_hours = SprintIndexCounter.sum_up(7);
  $("#total_happy_hours").html(total_happy_hours);
});
