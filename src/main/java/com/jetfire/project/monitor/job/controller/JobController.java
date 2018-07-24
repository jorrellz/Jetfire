package com.jetfire.project.monitor.job.controller;

import java.util.List;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import com.jetfire.common.utils.poi.ExcelUtil;
import com.jetfire.framework.aspectj.lang.annotation.Log;
import com.jetfire.framework.aspectj.lang.constant.BusinessType;
import com.jetfire.framework.web.controller.BaseController;
import com.jetfire.framework.web.domain.AjaxResult;
import com.jetfire.framework.web.page.TableDataInfo;
import com.jetfire.project.monitor.job.domain.Job;
import com.jetfire.project.monitor.job.service.IJobService;

/**
 * 调度任务信息操作处理
 * 
 * @author jetfire
 */
@Controller
@RequestMapping("/monitor/job")
public class JobController extends BaseController
{
    private String prefix = "monitor/job";

    @Autowired
    private IJobService jobService;

    @RequiresPermissions("monitor:job:view")
    @GetMapping()
    public String job()
    {
        return prefix + "/job";
    }

    @RequiresPermissions("monitor:job:list")
    @PostMapping("/list")
    @ResponseBody
    public TableDataInfo list(Job job)
    {
        startPage();
        List<Job> list = jobService.selectJobList(job);
        return getDataTable(list);
    }

    @Log(title = "定时任务", action = BusinessType.EXPORT)
    @PostMapping("/export")
    @ResponseBody
    public AjaxResult export(Job job) throws Exception
    {
        try
        {
            List<Job> list = jobService.selectJobList(job);
            ExcelUtil<Job> util = new ExcelUtil<Job>(Job.class);
            return util.exportExcel(list, "job");
        }
        catch (Exception e)
        {
            return error("导出Excel失败，请联系网站管理员！");
        }
    }

    @Log(title = "定时任务", action = BusinessType.DELETE)
    @RequiresPermissions("monitor:job:remove")
    @PostMapping("/remove")
    @ResponseBody
    public AjaxResult remove(String ids)
    {
        try
        {
            jobService.deleteJobByIds(ids);
            return success();
        }
        catch (Exception e)
        {
            e.printStackTrace();
            return error(e.getMessage());
        }
    }

    /**
     * 任务调度状态修改
     */
    @Log(title = "定时任务", action = BusinessType.UPDATE)
    @RequiresPermissions("monitor:job:changeStatus")
    @PostMapping("/changeStatus")
    @ResponseBody
    public AjaxResult changeStatus(Job job)
    {
        return toAjax(jobService.changeStatus(job));
    }

    /**
     * 任务调度立即执行一次
     */
    @Log(title = "定时任务", action = BusinessType.UPDATE)
    @RequiresPermissions("monitor:job:changeStatus")
    @PostMapping("/run")
    @ResponseBody
    public AjaxResult run(Job job)
    {
        return toAjax(jobService.run(job));
    }

    /**
     * 新增调度
     */
    @GetMapping("/add")
    public String add()
    {
        return prefix + "/add";
    }

    /**
     * 新增保存调度
     */
    @Log(title = "定时任务", action = BusinessType.INSERT)
    @RequiresPermissions("monitor:job:add")
    @PostMapping("/add")
    @ResponseBody
    public AjaxResult addSave(Job job)
    {
        return toAjax(jobService.insertJobCron(job));
    }

    /**
     * 修改调度
     */
    @GetMapping("/edit/{jobId}")
    public String edit(@PathVariable("jobId") Long jobId, ModelMap mmap)
    {
        mmap.put("job", jobService.selectJobById(jobId));
        return prefix + "/edit";
    }

    /**
     * 修改保存调度
     */
    @Log(title = "定时任务", action = BusinessType.UPDATE)
    @RequiresPermissions("monitor:job:edit")
    @PostMapping("/edit")
    @ResponseBody
    public AjaxResult editSave(Job job)
    {
        return toAjax(jobService.updateJobCron(job));
    }
}
