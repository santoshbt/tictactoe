$(document).ready(function(){
	$(".item").click(function(){
		if($(this).text() == ""){
			var val = $(this).attr('id').slice(4);
			$.ajax({
					url: "/play", 
					type: 'GET',
					data : {cell : val },
					success: function(result){
						console.log(result);
						$("#item"+val).text(result["marker"]);
						$(".whosenext").text("Next is "+result["other_pl"]);
						if(result["continue"] == "N" && result["error"] == null ){
							$(".whosenext").hide();
							$(".iwon").text("Congratulations, " + result["name"] + " is the Winner..!!!" );
						}
						if(result["error"] == "Draw"){
							$(".whosenext").hide();
							$(".iwon").css("margin-left", "46%");
							$(".iwon").text("This is a draw..!!!" );
						}
		    		}
	    	});
		}
	});
	
	$("#reset").click(function(){
		$(".item").text("");
	})
})
