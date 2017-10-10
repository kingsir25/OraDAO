package com.db.oradao.controller;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

public interface Sql_tblRepository extends JpaRepository<Sql_tbl, Integer> {
	
	//Sql_tbl findBySql_id(Integer sql_id);
	//@Query(value = "select sql_id,sql from sql_tbl where callname=?1")
	//List<Sql_tbl> findByCallname(String callname);
	//List<Sql_tbl> deleteByCallname(String callname);
	//List<Sql_tbl> deleteBySql_idGreaterThan(Integer sql_id);

}
