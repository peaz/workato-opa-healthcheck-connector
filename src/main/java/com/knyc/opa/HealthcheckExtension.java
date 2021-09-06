/*
 * Copyright (c) 2018 Ken Ng, Inc. All rights reserved.
 */

package com.knyc.opa;

import org.apache.commons.codec.binary.Hex;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.inject.Inject;
import java.util.Collection;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.time.LocalDateTime;

import java.lang.management.ManagementFactory;
import java.lang.management.ThreadMXBean;
import java.lang.management.ThreadInfo;
import java.lang.Thread.State;

@Controller
public class HealthcheckExtension {

    @Inject
    private Environment env;

    @RequestMapping(path = "/ping", method = RequestMethod.GET)
    public @ResponseBody Map<String, Object> ping() throws Exception {
        Map<String, Object> responseData = new HashMap<String, Object>();
        responseData.put("message", "pong");
        responseData.put("currentTime", String.valueOf(java.time.LocalDateTime.now()));
        return responseData;        
    }

    @RequestMapping(path = "/memory", method = RequestMethod.GET)
    public @ResponseBody Map<String, Object> getMemory() throws Exception {
        Map<String, Object> responseData = new HashMap<String, Object>();
        int mb = 1024*1024;

		//Getting the runtime reference from system
		Runtime runtime = Runtime.getRuntime();
        Long usedMemory = (runtime.totalMemory() - runtime.freeMemory()) / mb;
        Long freeMemory = runtime.freeMemory() / mb;
        Long totalMemory = runtime.totalMemory() / mb;
        Long maxMemory = runtime.maxMemory() / mb;

        responseData.put("usedMemory", usedMemory);
        responseData.put("freeMemory", freeMemory);
        responseData.put("totalMemory", totalMemory);
        responseData.put("maxMemory", maxMemory);
        return responseData;        
    }

    @RequestMapping(path = "/threads", method = RequestMethod.GET)
    public @ResponseBody Map<String, Object> getThreads() throws Exception {
        Map<String, Object> responseData = new HashMap<String, Object>();
        
        Collection<Map<String, Object>> threadInfoList = new HashSet<Map<String, Object>>();
        ThreadMXBean threadMXBean = ManagementFactory.getThreadMXBean();
        for(Long threadID : threadMXBean.getAllThreadIds()) {
            Map<String, Object> threadInfo = new HashMap<String, Object>();

            ThreadInfo info = threadMXBean.getThreadInfo(threadID);
            String threadName = info.getThreadName();
            String threadState = String.valueOf(info.getThreadState());
            Long cpuTime = threadMXBean.getThreadCpuTime(threadID);
            threadInfo.put("threadID", threadID);
            threadInfo.put("threadName", threadName);
            threadInfo.put("threadState", threadState);
            threadInfo.put("cpuTime", cpuTime);   
            threadInfoList.add(threadInfo);
          }
          System.out.print(String.valueOf(responseData));

          responseData.put("threadInfoList", threadInfoList);
          return responseData;        
    }
}
