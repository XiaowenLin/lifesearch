var SprintIndexFilter = {
  setup: function() {
    // construct checkbox with label
    var labelAndCheckbox =
      $('<label for="filter">Today only</label>' +
        '<input type="checkbox" id="filter" checked/>' );
    labelAndCheckbox.insertBefore('#sprints');
    $('#filter').change(SprintIndexFilter.filter_other_day);
  },
  filter_other_day: function () {
    // 'this' is *unwrapped* element that received event (checkbox)
    if ($(this).is(':checked')) {
      $('tr.other_day').hide();
    } else {
      $('tr.other_day').show();
    };
  }
}
$(SprintIndexFilter.setup); // run setup function when document ready
$(document).ready(function() {
  $('tr.other_day').hide();
});
