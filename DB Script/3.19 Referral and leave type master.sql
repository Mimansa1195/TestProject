-------Add menu for referral---------
INSERT INTO Menu
(ParentMenuId,MenuName,ControllerName,ActionName,[Sequence],CreatedById,CssClass)
VALUES(0,'Referral','Referral','Index',14,2203,'fa fa-user-circle')
-------Add widget for referral-------
INSERT INTO [dbo].[DashboardWidget]
(DashboardWidgetName,CreatedById) VALUES ('Referral',1)
------------------inserting CLT in LeaveTypeMaster-------------------------
INSERT INTO [dbo].[LeaveTypeMaster]
           ([ShortName],[Description],[Priority],[IsAvailableForMarriedOnly],[IsAvailableForMale],[IsAvailableForFemale]
           ,[IsAutoIncremented],[AutoIncrementPeriod],[AutoIncrementAfterType]
           ,[DaysToIncrement],[IsAutoExpire],[AutoExpirePeriod],[AutoExpireAfterType]
		   ,[CreatedBy])
     VALUES
           ('CLT','Quarterly CL for trainees',1,0,1,1,1,3,'Month',3,1,1,'Month',1)

