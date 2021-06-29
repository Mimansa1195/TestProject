INSERT INTO Menu(ParentMenuId, MenuName,ControllerName,ActionName,Sequence,IsLinkEnabled,IsVisible,IsActive,CreatedById, CssClass,IsDelegatable,IsTabMenu)
--VALUES(0,'Pimco User Management', 'PimcoUserManagement', 'Index', 28, 0, 1, 1, 1,'font-icon font-icon-user', 0, 0)
VALUES(137,'Manage User', 'PimcoUserManagement', 'ManageUser', 1, 1, 1, 1, 1,null, 0, 0)

--SELECT Max(Sequence) FROM Menu where ParentMenuId = 0 AND IsActive = 1 