$(function() {
  $(document).on('change', '#individual_histories_list', function() {

    displayIndividualHistoriesData()

  });
});


function displayIndividualHistoriesData() {
  var selected_pos = $("#individual_histories_list :selected");

  if ( selected_pos.attr('last_name') ) 
  	{ document.getElementById("history[last_name]").textContent = selected_pos.attr('last_name') }
  else { document.getElementById("history[last_name]").textContent = " " };

  if ( selected_pos.attr('first_name') ) 
  	{ document.getElementById("history[first_name]").textContent = selected_pos.attr('first_name') }
  else { document.getElementById("history[first_name]").textContent = " " };

  if ( selected_pos.attr('address_city') ) 
  	{ document.getElementById("history[address_city]").textContent = selected_pos.attr('address_city') }
  else { document.getElementById("history[address_city]").textContent = " " };

  if ( selected_pos.attr('address_street') ) 
  	{ document.getElementById("history[address_street]").textContent = selected_pos.attr('address_street') }
  else { document.getElementById("history[address_street]").textContent = " " };

  if ( selected_pos.attr('address_house') ) 
  	{ document.getElementById("history[address_house]").textContent = selected_pos.attr('address_house') }
  else { document.getElementById("history[address_house]").textContent = " " };

  if ( selected_pos.attr('address_number') ) 
  	{ document.getElementById("history[address_number]").textContent = selected_pos.attr('address_number') }
  else { document.getElementById("history[address_number]").textContent = " " };

  if ( selected_pos.attr('address_postal_code') ) 
  	{ document.getElementById("history[address_postal_code]").textContent = selected_pos.attr('address_postal_code') }
  else { document.getElementById("history[address_postal_code]").textContent = " " };

  if ( selected_pos.attr('birth_date') ) 
  	{ document.getElementById("history[birth_date]").textContent = selected_pos.attr('birth_date') }
  else { document.getElementById("history[birth_date]").textContent = " " };

  if ( selected_pos.attr('pesel') ) 
  	{ document.getElementById("history[pesel]").textContent = selected_pos.attr('pesel') }
  else { document.getElementById("history[pesel]").textContent = " " };

  if ( selected_pos.attr('profession') ) 
  	{ document.getElementById("history[profession]").textContent = selected_pos.attr('profession') }
  else { document.getElementById("history[profession]").textContent = " " };

  if ( selected_pos.attr('note') ) 
  	{ document.getElementById("history[note]").textContent = selected_pos.attr('note') }
  else { document.getElementById("history[note]").textContent = " " };


}