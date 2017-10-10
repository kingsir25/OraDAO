package com.db.util;

import java.util.*; 
/**
 * Map 转 CSV处理
 * 修正履历
 * 20170925 bug fix 1件不输出
 * @author jake.jian.wang
 *
 */
public class Map2CSV {

public static String transformat(List<Map<String, Object>> input)
{
	String outStr = "";

	Map<String, Object> headmap = input.get(0);
	
	for (String key : headmap.keySet()) {  
		outStr = outStr + "\"" +key +"\"" + ",";
	}
	//去掉末尾","
	//if (outStr.substring(outStr.length()-2,1).compareTo(",")==0){
	 outStr = outStr.substring(0,outStr.length()-1) + "\n";
	//}
	for(int i=0;i<input.size();i++){
		Map<String, Object> bodymap = input.get(i);
		for (Object value : bodymap.values()) {  
			outStr = outStr + "\"" + value +"\"" + ",";   
	     }  
	//去掉末尾","	
	//   if (outStr.substring(outStr.length()-1,outStr.length()).compareTo(",")==0){
		outStr = outStr.substring(0,outStr.length()-1) + "\n";
	//   }
	}
	return outStr;
 }
}
