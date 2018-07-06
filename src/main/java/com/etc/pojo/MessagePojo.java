package com.etc.pojo;

public class MessagePojo {

	private String from;
	private String msg;
	private String time;
	public String getFrom() {
		return from;
	}
	public void setFrom(String from) {
		this.from = from;
	}
	public String getMsg() {
		return msg;
	}
	public void setMsg(String msg) {
		this.msg = msg;
	}
	public String getTime() {
		return time;
	}
	public void setTime(String time) {
		this.time = time;
	}
	public MessagePojo(String from, String msg, String time) {
		super();
		this.from = from;
		this.msg = msg;
		this.time = time;
	}
	
}
