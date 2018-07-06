/**
 * 
 */

onmessage = function(e) {
  
  var t = Date.now();
  
  function sleep(d){
  	while(Date.now - t <= d);
  } 

	$(function(){
		(function longPolling(){
			$.ajax({
				url: 'getMessage.action',
				type: 'GET',
				dataType: '',
				timeout: 5000,
			
			success:function(data,textStatus) {
				sleep(2000)
				if (textStatus == "success") { // 请求成功
								postMessage(data)
								console.info("success")
                              longPolling();
                          }
			},
			error:function(XMLHttpRequest,textStatus,errorThrown) {
				if(textStatus == "timeout"){
					
					console.info("timeout")
					longPolling();
				}else{
					
					console.info(textStatus)
					longPolling();
				}
			}
		});
			
		})();
	});
}