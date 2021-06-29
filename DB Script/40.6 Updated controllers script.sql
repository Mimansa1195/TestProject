UPDATE MENU SET IsActive=0 WHERE MENUID=14
INSERT INTO menu(ParentMenuId,MenuName,ControllerName,ActionName,[Sequence],IsLinkEnabled,IsVisible,CreatedById,CssClass)
VALUES (126,'HR Leave Dashboard','HRPortal','HRLeaveDashboard',3,1,1,1,'font-icon glyphicon glyphicon-send')
