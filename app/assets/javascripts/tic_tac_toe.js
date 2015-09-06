$(document).ready(function(){
	$(".item").click(function(){
		var val = $(this).attr('id').slice(4);
		$.ajax({
				url: "/play", 
				type: 'GET',
				data : {cell : val },
				success: function(result){
					// if(result["continue"] == "Y"){
						$("#item"+val).text(result["marker"])
					// }
					if(result["continue"] == "N"){
						$("#winner_name").text(result["winner"].name);
					}
					console.log(result);
	    		}
    	});
	})
})
