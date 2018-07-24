package com.jetfire.project.monitor.online.domain;

import com.jetfire.common.utils.AddressUtils;
import com.jetfire.framework.web.domain.BaseEntity;
import com.jetfire.project.monitor.online.domain.OnlineSession.OnlineStatus;
import java.util.Date;

/**
 * 当前在线会话 sys_user_online
 * 
 * @author jetfire
 */
public class UserOnline extends BaseEntity
{
    private static final long serialVersionUID = 1L;
    /** 用户会话id */
    private String sessionId;

    /** 部门名称 */
    private String deptName;

    /** 登录名称 */
    private String loginName;

    /** 登录IP地址 */
    private String ipaddr;

    /** 登录地址 */
    private String longinLocation;

    /** 浏览器类型 */
    private String browser;

    /** 操作系统 */
    private String os;

    /** session创建时间 */
    private Date startTimestamp;

    /** session最后访问时间 */
    private Date lastAccessTime;

    /** 超时时间，单位为分钟 */
    private Long expireTime;

    /** 在线状态 */
    private OnlineStatus status = OnlineStatus.on_line;

    /** 备份的当前用户会话 */
    private OnlineSession session;

    /**
     * 设置session对象
     */
    public static final UserOnline fromOnlineSession(OnlineSession session)
    {
        UserOnline online = new UserOnline();
        online.setSessionId(String.valueOf(session.getId()));
        online.setDeptName(session.getDeptName());
        online.setLoginName(session.getLoginName());
        online.setStartTimestamp(session.getStartTimestamp());
        online.setLastAccessTime(session.getLastAccessTime());
        online.setExpireTime(session.getTimeout());
        online.setIpaddr(session.getHost());
        online.setLonginLocation(AddressUtils.getRealAddressByIP(session.getHost()));
        online.setBrowser(session.getBrowser());
        online.setOs(session.getOs());
        online.setStatus(session.getStatus());
        online.setSession(session);
        return online;
    }

    public String getSessionId()
    {
        return sessionId;
    }

    public void setSessionId(String sessionId)
    {
        this.sessionId = sessionId;
    }

    public String getDeptName()
    {
        return deptName;
    }

    public void setDeptName(String deptName)
    {
        this.deptName = deptName;
    }

    public String getLoginName()
    {
        return loginName;
    }

    public void setLoginName(String loginName)
    {
        this.loginName = loginName;
    }

    public String getIpaddr()
    {
        return ipaddr;
    }

    public void setIpaddr(String ipaddr)
    {
        this.ipaddr = ipaddr;
    }

    public String getLonginLocation()
    {
        return longinLocation;
    }

    public void setLonginLocation(String longinLocation)
    {
        this.longinLocation = longinLocation;
    }

    public String getBrowser()
    {
        return browser;
    }

    public void setBrowser(String browser)
    {
        this.browser = browser;
    }

    public String getOs()
    {
        return os;
    }

    public void setOs(String os)
    {
        this.os = os;
    }

    public Date getStartTimestamp()
    {
        return startTimestamp;
    }

    public void setStartTimestamp(Date startTimestamp)
    {
        this.startTimestamp = startTimestamp;
    }

    public Date getLastAccessTime()
    {
        return lastAccessTime;
    }

    public void setLastAccessTime(Date lastAccessTime)
    {
        this.lastAccessTime = lastAccessTime;
    }

    public Long getExpireTime()
    {
        return expireTime;
    }

    public void setExpireTime(Long expireTime)
    {
        this.expireTime = expireTime;
    }

    public OnlineStatus getStatus()
    {
        return status;
    }

    public void setStatus(OnlineStatus status)
    {
        this.status = status;
    }

    public OnlineSession getSession()
    {
        return session;
    }

    public void setSession(OnlineSession session)
    {
        this.session = session;
    }

    @Override
    public String toString()
    {
        return "UserOnline [sessionId=" + sessionId + ", deptName=" + deptName + ", loginName=" + loginName
                + ", ipaddr=" + ipaddr + ", browser=" + browser + ", os=" + os + ", startTimestamp=" + startTimestamp
                + ", lastAccessTime=" + lastAccessTime + ", expireTime=" + expireTime + ", status=" + status
                + ", session=" + session + "]";
    }

}
