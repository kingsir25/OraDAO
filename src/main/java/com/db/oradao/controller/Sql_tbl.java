package com.db.oradao.controller;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

import org.hibernate.validator.constraints.NotBlank;


@Entity
public class Sql_tbl {

    @Id
    @GeneratedValue
    @Column(name="sql_id")        
    private Integer id;
    
	@NotBlank(message ="name not is blank")
    private String sql;

    private String addition;
    
    private String para;
    
    private String callname;
	
    private String url;
    
    private String description;
    
    private String resulttype;
    
    private String commets;
    
    public Sql_tbl(){}
    
    public Integer getId() {
		return id;
	}

	public void setIid(Integer id) {
		this.id = id;
	}

	public String getSql() {
		return sql;
	}

	public void setSql(String sql) {
		this.sql = sql;
	}

	public String getAddition() {
		return addition;
	}

	public void setAddition(String addition) {
		this.addition = addition;
	}

	public String getPara() {
		return para;
	}

	public void setPara(String para) {
		this.para = para;
	}

	public String getCallname() {
		return callname;
	}

	public void setCallname(String callname) {
		this.callname = callname;
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getResulttype() {
		return resulttype;
	}

	public void setResulttype(String resulttype) {
		this.resulttype = resulttype;
	}

	public String getCommets() {
		return commets;
	}

	public void setCommets(String commets) {
		this.commets = commets;
	}



}
