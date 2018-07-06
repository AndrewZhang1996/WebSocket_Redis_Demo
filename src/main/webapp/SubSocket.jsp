<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="css/bootstrap.min.css" />
<script src="js/vue.js"></script>
<script src="js/jquery-1.10.1.js"></script>
<script src="js/bootstrap.min.js"></script>
<script>
function getQueryString(name) {
    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
    var r = window.location.search.substr(1).match(reg);
    if (r != null) return unescape(r[2]); return null;
}
$(document).ready(function(){

    var websocket;
    var username = getQueryString("uname");


    // 首先判断是否 支持 WebSocket
    if('WebSocket' in window) {
        websocket = new WebSocket("ws://localhost:8080/redis_4/websocket/" + username);
    } else if('MozWebSocket' in window) {
        websocket = new MozWebSocket("ws://localhost:8080/redis_4/websocket/" + username);
    } else {
        websocket = new SockJS("http://localhost:8080/redis_4/sockjs/websocket/" + username);
    }

    // 打开时
    websocket.onopen = function(evnt) {
        console.log("  websocket.onopen  ");
    };


    // 处理消息时
    websocket.onmessage = function(evnt) {
        $("#msg").append("<p><font color='red'>" + evnt.data + "</font></p>");
        console.log("  websocket.onmessage   ");
    };


    websocket.onerror = function(evnt) {
        console.log("  websocket.onerror  ");
    };

    websocket.onclose = function(evnt) {
        console.log("  websocket.onclose  ");
    };


    // 点击了发送消息按钮的响应事件
    $("#TXBTN").click(function(){

        // 获取消息内容
        var text = $("#tx").val();
        var from = username;
        var to = $("#to").val();

        // 判断
        if(text == null || text == ""||to == null){
            alert(" content  can not empty!!");
            return false;
        }

        var msg = {
            msgContent: text,
            toWho: to,
            fromWho: from,
            time: new Date().toLocaleString()
        };
        
        $("#tx").val('');
        $("#to").val('');

        // 发送消息
        websocket.send(JSON.stringify(msg));
        
        
    });


});
</script>
</head>
<body>
<div class="container-fluid">
<div style="width: 150px;margin: 0px auto" display=inline>
        <form class="form-horizontal">
			<div class="form-group">
            	<label for="msg"></label>
            	<div style="height: 200px" name="msg" id="msg" class="form-control" ></div>
        	</div>
        	<div class="form-group">
            	<label for="tx">发送的消息：</label>
            	<textarea name="tx" id="tx" class="form-control" ></textarea>
        	</div>
        	<div class="form-group">
            	<label for="to">发给：</label>
            	<input type="text" name="to" id="to" class="form-control" ></input>
        	</div>
        	<a class="btn btn-primary" id="TXBTN" >发送数据</a>

        </form>
        </div>
        <br />
        <br />
        <br />
        <div id="allMessage" style="width: 250px;margin: 0px auto">
        <button id="showAllMessage" @click="showAllMessage">显示所有信息</button>
        <table class="table table-bordered">
        	<tr>
        		<th>来自</th>
        		<th>信息</th>
        		<th>时间</th>
        		<th>标记为已读</th>
        	</tr>
        	<tr v-for="item in mlist">
        		<td>{{item.from}}</td>
        		<td>{{item.msg}}</td>
        		<td>{{item.time}}</td>
        		<td style="text-align:center">
							<div class="btn-group btn-xs">
								<button type="button" class="btn btn-default btn-xs dropdown-toggle" id="dropdownMenu" data-toggle="dropdown">
									操作
									<span class="caret"></span>
								</button>
								<ul class="dropdown-menu">
									<li>
										<a @click="hasRead(item,$event)">已读
										</a>
									</li>
								</ul>
							</div>
				</td>
        	</tr>
        </table>
        </div>
        </div>
        <script>
        $(document).ready(function(){
        	var username = getQueryString("uname");
        	var allMessage = new Vue({
        		el:"#allMessage",
        		data:{
        			mlist:[]
        		},
        		methods:{
        			
        			showAllMessage:function(){
        				var that = this;
        				$.ajax({
                        	url:'getAllMessage.action',
                            type:'get',
                            data:{
                            	"userName": username
                            },
                            dataType:'json',
                            async:false,
                            success:function(data){
                                    // data就是response的 字符串数据： json
                                that.mlist = data;
                            },
                            error:function(){
                                alert("服务器有问题")
                            }
                        });
        			},
        			hasRead:function(item,event){
        				var hasReadMsg = JSON.stringify(item)
        				console.log(typeof hasReadMsg)
        				console.log(hasReadMsg)
						$.ajax({
							url:'hasRead.action',
							type:'get',
							data:{
								"hasReadMsg":hasReadMsg,
								"username":username
							},
                            success:function(){
                                    // data就是response的 字符串数据： json
                                    console.log("移入已读信箱")
                                    window.location.reload()
                            },
                            error:function(){
                                alert("服务器有问题")
                            }
						})
        			}
        		}
        	})
        	
        })
        </script>
       
</body>
</html>