package com.db.oradao.controller.tables;

import java.io.Serializable;

public class WorkschedulePK implements Serializable {
	//private static final long serialVersionUID = -2432145316543676L;
	 public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getWorkdate() {
		return workdate;
	}
	public void setWorkdate(String workdate) {
		this.workdate = workdate;
	}
	
	 private String name;
	 private String workdate;
	 public WorkschedulePK(){}
}
