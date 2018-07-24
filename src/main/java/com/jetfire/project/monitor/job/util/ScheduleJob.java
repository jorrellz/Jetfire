package com.jetfire.project.monitor.job.util;

import java.util.Date;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.quartz.QuartzJobBean;
import com.jetfire.common.constant.Constants;
import com.jetfire.common.constant.ScheduleConstants;
import com.jetfire.common.utils.bean.BeanUtils;
import com.jetfire.common.utils.spring.SpringUtils;
import com.jetfire.project.monitor.job.domain.Job;
import com.jetfire.project.monitor.job.domain.JobLog;
import com.jetfire.project.monitor.job.service.IJobLogService;

/**
 * 定时任务
 * 
 * @author jetfire
 *
 */
public class ScheduleJob extends QuartzJobBean
{
    private static final Logger log = LoggerFactory.getLogger(ScheduleJob.class);

    private ExecutorService service = Executors.newSingleThreadExecutor();

    @Override
    protected void executeInternal(JobExecutionContext context) throws JobExecutionException
    {
        Job job = new Job();
        BeanUtils.copyBeanProp(job, context.getMergedJobDataMap().get(ScheduleConstants.TASK_PROPERTIES));

        IJobLogService jobLogService = (IJobLogService) SpringUtils.getBean(IJobLogService.class);

        JobLog jobLog = new JobLog();
        jobLog.setJobName(job.getJobName());
        jobLog.setJobGroup(job.getJobGroup());
        jobLog.setMethodName(job.getMethodName());
        jobLog.setMethodParams(job.getMethodParams());
        jobLog.setCreateTime(new Date());

        long startTime = System.currentTimeMillis();

        try
        {
            // 执行任务
            log.info("任务开始执行 - 名称：{} 方法：{}", job.getJobName(), job.getMethodName());
            ScheduleRunnable task = new ScheduleRunnable(job.getJobName(), job.getMethodName(), job.getMethodParams());
            Future<?> future = service.submit(task);
            future.get();
            long times = System.currentTimeMillis() - startTime;
            // 任务状态 0：成功 1：失败
            jobLog.setStatus(Constants.SUCCESS);
            jobLog.setJobMessage(job.getJobName() + " 总共耗时：" + times + "毫秒");

            log.info("任务执行结束 - 名称：{} 耗时：{} 毫秒", job.getJobName(), times);
        }
        catch (Exception e)
        {
            log.info("任务执行失败 - 名称：{} 方法：{}", job.getJobName(), job.getMethodName());
            log.error("任务执行异常  - ：", e);
            long times = System.currentTimeMillis() - startTime;
            jobLog.setJobMessage(job.getJobName() + " 总共耗时：" + times + "毫秒");
            // 任务状态 0：成功 1：失败
            jobLog.setStatus(Constants.FAIL);
            jobLog.setExceptionInfo(e.toString());
        }
        finally
        {
            jobLogService.addJobLog(jobLog);
        }
    }
}
