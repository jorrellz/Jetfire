package com.jetfire.project.monitor.job.domain;

import java.io.Serializable;

import com.jetfire.common.constant.ScheduleConstants;
import com.jetfire.framework.aspectj.lang.annotation.Excel;
import com.jetfire.framework.web.domain.BaseEntity;

/**
 * 定时任务调度信息 sys_job
 * 
 * @author jetfire
 */
public class Job extends BaseEntity implements Serializable
{
    private static final long serialVersionUID = 1L;

    /** 任务ID */
    @Excel(name = "任务序号")
    private Long jobId;

    /** 任务名称 */
    @Excel(name = "任务名称")
    private String jobName;

    /** 任务组名 */
    @Excel(name = "任务组名")
    private String jobGroup;

    /** 任务方法 */
    @Excel(name = "任务方法")
    private String methodName;

    /** 方法参数 */
    @Excel(name = "方法参数")
    private String methodParams;

    /** cron执行表达式 */
    @Excel(name = "执行表达式 ")
    private String cronExpression;

    /** cron计划策略 */
    @Excel(name = "计划策略 ")
    private String misfirePolicy = ScheduleConstants.MISFIRE_DEFAULT;

    /** 任务状态（0正常 1暂停） */
    @Excel(name = "任务状态")
    private String status;

    public Long getJobId()
    {
        return jobId;
    }

    public void setJobId(Long jobId)
    {
        this.jobId = jobId;
    }

    public String getJobName()
    {
        return jobName;
    }

    public void setJobName(String jobName)
    {
        this.jobName = jobName;
    }

    public String getJobGroup()
    {
        return jobGroup;
    }

    public void setJobGroup(String jobGroup)
    {
        this.jobGroup = jobGroup;
    }

    public String getMethodName()
    {
        return methodName;
    }

    public void setMethodName(String methodName)
    {
        this.methodName = methodName;
    }

    public String getMethodParams()
    {
        return methodParams;
    }

    public void setMethodParams(String methodParams)
    {
        this.methodParams = methodParams;
    }

    public String getCronExpression()
    {
        return cronExpression;
    }

    public void setCronExpression(String cronExpression)
    {
        this.cronExpression = cronExpression;
    }

    public String getMisfirePolicy()
    {
        return misfirePolicy;
    }

    public void setMisfirePolicy(String misfirePolicy)
    {
        this.misfirePolicy = misfirePolicy;
    }

    public String getStatus()
    {
        return status;
    }

    public void setStatus(String status)
    {
        this.status = status;
    }

    @Override
    public String toString()
    {
        return "Job [jobId=" + jobId + ", jobName=" + jobName + ", jobGroup=" + jobGroup + ", methodName=" + methodName
                + ", methodParams=" + methodParams + ", cronExpression=" + cronExpression + ", status=" + status + "]";
    }

}
