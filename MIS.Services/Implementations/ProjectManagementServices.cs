using MIS.BO;
using MIS.Model;
using MIS.Services.Contracts;
using MIS.Utilities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MIS.Services.Implementations
{
    public class ProjectManagementServices : IProjectManagementServices
    {

        private readonly IUserServices _userServices;

        public ProjectManagementServices(IUserServices userServices)
        {
            _userServices = userServices;
        }

        #region Project verticals

        /// <summary>
        /// List Active Project Verticals
        /// </summary>
        /// <param name="userAbrhs"></param>
        /// <returns></returns>
        public List<BO.GeminiProjectVerticalInfo> ListActiveProjectVerticals(string userAbrhs)
        {
            using (var context = new MISEntities())
            {
                var activeVerticals = context.ProjectVerticals.Where(a => a.IsActive == true).ToList();
                var verticalList = new List<GeminiProjectVerticalInfo>();
                var owners = string.Empty;

                foreach (Model.ProjectVertical v in activeVerticals)
                {
                    var primaryOwnerInfo = context.UserDetails.FirstOrDefault(a => a.UserId == v.CreatedBy);
                    owners = primaryOwnerInfo.FirstName + " " + primaryOwnerInfo.LastName;

                    if (v.CreatedBy != v.OwnerId)
                    {
                        var secondaryOwnerInfo = context.UserDetails.FirstOrDefault(a => a.UserId == v.OwnerId);
                        owners = owners + ", " + secondaryOwnerInfo.FirstName + " " + secondaryOwnerInfo.LastName;
                    }



                    var totalTeamMembersCount =
                        context.ProjectTeamMembers.Where(
                            p => p.Project.VerticalId == v.VerticalId && p.IsActive)
                            .GroupBy(p => p.UserId)
                            .LongCount();

                    var totalProjectsCount = context.Projects.Count(a => a.VerticalId == v.VerticalId);

                    GeminiProjectVerticalInfo vInfo = new GeminiProjectVerticalInfo
                    {
                        Name = v.Vertical,
                        NoofTeamMembers = totalTeamMembersCount,
                        NoofTotalProjects = totalProjectsCount,
                        Owners = owners,
                        VerticalId = v.VerticalId,
                    };

                    verticalList.Add(vInfo);

                }
                var vList = verticalList.OrderBy(a => a.Name).ToList();
                return vList;

            }
        }

        /// <summary>
        /// Fetch Selected Vertical Info
        /// </summary>
        /// <param name="verticalId"></param>
        /// <returns></returns>
        public BO.GeminiProjectVertical FetchSelectedVerticalInfo(int verticalId)
        {
            using (var context = new MISEntities())
            {
                var verticalInfo = context.ProjectVerticals.FirstOrDefault(a => a.VerticalId == verticalId);
                BO.GeminiProjectVertical geminiProjectVertical = new BO.GeminiProjectVertical();
                geminiProjectVertical.VerticalAbrhs = CryptoHelper.Encrypt(verticalInfo.OwnerId.ToString());
                geminiProjectVertical.Vertical = verticalInfo.Vertical;
                return geminiProjectVertical;
            }
        }

        /// <summary>
        /// List Active Users
        /// </summary>
        /// <param name="userAbrhs"></param>
        /// <returns></returns>
        public List<BO.UserDetail> ListActiveUsers(string userAbrhs)
        {
            using (var context = new MISEntities())
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
                var user = context.Users.Where(a => a.IsActive && a.UserId != -1 && a.UserId == userId).FirstOrDefault();
                if (user != null)
                {
                    var activeUsers = context.UserDetails
                            .OrderBy(a => a.FirstName)
                            .ThenBy(a => a.LastName)
                            .ToList();
                    var result = Convertor.Convert<BO.UserDetail, Model.UserDetail>(activeUsers);
                    return result;
                }
                else
                    return new List<BO.UserDetail>();
            }
        }

        /// <summary>
        /// Fetch Role for CurrentUser
        /// </summary>
        /// <param name="userAbrhs"></param>
        /// <returns></returns>
        public string FetchRoleforCurrentUser(string userAbrhs)
        {
            using (var context = new MISEntities())
            {

                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
                var userDetails = context.Users.FirstOrDefault(a => a.UserId == userId);
                var result = userDetails.Role.RoleName;
                return result;
            }
        }

        /// <summary>
        /// List Active Verticals
        /// </summary>
        /// <param name="userAbrhs"></param>
        /// <returns></returns>
        public List<BO.GeminiProjectVertical> ListActiveVerticals(string userAbrhs)
        {
            using (var context = new MISEntities())
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
                var isWebAdmin = context.Users.Select(x => x.RoleId == (int)Enums.Roles.WebAdministrator).Any();
                var verticalList = context.ProjectVerticals.Where(a => a.IsActive);
                if (!isWebAdmin)
                    verticalList = verticalList.Where(a => a.OwnerId == userId || a.CreatedBy == userId);
                //var verticalList = context.ProjectVerticals.Where(a => a.OwnerId == userId || a.CreatedBy == userId).ToList();
                var r = verticalList.OrderBy(a => a.Vertical).ToList();
                var result = Convertor.Convert<BO.GeminiProjectVertical, Model.ProjectVertical>(r);
                return result;
            }
        }

        /// <summary>
        /// List Active Project Industry Type
        /// </summary>
        /// <param name="userAbrhs"></param>
        /// <returns></returns>
        public List<BO.GeminiProjectIndustryType> ListActiveProjectIndustryType(string userAbrhs)
        {
            using (var context = new MISEntities())
            {
                var industryTypeList =
                    context.ProjectIndustryTypes.Where(a => a.IsActive == true || a.IsDeleted == false)
                        .ToList();
                var r = industryTypeList.OrderBy(a => a.IndustryType).ToList();
                var result = Convertor.Convert<BO.GeminiProjectIndustryType, Model.ProjectIndustryType>(r);
                return result;
            }
        }

        /// <summary>
        /// List Active Project Status
        /// </summary>
        /// <param name="userAbrhs"></param>
        /// <returns></returns>
        public List<BO.GeminiProjectStatus> ListActiveProjectStatus(string userAbrhs)
        {
            using (var context = new MISEntities())
            {
                var statusList =
                    context.ProjectStatus.Where(a => a.IsActive == true || a.IsDeleted == false).ToList();
                var r = statusList.OrderBy(a => a.ProjectStatus).ToList();
                var result = Convertor.Convert<BO.GeminiProjectStatus, Model.ProjectStatu>(r);
                return result;
            }
        }

        /// <summary>
        /// List Projects
        /// </summary>
        /// <param name="verticalId"></param>
        /// <param name="parentProjectId"></param>
        /// <param name="userAbrhs"></param>
        /// <returns></returns>
        public List<BO.GeminiProject> ListProjects(long verticalId, long parentProjectId, string userAbrhs)
        {
            using (var context = new MISEntities())
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

                if (parentProjectId == 0)
                {
                    var projectList =
                        context.Projects.Where(
                            a => a.VerticalId == verticalId && a.ParentProjectId == 0 && a.IsActive && !a.IsDeleted)
                            .OrderBy(a => a.Name)
                            .ToList();
                    var result = Convertor.Convert<BO.GeminiProject, Model.Project>(projectList);
                    return result;
                }
                else
                {
                    var projectList =
                        context.Projects.Where(
                            a => a.ParentProjectId == parentProjectId && a.IsActive && !a.IsDeleted)
                            .OrderBy(a => a.Name)
                            .ToList();
                    var result = Convertor.Convert<BO.GeminiProject, Model.Project>(projectList);
                    return result;
                }
            }
        }

        /// <summary>
        /// Fetch Selected Project Info
        /// </summary>
        /// <param name="projectId"></param>
        /// <param name="userAbrhs"></param>
        /// <returns></returns>
        public List<BO.GeminiProjectInfo> FetchSelectedProjectInfo(long projectId, string userAbrhs)
        {
            using (var context = new MISEntities())
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

                var projectsList = new List<GeminiProjectInfo>();

                var project = context.Projects.FirstOrDefault(a => a.ProjectId == projectId);
                var teamCount =
                    context.ProjectTeamMembers.Where(a => a.ProjectId == projectId && a.IsActive)
                        .ToList()
                        .Count();

                var role = context.ProjectTeamMembers.FirstOrDefault(a => a.UserId == userId && a.ProjectId == projectId && a.IsActive);


                string owners = string.Empty;
                //var owns = context.ProjectTeamMembers.Where(a => a.ProjectId == projectId && a.Role == "Project Owner" && a.IsActive).Select(a => a.UserId);
                //foreach (var o in owns)
                //{
                //    var ownerInfo = context.UserDetails.FirstOrDefault(a => a.UserId == o);
                //    if (string.IsNullOrEmpty(owners))
                //    {
                //        owners = ownerInfo.FirstName + " " + ownerInfo.LastName;
                //    }
                //    else
                //    {
                //        owners = owners + ", " + ownerInfo.FirstName + " " + ownerInfo.LastName;
                //    }
                //}

                owners = string.Join(", ", (from p in context.ProjectTeamMembers.Where(a => a.ProjectId == projectId && a.Role == "Project Owner" && a.IsActive)
                                            join u in context.UserDetails on p.UserId equals u.UserId
                                            select new { u.FirstName, u.MiddleName, u.LastName })
                                 .AsEnumerable().Select(t => (t.FirstName + " " + t.MiddleName + " " + t.LastName).Replace("  ", " ")));

                if (project != null)
                {
                    var p = new GeminiProjectInfo
                    {
                        CurrentStatus = project.ProjectStatu.ProjectStatus,
                        EndDate = project.EndDate,
                        Owners = owners,
                        NoofActiveTeamMembers = teamCount,
                        ParentProjectId = project.ParentProjectId.GetValueOrDefault(),
                        ProjectDescription = project.Description,
                        ProjectId = project.ProjectId,
                        ProjectName = project.Name,
                        StartDate = project.StartDate,
                        VerticalId = project.VerticalId,
                    };

                    if (role == null) // no role is available for user
                    {
                        var parentRole = context.ProjectTeamMembers.FirstOrDefault(a => a.UserId == userId && a.ProjectId == p.ParentProjectId && a.IsActive);
                        if (parentRole != null)
                            p.Role = parentRole.Role;
                        else
                            p.Role = "N/A";
                    }
                    else
                    {
                        // role is assigned to user
                        p.Role = role.Role;
                    }
                    if (p.StartDate != null)
                        p.ShowStartDate = p.StartDate.ToString("dd-MMM-yyyy");

                    if (p.EndDate != null)
                        p.ShowEndDate = p.EndDate.Value.ToString("dd-MMM-yyyy");
                    projectsList.Add(p);

                }


                return projectsList;
            }
        }

        /// <summary>
        /// Fetch Project Info
        /// </summary>
        /// <param name="projectId"></param>
        /// <param name="userAbrhs"></param>
        /// <returns></returns>
        public BO.GeminiProject FetchProjectInfo(long projectId, string userAbrhs)
        {
            using (var context = new MISEntities())
            {
                var projectInfo = context.Projects.FirstOrDefault(a => a.ProjectId == projectId);
                var result = Convertor.Convert<BO.GeminiProject, Model.Project>(projectInfo);
                result.ShowStartDate = result.StartDate.ToString("dd-MMM-yyyy");
                result.ShowEndDate = result.EndDate.HasValue ? result.EndDate.Value.ToString("dd-MMM-yyyy") : "";
                return result;
            }
        }

        /// <summary>
        /// List TeamMembers for Selected Project
        /// </summary>
        /// <param name="projectId"></param>
        /// <param name="userAbrhs"></param>
        /// <returns></returns>
        public List<BO.GeminiTeamInfo> ListTeamMembersforSelectedProject(long projectId, string userAbrhs)
        {
            using (var context = new MISEntities())
            {
                var teamMembers = new List<GeminiTeamInfo>();

                var member = context.ProjectTeamMembers.Where(a => a.ProjectId == projectId).ToList();


                foreach (var m in member)
                {
                    var uInfo = context.UserDetails.FirstOrDefault(a => a.UserId == m.UserId);
                    var totalProjects = context.ProjectTeamMembers.Where(a => a.UserId == m.UserId && a.IsActive).ToList().Count();
                    var mInfo = new GeminiTeamInfo
                    {
                        FirstName = uInfo.FirstName,
                        LastName = uInfo.LastName,
                        LeftOn = uInfo.TerminateDate == null ? m.AllocatedTill : uInfo.TerminateDate,
                        NoofTotalProjects = totalProjects,
                        Role = m.Role,
                        StartedFrom = m.AllocatedFrom,
                        Status = (m.IsActive && uInfo.TerminateDate == null) ? "Active" : "Inactive",
                        ShowStartedFrom = m.AllocatedFrom.ToString("dd-MMM-yyyy"),
                    };
                    teamMembers.Add(mInfo);
                }
                var result = teamMembers.OrderBy(a => a.FirstName).ThenBy(a => a.LastName).ThenByDescending(a => a.StartedFrom).ToList();
                return result;

            }
        }

        /// <summary>
        /// List All Users Available For Project
        /// </summary>
        /// <param name="projectId"></param>
        /// <param name="userAbrhs"></param>
        /// <returns></returns>
        public List<BO.UserDetail> ListAllUsersAvailableForProject(long projectId, string userAbrhs)
        {
            using (var context = new MISEntities())
            {

                var sharedToUserId =
                    context.ProjectTeamMembers.Where(a => a.ProjectId == projectId && a.IsActive)
                        .Select(a => a.UserId)
                        .ToList();
                var result =
                    (from u in context.UserDetails where u.User.IsActive && u.UserId != -1 select u).
                        Except(from u in context.UserDetails
                               where sharedToUserId.Contains(u.UserId) && u.User.IsActive
                               select u).OrderBy(a => a.FirstName).ThenBy(a => a.LastName).ToList();
                List<BO.UserDetail> userDetail = new List<BO.UserDetail>();
                if (result.Count > 0)
                {
                    foreach (var item in result)
                    {
                        BO.UserDetail user = new BO.UserDetail();
                        user.EmployeeAbrhs = CryptoHelper.Encrypt(item.UserId.ToString());
                        user.EmployeeName = item.FirstName + " " + item.LastName;
                        userDetail.Add(user);
                    }
                }
                else
                {
                    return new List<BO.UserDetail>();
                }
                return userDetail;
            }
        }

        /// <summary>
        /// List All Users Assigned To Project
        /// </summary>
        /// <param name="projectId"></param>
        /// <param name="role"></param>
        /// <param name="userAbrhs"></param>
        /// <returns></returns>
        public List<BO.UserDetail> ListAllUsersAssignedToProject(long projectId, string role, string userAbrhs)
        {
            using (var context = new MISEntities())
            {
                var sharedToUserId =
                    context.ProjectTeamMembers.Where(
                        a => a.ProjectId == projectId && a.Role == role && a.IsActive)
                        .Select(a => a.UserId)
                        .ToList();
                var team = new List<Model.UserDetail>();
                foreach (var u in sharedToUserId)
                {
                    var userInfo = context.UserDetails.FirstOrDefault(a => a.UserId == u);
                    team.Add(userInfo);
                }
                var result = team.OrderBy(a => a.FirstName).ThenBy(a => a.LastName).ToList();
                List<BO.UserDetail> userDetail = new List<BO.UserDetail>();
                if (result.Count > 0)
                {
                    foreach (var item in result)
                    {
                        BO.UserDetail user = new BO.UserDetail();
                        user.EmployeeAbrhs = CryptoHelper.Encrypt(item.UserId.ToString());
                        user.EmployeeName = item.FirstName + " " + item.LastName;
                        userDetail.Add(user);
                    }
                }
                else
                {
                    return new List<BO.UserDetail>();
                }
                return userDetail;
            }
        }

        /// <summary>
        /// List Root Projects
        /// </summary>
        /// <param name="userAbrhs"></param>
        /// <returns></returns>
        public List<BO.GeminiProject> ListRootProjects(string userAbrhs)
        {
            using (var context = new MISEntities())
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

                var rootProjects = context.spFetchRootProjects(userId);
                var projectList = new List<BO.GeminiProject>();


                foreach (var project in rootProjects)
                {
                    var p = new BO.GeminiProject
                    {
                        ProjectId = project.ProjectId.GetValueOrDefault(),
                        CreatedBy = 1,
                        CreatedDate = DateTime.UtcNow,
                        Description = "",
                        EndDate = Convert.ToDateTime("01-01-1900"),
                        IndustryTypeId = 1,
                        IsActive = true,
                        IsDeleted = false,
                        LastModifiedBy = 1,
                        LastModifiedDate = Convert.ToDateTime("01-01-1900"),
                        ParentProjectId = 0,
                        Name = project.ProjectName,
                        VerticalId = 1,
                        StatusId = 1,
                        StartDate = Convert.ToDateTime("01-01-1900")
                    };
                    projectList.Add(p);
                }

                return projectList;
            }
        }

        #endregion

        #region Project Management

        /// <summary>
        /// Save Project Vertical
        /// </summary>
        /// <param name="vertical"></param>
        /// <returns></returns>
        public int SaveProjectVertical(BO.GeminiProjectVertical vertical)
        {
            try
            {
                using (var context = new MISEntities())
                {
                    var userId = 0;
                    Int32.TryParse(CryptoHelper.Decrypt(vertical.userAbrhs), out userId);

                    var OwnerId = 0;
                    Int32.TryParse(CryptoHelper.Decrypt(vertical.VerticalAbrhs), out OwnerId);

                    vertical.OwnerId = OwnerId;
                    vertical.CreatedBy = userId;
                    vertical.CreatedDate = DateTime.Now;
                    vertical.IsActive = true;
                    var existingVerticalInfo =
                        context.ProjectVerticals.FirstOrDefault(
                            a =>
                                a.Vertical == vertical.Vertical &&
                                a.IsDeleted == false);

                    if (existingVerticalInfo == null)
                    {
                        var modelVertical =
                            Convertor.Convert<Model.ProjectVertical, BO.GeminiProjectVertical>(vertical);
                        context.ProjectVerticals.Add(modelVertical);
                        context.SaveChanges();

                        // Logging 
                        _userServices.SaveUserLogs(ActivityMessages.SaveProjectVertical, userId, 0);

                        return 1;
                    }
                    else
                    {
                        return 2;
                    }
                }
            }
            catch (Exception)
            {
                return 0;
            }
        }

        /// <summary>
        /// Update Project Vertical
        /// </summary>
        /// <param name="vertical"></param>
        /// <returns></returns>
        public int UpdateProjectVertical(BO.GeminiProjectVertical vertical)
        {
            try
            {
                using (var context = new MISEntities())
                {
                    var userId = 0;
                    Int32.TryParse(CryptoHelper.Decrypt(vertical.userAbrhs), out userId);
                    vertical.LastModifiedBy = userId;
                    vertical.LastModifiedDate = DateTime.Now;
                    vertical.IsActive = true;

                    var OwnerId = 0;
                    Int32.TryParse(CryptoHelper.Decrypt(vertical.VerticalAbrhs), out OwnerId);
                    vertical.OwnerId = OwnerId;

                    var verticalInfo =
                        context.ProjectVerticals.FirstOrDefault(a => a.VerticalId == vertical.VerticalId);

                    if (verticalInfo != null)
                    {
                        var existingVerticalInfo =
                            context.ProjectVerticals.FirstOrDefault(
                                a =>
                                    a.Vertical == vertical.Vertical &&
                                    a.VerticalId != vertical.VerticalId &&
                                    a.IsDeleted == false);
                        if (existingVerticalInfo == null)
                        {
                            verticalInfo.Vertical = vertical.Vertical;
                            verticalInfo.OwnerId = vertical.OwnerId;
                            verticalInfo.IsActive = vertical.IsActive;
                            verticalInfo.LastModifiedDate = vertical.LastModifiedDate;
                            verticalInfo.LastModifiedBy = vertical.LastModifiedBy;
                            context.SaveChanges();

                            // Logging 
                            _userServices.SaveUserLogs(ActivityMessages.UpdateProjectVertical, userId, OwnerId);

                            return 1;
                        }
                        else
                        {
                            return 2;
                        }
                    }
                    else
                    {
                        return 0;
                    }
                }
            }
            catch (Exception)
            {
                return 0;
            }
        }

        /// <summary>
        /// Save Project
        /// </summary>
        /// <param name="project"></param>
        /// <returns></returns>
        public int SaveProject(BO.GeminiProject project)
        {
            try
            {
                using (var context = new MISEntities())
                {
                    var userId = 0;
                    Int32.TryParse(CryptoHelper.Decrypt(project.userAbrhs), out userId);

                    var existingProjectInfo =
                        context.Projects.FirstOrDefault(
                            a =>
                                a.Name == project.Name &&
                                a.IsDeleted == false);

                    if (existingProjectInfo == null)
                    {
                        project.CreatedDate = DateTime.Now;
                        project.CreatedBy = userId;
                        project.IsActive = true;
                        project.IsDeleted = false;
                        var modelProject =
                            Convertor.Convert<Model.Project, BO.GeminiProject>(project);
                        context.Projects.Add(modelProject);
                        // create project owners for project
                        var projectTeamMember = new BO.GeminiProjectTeamMember
                        {
                            ProjectId = modelProject.ProjectId,
                            UserId = userId,
                            Role = "Project Owner",
                            IsActive = true,
                            AllocatedFrom = DateTime.UtcNow,
                            CreatedDate = DateTime.UtcNow,
                            CreatedBy = userId
                        };
                        context.ProjectTeamMembers.Add(Convertor.Convert<Model.ProjectTeamMember, BO.GeminiProjectTeamMember>(projectTeamMember));
                        context.SaveChanges();

                        // Logging 
                        _userServices.SaveUserLogs(ActivityMessages.SaveProject, userId, 0);

                        return 1;
                    }
                    else
                    {
                        return 2;
                    }
                }
            }
            catch (Exception)
            {
                return 0;
            }
        }

        /// <summary>
        /// Update Project
        /// </summary>
        /// <param name="project"></param>
        /// <returns></returns>
        public int UpdateProject(BO.GeminiProject project)
        {
            try
            {
                using (var context = new MISEntities())
                {
                    var userId = 0;
                    Int32.TryParse(CryptoHelper.Decrypt(project.userAbrhs), out userId);

                    var existingProjectInfo =
                        context.Projects.FirstOrDefault(
                            a =>
                                a.Name == project.Name &&
                                a.IsDeleted == false && a.ProjectId != project.ProjectId);

                    if (existingProjectInfo == null)
                    {
                        var projectInfo = context.Projects.FirstOrDefault(a => a.ProjectId == project.ProjectId);
                        projectInfo.Name = project.Name;
                        projectInfo.Description = project.Description;
                        projectInfo.StartDate = project.StartDate;
                        projectInfo.EndDate = project.EndDate;
                        projectInfo.IndustryTypeId = project.IndustryTypeId;
                        projectInfo.StatusId = project.StatusId;
                        projectInfo.IsActive = true;
                        projectInfo.IsDeleted = false;
                        projectInfo.LastModifiedBy = userId;
                        projectInfo.LastModifiedDate = DateTime.Now;
                        context.SaveChanges();

                        // Logging 
                        _userServices.SaveUserLogs(ActivityMessages.UpdateProject, userId, 0);

                        return 1;
                    }
                    else
                    {
                        return 2;
                    }
                }
            }
            catch (Exception)
            {
                return 0;
            }
        }

        /// <summary>
        /// Assign TeamMember
        /// </summary>
        /// <param name="teamMember"></param>
        /// <returns></returns>
        public int AssignTeamMember(BO.GeminiProjectTeamMember teamMember)
        {
            try
            {
                using (var context = new MISEntities())
                {
                    var userId = 0;
                    Int32.TryParse(CryptoHelper.Decrypt(teamMember.userAbrhs), out userId);

                    var EmployeeId = 0;
                    Int32.TryParse(CryptoHelper.Decrypt(teamMember.EmployeeAbrhs), out EmployeeId);
                    teamMember.UserId = EmployeeId;

                    var existingMemberInfo =
                        context.ProjectTeamMembers.Where(
                            a =>
                                a.UserId == teamMember.UserId && a.ProjectId == teamMember.ProjectId).ToList();
                    // existing record not available
                    if (!existingMemberInfo.Any())
                    {
                        teamMember.CreatedBy = userId;
                        teamMember.CreatedDate = DateTime.Now;
                        teamMember.IsActive = true;
                        teamMember.AllocatedFrom = DateTime.Now;
                        Model.ProjectTeamMember modelTeamMember =
                            Convertor.Convert<Model.ProjectTeamMember, BO.GeminiProjectTeamMember>(teamMember);
                        context.ProjectTeamMembers.Add(modelTeamMember);
                    }
                    else // existing record available
                    {
                        var toBeAdded = true;
                        foreach (var x in existingMemberInfo)
                        {
                            // check for role
                            if (x.Role == teamMember.Role && !x.IsActive)
                            {
                                x.AllocatedTill = null;
                                x.IsActive = true;
                                x.LastModifiedDate = DateTime.UtcNow;
                                x.LastModifiedBy = teamMember.CreatedBy;
                                toBeAdded = false;
                            }
                            else
                            {
                                x.AllocatedTill = DateTime.UtcNow;
                                x.IsActive = false;
                                x.LastModifiedDate = DateTime.UtcNow;
                                x.LastModifiedBy = teamMember.CreatedBy;
                            }
                            if (toBeAdded)
                            {
                                Model.ProjectTeamMember modelTeamMember =
                            Convertor.Convert<Model.ProjectTeamMember, BO.GeminiProjectTeamMember>(teamMember);
                                context.ProjectTeamMembers.Add(modelTeamMember);
                            }
                        }
                    }

                    // Logging 
                    _userServices.SaveUserLogs(ActivityMessages.AssignTeamMember, userId, 0);

                    context.SaveChanges();
                    return 1;
                }

            }
            catch (Exception)
            {
                return 0;
            }
        }

        /// <summary>
        /// Un Assign TeamMember
        /// </summary>
        /// <param name="teamMember"></param>
        /// <returns></returns>
        public int UnAssignTeamMember(BO.GeminiProjectTeamMember teamMember)
        {
            try
            {
                using (var context = new MISEntities())
                {
                    var userId = 0;
                    Int32.TryParse(CryptoHelper.Decrypt(teamMember.userAbrhs), out userId);

                    var EmployeeId = 0;
                    Int32.TryParse(CryptoHelper.Decrypt(teamMember.EmployeeAbrhs), out EmployeeId);
                    teamMember.UserId = EmployeeId;

                    var existingMemberInfo =
                        context.ProjectTeamMembers.FirstOrDefault(
                            a =>
                                a.UserId == teamMember.UserId && a.ProjectId == teamMember.ProjectId && a.Role == teamMember.Role);
                    if (existingMemberInfo != null)
                    {
                        existingMemberInfo.AllocatedTill = DateTime.Now;
                        existingMemberInfo.IsActive = false;
                        existingMemberInfo.LastModifiedDate = DateTime.Now;
                        existingMemberInfo.LastModifiedBy = userId;
                    }
                    context.SaveChanges();

                    // Logging 
                    _userServices.SaveUserLogs(ActivityMessages.UnAssignTeamMember, userId, EmployeeId);
                }

                return 1;
            }
            catch (Exception)
            {
                return 0;
            }
        }

        #endregion

        #region Pimco Project verticals

        /// <summary>
        /// List Active Project Verticals
        /// </summary>
        /// <param name="userAbrhs"></param>
        /// <returns></returns>
        public List<BO.GeminiProjectVerticalInfo> ListPimcoActiveProjectVerticals(string userAbrhs)
        {
            using (var context = new MISEntities())
            {
                var activeVerticals = context.PimcoProjectVerticals.Where(a => a.IsActive == true).ToList();
                var verticalList = new List<GeminiProjectVerticalInfo>();
                var owners = string.Empty;

                foreach (Model.PimcoProjectVertical v in activeVerticals)
                {
                    var primaryOwnerInfo = context.UserDetails.FirstOrDefault(a => a.UserId == v.CreatedBy);
                    owners = primaryOwnerInfo.FirstName + " " + primaryOwnerInfo.LastName;

                    if (v.CreatedBy != v.OwnerId)
                    {
                        var secondaryOwnerInfo = context.UserDetails.FirstOrDefault(a => a.UserId == v.OwnerId);
                        owners = owners + ", " + secondaryOwnerInfo.FirstName + " " + secondaryOwnerInfo.LastName;
                    }

                    var totalTeamMembersCount =
                        context.PimcoProjectTeamMembers.Where(
                            p => p.PimcoProject.VerticalId == v.VerticalId && p.IsActive)
                            .GroupBy(p => p.UserId)
                            .LongCount();

                    var totalProjectsCount = context.PimcoProjects.Count(a => a.VerticalId == v.VerticalId);

                    GeminiProjectVerticalInfo vInfo = new GeminiProjectVerticalInfo
                    {
                        Name = v.Vertical,
                        NoofTeamMembers = totalTeamMembersCount,
                        NoofTotalProjects = totalProjectsCount,
                        Owners = owners,
                        VerticalId = v.VerticalId,
                    };

                    verticalList.Add(vInfo);

                }
                var vList = verticalList.OrderBy(a => a.Name).ToList();
                return vList;

            }
        }

        /// <summary>
        /// Fetch Selected Vertical Info
        /// </summary>
        /// <param name="verticalId"></param>
        /// <returns></returns>
        public BO.GeminiProjectVertical FetchPimcoSelectedVerticalInfo(int verticalId)
        {
            using (var context = new MISEntities())
            {
                var verticalInfo = context.PimcoProjectVerticals.FirstOrDefault(a => a.VerticalId == verticalId);
                BO.GeminiProjectVertical geminiProjectVertical = new BO.GeminiProjectVertical();
                geminiProjectVertical.VerticalAbrhs = CryptoHelper.Encrypt(verticalInfo.OwnerId.ToString());
                geminiProjectVertical.Vertical = verticalInfo.Vertical;
                return geminiProjectVertical;
            }
        }

        /// <summary>
        /// List Active Users
        /// </summary>
        /// <param name="userAbrhs"></param>
        /// <returns></returns>
        public List<BO.UserDetail> ListPimcoActiveUsers(string userAbrhs)
        {
            using (var context = new MISEntities())
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
                var user = context.Users.Where(a => a.IsActive && a.UserId != -1 && a.UserId == userId).FirstOrDefault();
                if (user != null)
                {
                    var activeUsers = context.UserDetails
                            .OrderBy(a => a.FirstName)
                            .ThenBy(a => a.LastName)
                            .ToList();
                    var result = Convertor.Convert<BO.UserDetail, Model.UserDetail>(activeUsers);
                    return result;
                }
                else
                    return new List<BO.UserDetail>();
            }
        }

        /// <summary>
        /// Fetch Role for CurrentUser
        /// </summary>
        /// <param name="userAbrhs"></param>
        /// <returns></returns>
        public string FetchPimcoRoleforCurrentUser(string userAbrhs)
        {
            using (var context = new MISEntities())
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
                var userDetails = context.Users.FirstOrDefault(a => a.UserId == userId);
                var result = userDetails.Role.RoleName;
                var vertical = context.PimcoProjectVerticals.Where(t => t.OwnerId == userId && t.IsActive && !t.IsDeleted).FirstOrDefault();
                if (vertical != null)
                {
                    result = "Management";
                }
                return result;
            }
        }

        /// <summary>
        /// List Active Verticals
        /// </summary>
        /// <param name="userAbrhs"></param>
        /// <returns></returns>
        public List<BO.GeminiProjectVertical> ListPimcoActiveVerticals(string userAbrhs)
        {
            using (var context = new MISEntities())
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);
                var isWebAdmin = context.Users.Select(x => x.RoleId == (int)Enums.Roles.WebAdministrator).Any();
                var verticalList = context.PimcoProjectVerticals.Where(a => a.IsActive);
                if (!isWebAdmin)
                    verticalList = verticalList.Where(a => a.OwnerId == userId || a.CreatedBy == userId);
                //var verticalList = context.ProjectVerticals.Where(a => a.OwnerId == userId || a.CreatedBy == userId).ToList();
                var r = verticalList.OrderBy(a => a.Vertical).ToList();
                var result = Convertor.Convert<BO.GeminiProjectVertical, Model.PimcoProjectVertical>(r);
                return result;
            }
        }

        /// <summary>
        /// List Active Project Industry Type
        /// </summary>
        /// <param name="userAbrhs"></param>
        /// <returns></returns>
        public List<BO.GeminiProjectIndustryType> ListPimcoActiveProjectIndustryType(string userAbrhs)
        {
            using (var context = new MISEntities())
            {
                var industryTypeList =
                    context.ProjectIndustryTypes.Where(a => a.IsActive == true || a.IsDeleted == false)
                        .ToList();
                var r = industryTypeList.OrderBy(a => a.IndustryType).ToList();
                var result = Convertor.Convert<BO.GeminiProjectIndustryType, Model.ProjectIndustryType>(r);
                return result;
            }
        }

        /// <summary>
        /// List Active Project Status
        /// </summary>
        /// <param name="userAbrhs"></param>
        /// <returns></returns>
        public List<BO.GeminiProjectStatus> ListPimcoActiveProjectStatus(string userAbrhs)
        {
            using (var context = new MISEntities())
            {
                var statusList =
                    context.ProjectStatus.Where(a => a.IsActive == true || a.IsDeleted == false).ToList();
                var r = statusList.OrderBy(a => a.ProjectStatus).ToList();
                var result = Convertor.Convert<BO.GeminiProjectStatus, Model.ProjectStatu>(r);
                return result;
            }
        }

        /// <summary>
        /// List Projects
        /// </summary>
        /// <param name="verticalId"></param>
        /// <param name="parentProjectId"></param>
        /// <param name="userAbrhs"></param>
        /// <returns></returns>
        public List<BO.PimcoProject> ListPimcoProjects(long verticalId, long parentProjectId, string userAbrhs)
        {
            using (var context = new MISEntities())
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

                if (parentProjectId == 0)
                {
                    var projectList =
                        context.PimcoProjects.Where(
                            a => a.VerticalId == verticalId && a.ParentProjectId == 0 && a.IsActive)
                            .OrderBy(a => a.Name)
                            .ToList();
                    var result = Convertor.Convert<BO.PimcoProject, Model.PimcoProject>(projectList);
                    return result;
                }
                else
                {
                    var projectList =
                        context.PimcoProjects.Where(
                            a => a.ParentProjectId == parentProjectId && a.IsActive)
                            .OrderBy(a => a.Name)
                            .ToList();
                    var result = Convertor.Convert<BO.PimcoProject, Model.PimcoProject>(projectList);
                    return result;
                }
            }
        }

        /// <summary>
        /// Fetch Selected Project Info
        /// </summary>
        /// <param name="projectId"></param>
        /// <param name="userAbrhs"></param>
        /// <returns></returns>
        public List<BO.GeminiProjectInfo> FetchPimcoSelectedProjectInfo(long projectId, string userAbrhs)
        {
            using (var context = new MISEntities())
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

                var projectsList = new List<GeminiProjectInfo>();

                var project = context.PimcoProjects.FirstOrDefault(a => a.PimcoProjectId == projectId);
                var teamCount =
                    context.PimcoProjectTeamMembers.Where(a => a.PimcoProjectId == projectId && a.IsActive)
                        .ToList()
                        .Count();

                var role = context.PimcoProjectTeamMembers.FirstOrDefault(a => a.UserId == userId && a.PimcoProjectId == projectId && a.IsActive);

                

                string owners = string.Empty;
                //var owns = context.ProjectTeamMembers.Where(a => a.ProjectId == projectId && a.Role == "Project Owner" && a.IsActive).Select(a => a.UserId);
                //foreach (var o in owns)
                //{
                //    var ownerInfo = context.UserDetails.FirstOrDefault(a => a.UserId == o);
                //    if (string.IsNullOrEmpty(owners))
                //    {
                //        owners = ownerInfo.FirstName + " " + ownerInfo.LastName;
                //    }
                //    else
                //    {
                //        owners = owners + ", " + ownerInfo.FirstName + " " + ownerInfo.LastName;
                //    }
                //}

                owners = string.Join(", ", (from p in context.PimcoProjectTeamMembers.Where(a => a.PimcoProjectId == projectId && a.ProjectRole == "Project Owner" && a.IsActive)
                                            join u in context.UserDetails on p.UserId equals u.UserId
                                            select new { u.FirstName, u.MiddleName, u.LastName })
                                 .AsEnumerable().Select(t => (t.FirstName + " " + t.MiddleName + " " + t.LastName).Replace("  ", " ")));

                if (project != null)
                {
                    var p = new GeminiProjectInfo
                    {
                        CurrentStatus = project.ProjectStatu.ProjectStatus,
                        EndDate = project.EndDate,
                        Owners = owners,
                        NoofActiveTeamMembers = teamCount,
                        ParentProjectId = project.ParentProjectId,
                        ProjectDescription = project.Description,
                        ProjectId = project.PimcoProjectId,
                        ProjectName = project.Name,
                        StartDate = project.StartDate,
                        VerticalId = project.VerticalId,
                    };

                    if (role == null) // no role is available for user
                    {
                        var parentRole = context.PimcoProjectTeamMembers.FirstOrDefault(a => a.UserId == userId && a.PimcoProjectId == p.ParentProjectId && a.IsActive);
                        if (parentRole != null)
                            p.Role = parentRole.ProjectRole;
                        else
                            p.Role = "N/A";
                    }
                    else
                    {
                        // role is assigned to user
                        p.Role = role.ProjectRole;
                    }
                    if (p.StartDate != null)
                        p.ShowStartDate = p.StartDate.ToString("dd-MMM-yyyy");

                    if (p.EndDate != null)
                        p.ShowEndDate = p.EndDate.Value.ToString("dd-MMM-yyyy");


                    var vertical = context.PimcoProjectVerticals.FirstOrDefault(t => t.OwnerId == userId && t.IsActive && !t.IsDeleted);
                    if (vertical != null)
                    {
                        p.Role = "Project Owner";
                    }

                    projectsList.Add(p);

                }


                return projectsList;
            }
        }

        /// <summary>
        /// Fetch Project Info
        /// </summary>
        /// <param name="projectId"></param>
        /// <param name="userAbrhs"></param>
        /// <returns></returns>
        public BO.PimcoProject FetchPimcoProjectInfo(long projectId, string userAbrhs)
        {
            using (var context = new MISEntities())
            {
                var projectInfo = context.PimcoProjects.FirstOrDefault(a => a.PimcoProjectId == projectId);
                var result = Convertor.Convert<BO.PimcoProject, Model.PimcoProject>(projectInfo);
                result.ShowStartDate = result.StartDate.ToString("dd-MMM-yyyy");
                result.ShowEndDate = result.EndDate.HasValue ? result.EndDate.Value.ToString("dd-MMM-yyyy") : "";
                return result;
            }
        }

        /// <summary>
        /// List TeamMembers for Selected Project
        /// </summary>
        /// <param name="projectId"></param>
        /// <param name="userAbrhs"></param>
        /// <returns></returns>
        public List<BO.GeminiTeamInfo> ListPimcoTeamMembersforSelectedProject(long projectId, string userAbrhs)
        {
            using (var context = new MISEntities())
            {
                var teamMembers = new List<GeminiTeamInfo>();

                var member = context.PimcoProjectTeamMembers.Where(a => a.PimcoProjectId == projectId).ToList();


                foreach (var m in member)
                {
                    var uInfo = context.UserDetails.FirstOrDefault(a => a.UserId == m.UserId);
                    var totalProjects = context.PimcoProjectTeamMembers.Where(a => a.UserId == m.UserId && a.IsActive).ToList().Count();
                    var mInfo = new GeminiTeamInfo
                    {
                        FirstName = uInfo.FirstName,
                        LastName = uInfo.LastName,
                        LeftOn = uInfo.TerminateDate == null ? m.AllocatedTill : uInfo.TerminateDate,
                        NoofTotalProjects = totalProjects,
                        Role = m.ProjectRole,
                        StartedFrom = m.AllocatedFrom,
                        Status = (m.IsActive && uInfo.TerminateDate == null) ? "Active" : "Inactive",
                        ShowStartedFrom = m.AllocatedFrom.ToString("dd-MMM-yyyy"),
                    };
                    teamMembers.Add(mInfo);
                }
                var result = teamMembers.OrderBy(a => a.FirstName).ThenBy(a => a.LastName).ThenByDescending(a => a.StartedFrom).ToList();
                return result;

            }
        }

        /// <summary>
        /// List All Users Available For Project
        /// </summary>
        /// <param name="projectId"></param>
        /// <param name="userAbrhs"></param>
        /// <returns></returns>
        public List<BO.UserDetail> ListPimcoAllUsersAvailableForProject(long projectId, string userAbrhs)
        {
            using (var context = new MISEntities())
            {

                var sharedToUserId =
                    context.PimcoProjectTeamMembers.Where(a => a.PimcoProjectId == projectId && a.IsActive)
                        .Select(a => a.UserId)
                        .ToList();
                var result =
                    (from u in context.UserDetails where u.User.IsActive && u.UserId != -1 select u).
                        Except(from u in context.UserDetails
                               where sharedToUserId.Contains(u.UserId) && u.User.IsActive
                               select u).OrderBy(a => a.FirstName).ThenBy(a => a.LastName).ToList();
                List<BO.UserDetail> userDetail = new List<BO.UserDetail>();
                if (result.Count > 0)
                {
                    foreach (var item in result)
                    {
                        BO.UserDetail user = new BO.UserDetail();
                        user.EmployeeAbrhs = CryptoHelper.Encrypt(item.UserId.ToString());
                        user.EmployeeName = item.FirstName + " " + item.LastName;
                        userDetail.Add(user);
                    }
                }
                else
                {
                    return new List<BO.UserDetail>();
                }
                return userDetail;
            }
        }

        /// <summary>
        /// List All Users Assigned To Project
        /// </summary>
        /// <param name="projectId"></param>
        /// <param name="role"></param>
        /// <param name="userAbrhs"></param>
        /// <returns></returns>
        public List<BO.UserDetail> ListPimcoAllUsersAssignedToProject(long projectId, string role, string userAbrhs)
        {
            using (var context = new MISEntities())
            {
                var sharedToUserId =
                    context.PimcoProjectTeamMembers.Where(
                        a => a.PimcoProjectId == projectId && a.ProjectRole == role && a.IsActive)
                        .Select(a => a.UserId)
                        .ToList();
                var team = new List<Model.UserDetail>();
                foreach (var u in sharedToUserId)
                {
                    var userInfo = context.UserDetails.FirstOrDefault(a => a.UserId == u);
                    team.Add(userInfo);
                }
                var result = team.OrderBy(a => a.FirstName).ThenBy(a => a.LastName).ToList();
                List<BO.UserDetail> userDetail = new List<BO.UserDetail>();
                if (result.Count > 0)
                {
                    foreach (var item in result)
                    {
                        BO.UserDetail user = new BO.UserDetail();
                        user.EmployeeAbrhs = CryptoHelper.Encrypt(item.UserId.ToString());
                        user.EmployeeName = item.FirstName + " " + item.LastName;
                        userDetail.Add(user);
                    }
                }
                else
                {
                    return new List<BO.UserDetail>();
                }
                return userDetail;
            }
        }

        /// <summary>
        /// List Root Projects
        /// </summary>
        /// <param name="userAbrhs"></param>
        /// <returns></returns>
        public List<BO.PimcoProject> ListPimcoRootProjects(string userAbrhs)
        {
            using (var context = new MISEntities())
            {
                var userId = 0;
                Int32.TryParse(CryptoHelper.Decrypt(userAbrhs), out userId);

                var rootProjects = context.spFetchPimcoRootProjects(userId);
                var projectList = new List<BO.PimcoProject>();

                foreach (var project in rootProjects)
                {
                    var p = new BO.PimcoProject
                    {
                        PimcoProjectId = project.ProjectId.GetValueOrDefault(),
                        CreatedBy = 1,
                        CreatedDate = DateTime.UtcNow,
                        Description = "",
                        EndDate = Convert.ToDateTime("01-01-1900"),
                        IsActive = true,
                        ModifiedBy = 1,
                        ModifiedDate = Convert.ToDateTime("01-01-1900"),
                        ParentProjectId = 0,
                        Name = project.ProjectName,
                        VerticalId = 1,
                        StatusId = 1,
                        StartDate = Convert.ToDateTime("01-01-1900")
                    };
                    projectList.Add(p);
                }

                return projectList;
            }
        }

        #endregion

        #region Pimco Project Management

        /// <summary>
        /// Save Project Vertical
        /// </summary>
        /// <param name="vertical"></param>
        /// <returns></returns>
        public int SavePimcoProjectVertical(BO.GeminiProjectVertical vertical)
        {
            try
            {
                using (var context = new MISEntities())
                {
                    var userId = 0;
                    Int32.TryParse(CryptoHelper.Decrypt(vertical.userAbrhs), out userId);

                    var OwnerId = 0;
                    Int32.TryParse(CryptoHelper.Decrypt(vertical.VerticalAbrhs), out OwnerId);

                    vertical.OwnerId = OwnerId;
                    vertical.CreatedBy = userId;
                    vertical.CreatedDate = DateTime.Now;
                    vertical.IsActive = true;
                    var existingVerticalInfo =
                        context.PimcoProjectVerticals.FirstOrDefault(
                            a =>
                                a.Vertical == vertical.Vertical &&
                                a.IsDeleted == false);

                    if (existingVerticalInfo == null)
                    {
                        var modelVertical =
                            Convertor.Convert<Model.PimcoProjectVertical, BO.GeminiProjectVertical>(vertical);
                        context.PimcoProjectVerticals.Add(modelVertical);
                        context.SaveChanges();

                        // Logging 
                        _userServices.SaveUserLogs(ActivityMessages.SaveProjectVertical, userId, 0);

                        return 1;
                    }
                    else
                    {
                        return 2;
                    }
                }
            }
            catch (Exception)
            {
                return 0;
            }
        }

        /// <summary>
        /// Update Project Vertical
        /// </summary>
        /// <param name="vertical"></param>
        /// <returns></returns>
        public int UpdatePimcoProjectVertical(BO.GeminiProjectVertical vertical)
        {
            try
            {
                using (var context = new MISEntities())
                {
                    var userId = 0;
                    Int32.TryParse(CryptoHelper.Decrypt(vertical.userAbrhs), out userId);
                    vertical.LastModifiedBy = userId;
                    vertical.LastModifiedDate = DateTime.Now;
                    vertical.IsActive = true;

                    var OwnerId = 0;
                    Int32.TryParse(CryptoHelper.Decrypt(vertical.VerticalAbrhs), out OwnerId);
                    vertical.OwnerId = OwnerId;

                    var verticalInfo =
                        context.PimcoProjectVerticals.FirstOrDefault(a => a.VerticalId == vertical.VerticalId);

                    if (verticalInfo != null)
                    {
                        var existingVerticalInfo =
                            context.PimcoProjectVerticals.FirstOrDefault(
                                a =>
                                    a.Vertical == vertical.Vertical &&
                                    a.VerticalId != vertical.VerticalId &&
                                    a.IsDeleted == false);
                        if (existingVerticalInfo == null)
                        {
                            verticalInfo.Vertical = vertical.Vertical;
                            verticalInfo.OwnerId = vertical.OwnerId;
                            verticalInfo.IsActive = vertical.IsActive;
                            verticalInfo.LastModifiedDate = vertical.LastModifiedDate;
                            verticalInfo.LastModifiedBy = vertical.LastModifiedBy;
                            context.SaveChanges();

                            // Logging 
                            _userServices.SaveUserLogs(ActivityMessages.UpdateProjectVertical, userId, OwnerId);

                            return 1;
                        }
                        else
                        {
                            return 2;
                        }
                    }
                    else
                    {
                        return 0;
                    }
                }
            }
            catch (Exception)
            {
                return 0;
            }
        }

        /// <summary>
        /// Save Project
        /// </summary>
        /// <param name="project"></param>
        /// <returns></returns>
        public int SavePimcoProject(BO.PimcoProject project)
        {
            try
            {
                using (var context = new MISEntities())
                {
                    var userId = 0;
                    Int32.TryParse(CryptoHelper.Decrypt(project.userAbrhs), out userId);

                    var existingProjectInfo =
                        context.PimcoProjects.FirstOrDefault(
                            a =>
                                a.Name == project.Name &&
                                a.IsActive == true);

                    if (existingProjectInfo == null)
                    {
                        project.CreatedDate = DateTime.Now;
                        project.CreatedBy = userId;
                        project.IsActive = true;
                        var modelProject =
                            Convertor.Convert<Model.PimcoProject, BO.PimcoProject>(project);
                        context.PimcoProjects.Add(modelProject);
                        // create project owners for project
                        var projectTeamMember = new BO.PimcoProjectTeamMember
                        {
                            PimcoProjectId = modelProject.PimcoProjectId,
                            UserId = userId,
                            ProjectRole = "Project Owner",
                            IsActive = true,
                            AllocatedFrom = DateTime.UtcNow,
                            CreatedDate = DateTime.UtcNow,
                            CreatedById = userId
                        };
                        context.PimcoProjectTeamMembers.Add(Convertor.Convert<Model.PimcoProjectTeamMember, BO.PimcoProjectTeamMember>(projectTeamMember));
                        context.SaveChanges();

                        // Logging 
                        _userServices.SaveUserLogs(ActivityMessages.SaveProject, userId, 0);

                        return 1;
                    }
                    else
                    {
                        return 2;
                    }
                }
            }
            catch (Exception ex)
            {
                return 0;
            }
        }

        /// <summary>
        /// Update Project
        /// </summary>
        /// <param name="project"></param>
        /// <returns></returns>
        public int UpdatePimcoProject(BO.PimcoProject project)
        {
            try
            {
                using (var context = new MISEntities())
                {
                    var userId = 0;
                    Int32.TryParse(CryptoHelper.Decrypt(project.userAbrhs), out userId);

                    var existingProjectInfo =
                        context.PimcoProjects.FirstOrDefault(
                            a =>
                                a.Name == project.Name &&
                                a.IsActive == true && a.PimcoProjectId != project.PimcoProjectId);

                    if (existingProjectInfo == null)
                    {
                        var projectInfo = context.PimcoProjects.FirstOrDefault(a => a.PimcoProjectId == project.PimcoProjectId);
                        projectInfo.Name = project.Name;
                        projectInfo.Description = project.Description;
                        projectInfo.StartDate = project.StartDate;
                        projectInfo.EndDate = project.EndDate;
                        projectInfo.StatusId = project.StatusId;
                        projectInfo.IsActive = true;
                        projectInfo.ModifiedBy = userId;
                        projectInfo.ModifiedDate = DateTime.Now;
                        context.SaveChanges();

                        // Logging 
                        _userServices.SaveUserLogs(ActivityMessages.UpdateProject, userId, 0);

                        return 1;
                    }
                    else
                    {
                        return 2;
                    }
                }
            }
            catch (Exception)
            {
                return 0;
            }
        }

        /// <summary>
        /// Assign TeamMember
        /// </summary>
        /// <param name="teamMember"></param>
        /// <returns></returns>
        public int AssignPimcoTeamMember(BO.PimcoProjectTeamMember teamMember)
        {
            try
            {
                using (var context = new MISEntities())
                {
                    var userId = 0;
                    Int32.TryParse(CryptoHelper.Decrypt(teamMember.userAbrhs), out userId);

                    var EmployeeId = 0;
                    Int32.TryParse(CryptoHelper.Decrypt(teamMember.EmployeeAbrhs), out EmployeeId);
                    teamMember.UserId = EmployeeId;

                    var existingMemberInfo =
                        context.PimcoProjectTeamMembers.Where(
                            a =>
                                a.UserId == teamMember.UserId && a.PimcoProjectId == teamMember.PimcoProjectId).ToList();
                    // existing record not available
                    if (!existingMemberInfo.Any())
                    {
                        teamMember.CreatedById = userId;
                        teamMember.CreatedDate = DateTime.Now;
                        teamMember.IsActive = true;
                        teamMember.AllocatedFrom = DateTime.Now;
                        Model.PimcoProjectTeamMember modelTeamMember =
                            Convertor.Convert<Model.PimcoProjectTeamMember, BO.PimcoProjectTeamMember>(teamMember);
                        context.PimcoProjectTeamMembers.Add(modelTeamMember);
                    }
                    else // existing record available
                    {
                        var toBeAdded = true;
                        foreach (var x in existingMemberInfo)
                        {
                            // check for role
                            if (x.ProjectRole == teamMember.ProjectRole && !x.IsActive)
                            {
                                x.AllocatedTill = null;
                                x.IsActive = true;
                                x.ModifiedDate = DateTime.UtcNow;
                                x.ModifiedById = teamMember.CreatedById;
                                toBeAdded = false;
                            }
                            else
                            {
                                x.AllocatedTill = DateTime.UtcNow;
                                x.IsActive = false;
                                x.ModifiedDate = DateTime.UtcNow;
                                x.ModifiedById = teamMember.CreatedById;
                            }
                            if (toBeAdded)
                            {
                                Model.PimcoProjectTeamMember modelTeamMember =
                            Convertor.Convert<Model.PimcoProjectTeamMember, BO.PimcoProjectTeamMember>(teamMember);
                                context.PimcoProjectTeamMembers.Add(modelTeamMember);
                            }
                        }
                    }

                    // Logging 
                    _userServices.SaveUserLogs(ActivityMessages.AssignTeamMember, userId, 0);

                    context.SaveChanges();
                    return 1;
                }

            }
            catch (Exception)
            {
                return 0;
            }
        }

        /// <summary>
        /// Un Assign TeamMember
        /// </summary>
        /// <param name="teamMember"></param>
        /// <returns></returns>
        public int UnAssignPimcoTeamMember(BO.PimcoProjectTeamMember teamMember)
        {
            try
            {
                using (var context = new MISEntities())
                {
                    var userId = 0;
                    Int32.TryParse(CryptoHelper.Decrypt(teamMember.userAbrhs), out userId);

                    var EmployeeId = 0;
                    Int32.TryParse(CryptoHelper.Decrypt(teamMember.EmployeeAbrhs), out EmployeeId);
                    teamMember.UserId = EmployeeId;

                    var existingMemberInfo =
                        context.PimcoProjectTeamMembers.FirstOrDefault(
                            a =>
                                a.UserId == teamMember.UserId && a.PimcoProjectId == teamMember.PimcoProjectId && a.ProjectRole == teamMember.ProjectRole);
                    if (existingMemberInfo != null)
                    {
                        existingMemberInfo.AllocatedTill = DateTime.Now;
                        existingMemberInfo.IsActive = false;
                        existingMemberInfo.ModifiedDate = DateTime.Now;
                        existingMemberInfo.ModifiedById = userId;
                    }
                    context.SaveChanges();

                    // Logging 
                    _userServices.SaveUserLogs(ActivityMessages.UnAssignTeamMember, userId, EmployeeId);
                }

                return 1;
            }
            catch (Exception)
            {
                return 0;
            }
        }

        #endregion
    }
}
