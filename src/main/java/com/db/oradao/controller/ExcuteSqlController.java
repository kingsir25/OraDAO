package com.db.oradao.controller;


import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.db.util.DBUtil;
import com.db.util.Map2CSV;

@RestController
@RequestMapping("/db")
public class ExcuteSqlController {
  
	/**
	 * RESTful Web DB API
	 * @param jake
	 * @return
	 */
	@Autowired
	private Sql_tblRepository sql_tblRepository;
	
    @GetMapping(value = "/say")
    public String say(@RequestParam(value = "id", required = false, defaultValue = "0") Integer myId) {
        return "{\"id\": " + myId+"}";
    }
    /**
     * 同过sqlid来取出对应sql，然后提交DB执行，再把执行结果返回
     * @param sql_id
     * @return
     */
    @GetMapping(value = "/get")
    public String get(@RequestParam(value = "sql_id", required = false, defaultValue = "1") Integer sql_id) {
    	String sql = sql_tblRepository.findOne(sql_id).getSql();
    	System.out.println("{\"url\":\"/git?sql_id=" + sql_id + "\",\"sql\":" + sql +"\"}");
    	
      if (sql =="") { 
        	return "{\"msg\":、\"slq_id =" + sql_id + " sql is not exsit in TABLE（sql_tab）\"}";
        	}
      else{
    	try {
 		   List<Map<String, Object>> rsList = DBUtil.query(sql); 
 		   List<JSONObject> returnList = new ArrayList<JSONObject>();
 				for(int i=0;i<rsList.size();i++){
 					JSONObject jsonObject = new JSONObject(rsList.get(i));
 					returnList.add(jsonObject);
 				}
 		  JSONArray jsonArray = new JSONArray(returnList);
			return jsonArray.toString();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return e.toString();
		}
      }
    	
    }
	@GetMapping(value = "/query")
    public String query(@RequestParam(value = "sql", required = true) String sql,
    		@RequestParam(value = "form", required = false, defaultValue = "json") String form) 
	{
    	System.out.println("{\"url\":\"/select\",\"sql\":" + sql +"\"}");
    	try {  
    		   List<JSONObject> returnList = new ArrayList<JSONObject>();
    		   List<Map<String, Object>> rsList = DBUtil.query(sql); 
    		   if (("csv".compareTo(form))==0){
    			   //csv格式
    			   return "<pre>" + Map2CSV.transformat(rsList)+"</pre>";
    		   }else{
    			 //默认json格式
    				for(int i=0;i<rsList.size();i++){
    					JSONObject jsonObject = new JSONObject(rsList.get(i));
    					returnList.add(jsonObject);
    				}
    				JSONArray jsonArray = new JSONArray(returnList);
    				return jsonArray.toString();
    	       }
    		  
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return e.toString();
		}
    }	
    
    @PostMapping(value = "/insert")
    public String insert(@RequestBody String sql) {
    	System.out.println("{\"url\":\"/insert\",\"sql\":" + sql +"\"}");
    	try {
    		   int count = DBUtil.executeUpdate(sql,null); 
			return ""+ count;
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return e.toString();
		}
    }
    
    @DeleteMapping(value = "/delete")
    public String delete(@RequestBody String sql) {
    	System.out.println("{\"url\":\"/insert\",\"sql\":" + sql +"\"}");
    	try {
    		   int count = DBUtil.executeUpdate(sql,null); 
			return ""+ count;
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return e.toString();
		}
    }
    
    @PutMapping(value = "/update")
    public String update(@RequestBody String sql) {
    	System.out.println("{\"url\":\"/insert\",\"sql\":" + sql +"\"}");
    	try {
    		   int count = DBUtil.executeUpdate(sql,null); 
			return ""+ count;
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return e.toString();
		}
    }
    
}