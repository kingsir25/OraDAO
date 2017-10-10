package com.db.oradao.controller.tables;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.IdClass;
import javax.persistence.Table;
//import javax.validation.constraints.Digits;
import javax.validation.constraints.Size;

import org.hibernate.validator.constraints.NotBlank;



@Table(name="workschedule")
@Entity
@IdClass(WorkschedulePK.class)
public class Workschedule {
	
	/**
	 * Table:workschedule
	 */
    @Id
	@NotBlank(message ="name not is blank")
	@Size(max=30)
    private String name;//eid
	
	@Size(max=10)
    private String team;
	
	@Id
	@NotBlank(message ="name not is blank")
	//@Digits(integer, fraction)
	@Size(max=8)
    private String workdate;
	
    private Integer workhours;
	
    @Size(max=1)
    private String type;
	
	public Workschedule(){}
	
	
	
	@Override
	public String toString() {
		return "Workschedule [name=" + name + ", team=" + team + ", workdate="
				+ workdate + ", workhours=" + workhours + ", type=" + type
				+ "]";
	}



	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getTeam() {
		return team;
	}

	public void setTeam(String team) {
		this.team = team;
	}

	public String getWorkdate() {
		return workdate;
	}

	public void setWorkdate(String workdate) {
		this.workdate = workdate;
	}

	public Integer getWorkhours() {
		return workhours;
	}

	public void setWorkhours(Integer workhours) {
		this.workhours = workhours;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}


    
    
	
}
