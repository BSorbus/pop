$(function() {
  $(document).on('change', '#insurance_histories_list', function() {

    displayInsuranceHistoriesData()

  });
});


function displayInsuranceHistoriesData() {
  var selected_pos = $("#insurance_histories_list :selected");

  if ( selected_pos.attr('number') ) 
  	{ document.getElementById("history[number]").textContent = selected_pos.attr('number') }
  else { document.getElementById("history[number]").textContent = " " };



  if ( selected_pos.attr('concluded') ) 
  	{ document.getElementById("history[concluded]").textContent = selected_pos.attr('concluded') }
  else { document.getElementById("history[concluded]").textContent = " " };

  if ( selected_pos.attr('valid_from') ) 
  	{ document.getElementById("history[valid_from]").textContent = selected_pos.attr('valid_from') }
  else { document.getElementById("history[valid_from]").textContent = " " };

  if ( selected_pos.attr('applies_to') ) 
  	{ document.getElementById("history[applies_to]").textContent = selected_pos.attr('applies_to') }
  else { document.getElementById("history[applies_to]").textContent = " " };




  if ( selected_pos.attr('note') ) 
  	{ document.getElementById("history[note]").textContent = selected_pos.attr('note') }
  else { document.getElementById("history[note]").textContent = " " };


}