package com.db.oradao.controller.tables;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;


public interface WorkscheduleRepository extends JpaRepository<Workschedule, Integer> {
	
	public List<Workschedule> findByWorkdateGreaterThan(String workdate);
	public List<Workschedule> findByNameAndWorkdate(String name,String workdate);
	public int deleteByWorkdateGreaterThan(String workdate);
	
	@Query(value = "select name,team,workdate,workhours,type from workschedule t where t.workdate> =?1" , nativeQuery = true)
	List<Workschedule> queryByNativeQuery(String workdate);
	
	@Modifying
	@Query(value = "delete workschedule t where t.workdate>=?1" , nativeQuery = true)
	int deleteByNativeQuery(String workdate);
	
	@Query(value = "select name,team,workdate,workhours,type from workschedule t where t.name=?1 and t.workdate=?2 and t.team =?3 and t.type> =?4 and t.workhours > 0" , nativeQuery = true)
	List<Workschedule> queryWorkhours(String name,String workdate,String team,String type);
}
