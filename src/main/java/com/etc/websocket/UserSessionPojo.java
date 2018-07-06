package com.etc.websocket;

import javax.websocket.Session;

public class UserSessionPojo {

	private String user;
	private String msg;
	public UserSessionPojo(String user, String msg) {
		super();
		this.user = user;
		this.msg = msg;
	}
	public String getMsg() {
		return msg;
	}
	public void setMsg(String msg) {
		this.msg = msg;
	}
	public String getUser() {
		return user;
	}
	public void setUser(String user) {
		this.user = user;
	}
	
}
