$(document).ready(function(){
	
            var getAllUserWorkInfo = new Vue({
                el: "#getAllUserWorkInfo",
                data:{
                    userlist:[]
                }

            });

			$.get('getAllUser.action', null, function(data){
                // data就是response的 字符串数据： json
                getAllUserWorkInfo.userlist = data;
            }, "json");

        });