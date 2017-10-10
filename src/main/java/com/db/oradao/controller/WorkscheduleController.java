package com.db.oradao.controller;

import java.util.List;

import javax.transaction.Transactional;


import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.transaction.annotation.Propagation;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.db.oradao.controller.tables.*;

@RestController
//@Transactional
public class WorkscheduleController {

	@Autowired
	private WorkscheduleRepository workscheduleRepository;	
	
//	//删除 **Getmaping
//    @GetMapping(value="/workschedule/delete/workdate/gt/{workdate}")  
//    public int workschedule(@PathVariable("workdate")String workdate){  
//    	return workscheduleRepository.deleteByWorkdateGreaterThan(workdate);  
//    }
    
	//删除workdate>=xxxxxx **Getmaping 
    @GetMapping(value="/workschedule/delete/workdate/ge/{workdate}")  
    public int deleteByGetNativeQuery(@PathVariable("workdate")String workdate){  
    	return workscheduleRepository.deleteByNativeQuery(workdate);  
    }
    
    //删除workdate>=xxxxxx **PostMapping 
    @PostMapping(value="/workschedule/delete/workdate/ge/{workdate}")  
    public int deleteByPostNativeQuery(@PathVariable("workdate")String workdate){  
    	return workscheduleRepository.deleteByNativeQuery(workdate);  
    }
    
	//查询workdate>=xxxxxx **Getmaping
    @GetMapping(value="/workschedule/query/workdate/ge/{workdate}")  
    public List<Workschedule> queryByNativeQuery(@PathVariable("workdate")String workdate){  
    	return workscheduleRepository.queryByNativeQuery(workdate);  
    } 
//    
//    //删除 **@PostMapping
//    @PostMapping(value="/workschedule/delete/workdate/gt")  
//    public int deleteByComedateGT(@RequestParam("workdate") String workdate){  
//    	return workscheduleRepository.deleteByWorkdateGreaterThan(workdate);  
//    }
    
    /**通过JSON数据  添加多个resource*/  
    //@Transactional(propagation=Propagation.NOT_SUPPORTED)
    @PostMapping(value="/workschedule/adds")  
    public int bodyAdds(@RequestBody List<Workschedule> res){
    	workscheduleRepository.save(res); 
//    	int i =0;
//    	for(;i< res.size();i++){
//    		Workschedule resone = new Workschedule();
//        	resone.setName(res.get(i).getName());
//        	resone.setTeam(res.get(i).getTeam());
//        	resone.setWorkdate(res.get(i).getWorkdate());
//        	resone.setWorkhours(res.get(i).getWorkhours());
//        	resone.setType(res.get(i).getType());
//        	workscheduleRepository.save(resone); 
//    	}
    	System.out.print("插" + res.size() + "件 ");
    	return res.size();
    } 
    /**通过参数 添加一个resource*/  
    @PostMapping(value="/workschedule/add")  
    public Workschedule paramAdd(@RequestParam("name") String name,
    		                 @RequestParam("team") String team,
    		                 @RequestParam("workdate") String workdate,
    		                 @RequestParam("workhours") Integer workhours,
                             @RequestParam("type") String type){  
    	
    	Workschedule resone=new Workschedule();  
    	resone.setName(name);
    	resone.setTeam(team);
    	resone.setWorkdate(workdate);
    	resone.setWorkhours(workhours);
    	resone.setType(type);
        return workscheduleRepository.save(resone);  
    } 
    
	
}
