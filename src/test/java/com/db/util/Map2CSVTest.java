package com.db.util;

import java.util.*; 

import static org.junit.Assert.*;

import com.db.util.Map2CSV;

import org.junit.Test;

public class Map2CSVTest {

	@Test
	public void test() {
		List<Map<String, Object>> list1 = new ArrayList<>();
		
		for(int i=0;i<5;i++){
		Map<String, Object> map = new HashMap();
		map.put("id", "0"+i);
		map.put("name", "wangjian" + i);
		list1.add(map);
		}
		String result =Map2CSV.transformat(list1);
		System.out.print(result);
		assertNotNull(result);
	}

}
