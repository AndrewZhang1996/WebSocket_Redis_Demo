package com.etc.controller.message;

import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSONObject;
import com.etc.pojo.MessagePojo;

import redis.clients.jedis.Jedis;

@Controller
public class UserController {

	
	Logger logger = Logger.getLogger(UserController.class);
	

	
	@RequestMapping("getAllMessage.action")
	@ResponseBody
	public List<MessagePojo> getAllMessage(@RequestParam("userName") String uname){
		
		Jedis jedis = new Jedis();
		List<String> allMsgJson = new ArrayList<String>();
		List<MessagePojo> result = new ArrayList<MessagePojo>();
		logger.info("用户" + uname + "开始redis查询所有信息");
		Long length = jedis.llen(uname);
		logger.info("一共有" + length + "条信息");
		
		for(int i = 0;i<length;i++) {
			String singleMsg = jedis.lindex(uname, i);
			if(singleMsg != "nil") {
				allMsgJson.add(singleMsg);
			}else {
				break;
			}
		}
		for(String msg:allMsgJson) {
			JSONObject msgJson = JSONObject.parseObject(msg);
			MessagePojo sMsg = new MessagePojo(msgJson.getString("fromWho"), msgJson.getString("msgContent"), msgJson.getString("time"));
			result.add(sMsg);
		}
		
		return result;
	}
	
	@RequestMapping("hasRead.action")
	@ResponseBody
	public Integer hasReadMessage(@RequestParam("hasReadMsg") String msg, @RequestParam("username") String uname) {
		JSONObject jsonMsg = JSONObject.parseObject(msg);
		String time = jsonMsg.getString("time");
		String readMsg = jsonMsg.getString("msg");
		logger.info(msg);
		Jedis jedis = new Jedis();
		Long length = jedis.llen(uname);
		logger.info("一共有" + length + "条信息");
		
		for(int i = 0;i<length;i++) {
			String singleMsg = jedis.lindex(uname, i);
			JSONObject jsonSingleMsg = JSONObject.parseObject(singleMsg);
			logger.info(singleMsg);
			if(singleMsg != "nil" &&  jsonSingleMsg.getString("time").equals(time) && jsonSingleMsg.getString("msgContent").equals(readMsg)){
				jedis.lrem(uname, 1, singleMsg);
				return 1;
			}else if(singleMsg == "nil"){
				break;
			}
		}
		
		return 0;
	}
	
}
