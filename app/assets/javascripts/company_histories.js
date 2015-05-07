$(function() {
  $(document).on('change', '#company_histories_list', function() {

    displayCompanyHistoriesData()

  });
});


function displayCompanyHistoriesData() {
  var selected_pos = $("#company_histories_list :selected");

  if ( selected_pos.attr('short') ) 
  	{ document.getElementById("history[short]").textContent = selected_pos.attr('short') }
  else { document.getElementById("history[short]").textContent = " " };

  if ( selected_pos.attr('name') ) 
  	{ document.getElementById("history[name]").textContent = selected_pos.attr('name') }
  else { document.getElementById("history[name]").textContent = " " };

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

  if ( selected_pos.attr('phone') ) 
  	{ document.getElementById("history[phone]").textContent = selected_pos.attr('phone') }
  else { document.getElementById("history[phone]").textContent = " " };

  if ( selected_pos.attr('email') ) 
  	{ document.getElementById("history[email]").textContent = selected_pos.attr('email') }
  else { document.getElementById("history[email]").textContent = " " };

  if ( selected_pos.attr('nip') ) 
  	{ document.getElementById("history[nip]").textContent = selected_pos.attr('nip') }
  else { document.getElementById("history[nip]").textContent = " " };

  if ( selected_pos.attr('regon') ) 
  	{ document.getElementById("history[regon]").textContent = selected_pos.attr('regon') }
  else { document.getElementById("history[regon]").textContent = " " };

  if ( selected_pos.attr('pesel') ) 
  	{ document.getElementById("history[pesel]").textContent = selected_pos.attr('pesel') }
  else { document.getElementById("history[pesel]").textContent = " " };

  if ( selected_pos.attr('informal_group') ) 
  	{ document.getElementById("history[informal_group]").textContent = selected_pos.attr('informal_group') }
  else { document.getElementById("history[informal_group]").textContent = " " };

  if ( selected_pos.attr('note') ) 
  	{ document.getElementById("history[note]").textContent = selected_pos.attr('note') }
  else { document.getElementById("history[note]").textContent = " " };


}