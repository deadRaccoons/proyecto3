/* search for FLY */
var flySearch = flySearch || {


	/* parameters for the query */
	parameters : {
		seats : 1,
		// 0 for turist, 1 for first class
		seatsClass : 0,
		originIATA : null,
		destinyIATA : null,
		departureDate : null,
		returnDate : null,
	},

	apiURI : "/viajes",
	method: "get",

	/* request for a json response to the server */
	search: function (parameters) {

		var $extra = $("#actions");
		var	$trigger = $("#search");
		var $container = $("#flys");


		$.ajax({
			url: flySearch.apiURI,
			type: "GET",
			dataType: "json",
			beforeSend: function() {
				$extra.hide("slow");
				$container.show("slow")
			},
			success: function(json){
				var html  = flySearch._showResults(json);
				$("#flyss").html(html);
			},
			error: function(dato){

			}
		});
	},

	/* render the json data to the container */
	_showResults : function (json) {
		console.log(json);
		var html = "<ul id='flights-results'>";

		html += "<li id='results-header'><div class='pricing'>"
			+ "<strong>" + "Costo viaje" + "</strong></div>" 
			+ "<div class='class-details'>"
			+ "<strong> Clase </strong>"
			+ "</div>"
			+ "<div class='departure-on'>"
			+ "<strong>" + "Despega en " + "</strong></div>"
			+ "<div class='duration'>"
			+ "<strong>" + "Duración" + "</strong>"
			+"</div>"
			+"<div class='start'>Salida</div>"
			+"<div class='end'>Llegada</div>"
			+ "</li>"

		var moneda = "MXN"
		$.each(json, function(k, v) {
			html += "<li class='result'><div class='pricing'><span>" + moneda + " </span>"
			+ "<strong>" + v.costoviaje + "</strong></div>" 
			+ "<div class='class-details'>"
			+ "<strong> Turista </strong>"
			+ "<span> Pocos asientos disponibles </span>"
			+ "</div>"
			+ "<div class='departure-on'>"
			+ "<strong>" + "5n horas " + "</strong></div>"
			+ "<div class='duration'>"
			+ "<strong>" + v.tiempo + "</strong>"
			+"</div>"
			+"<div class='start'>11:00</div>"
			+"<div class='end'>18:45</div>"
			+ "</li>";
		});

		return html += "</ul>";
	}
};

$(function(){
	$("#search").on("click", function(e){
		flySearch.search();
	});

	$("#back-2-search").on("click", function(e){
		$("#flys").hide("slow");
		$("#actions").show();
	});
});