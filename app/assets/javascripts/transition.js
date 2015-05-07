$(document).ready(function(){ // standardowy początek
  $('body').css("display","none"); // sprawiamy, że cała sekcja body nie jest wyświetlana od razu po załadowaniu się strony
  $('body').fadeIn(300); // całą sekcja body pojawia się płynnie na ekranie za pomocą efektu fadeIn w czasie 500ms (0.5 sekundy)
  // powyższy kod wykona się przy każdym wczytywaniu strony
  $('a.transition').click(function(event){ // akcja jaka wykona się po kliknięciu na link posiadający klasę transition
      event.preventDefault(); // dzięki tej linijce wstrzymujemy domyślną akcje jaką jest zwykłe przekierowanie na kolejną podstronę
      adres = this.href; // zmienna adres przyjmuje adres URL z klikniętego linku
      $('body').fadeOut(300, przekierowanieStrony); 
                /* następuje płynne zanikanie tła za pomocą efektu fadeOut.
                Efekt ten wykonywany jest również w czasie 500ms,
                a po jego zakończeniu wywoływana jest funkcja przekierowania.*/    
    });
  function przekierowanieStrony() { // funkcja przekierowania
    window.location = adres; // dzięki tej linijce zostajemy przeniesieni na nową podstronę
  }
});