insert into [dbo].[Menu] (ParentMenuId,MenuName,ControllerName,ActionName,[Sequence],CreatedById)
SELECT M.[MenuId],'Weekly Roster',M.[ControllerName],'WeeklyRoster',10,1
FROM Menu M WHERE M.[ParentMenuId]=0 AND MenuName='Leave Management'