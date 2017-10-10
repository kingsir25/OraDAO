package com.db.util;

import static org.junit.Assert.*;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import org.junit.Test;

public class DBConnectionPoolTest {

	Connection connection = null;
	/**
	 * 测试DB连接
	 * @throws SQLException
	 */
	@Test
	public void getConnectionTest() throws SQLException {
		/**从数据库连接池中获取数据库连接**/ 
        connection = DBConnectionPool.getInstance().getConnection(); 
        assertNotNull(connection);
	}
	
    /** 
     * 测试插入 
     */
	@Test
	public void testInsert() { 
        Map<String, Object> map = new HashMap<>(); 
        map.put("id", 20); 
        map.put("name", "JDBCUtil测试"); 
        map.put("sex", "male"); 
        map.put("role", "SSE"); 
        map.put("comedate", 20170901); 
        try { 
            assertEquals(1,DBUtil.insert("resources", map));
        } catch (SQLException e) { 
            e.printStackTrace(); 
        } 
    } 

}
