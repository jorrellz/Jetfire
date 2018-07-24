package com.jetfire.project.system.role.domain;

import java.util.Arrays;

import com.jetfire.framework.aspectj.lang.annotation.Excel;
import com.jetfire.framework.web.domain.BaseEntity;

/**
 * 角色对象 sys_role
 * 
 * @author jetfire
 */
public class Role extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 角色ID */
    @Excel(name = "角色序号")
    private Long roleId;

    /** 角色名称 */
    @Excel(name = "角色名称")
    private String roleName;

    /** 角色权限 */
    @Excel(name = "角色权限")
    private String roleKey;

    /** 角色排序 */
    @Excel(name = "角色排序")
    private String roleSort;

    /** 角色状态（0正常 1停用） */
    @Excel(name = "角色状态")
    private String status;

    /** 用户是否存在此角色标识 默认不存在 */
    private boolean flag = false;
    /** 菜单组 */
    private Long[] menuIds;

    public Long getRoleId()
    {
        return roleId;
    }

    public void setRoleId(Long roleId)
    {
        this.roleId = roleId;
    }

    public String getRoleName()
    {
        return roleName;
    }

    public void setRoleName(String roleName)
    {
        this.roleName = roleName;
    }

    public String getRoleKey()
    {
        return roleKey;
    }

    public void setRoleKey(String roleKey)
    {
        this.roleKey = roleKey;
    }

    public String getRoleSort()
    {
        return roleSort;
    }

    public void setRoleSort(String roleSort)
    {
        this.roleSort = roleSort;
    }

    public String getStatus()
    {
        return status;
    }

    public void setStatus(String status)
    {
        this.status = status;
    }

    public boolean isFlag()
    {
        return flag;
    }

    public void setFlag(boolean flag)
    {
        this.flag = flag;
    }

    public Long[] getMenuIds()
    {
        return menuIds;
    }

    public void setMenuIds(Long[] menuIds)
    {
        this.menuIds = menuIds;
    }

    @Override
    public String toString()
    {
        return "Role [roleId=" + roleId + ", roleName=" + roleName + ", roleKey=" + roleKey + ", roleSort=" + roleSort
                + ", status=" + status + ", flag=" + flag + ", menuIds=" + Arrays.toString(menuIds) + "]";
    }

}
