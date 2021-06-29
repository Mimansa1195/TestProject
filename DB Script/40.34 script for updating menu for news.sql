INSERT INTO Menu (ParentMenuId,MenuName,ControllerName,ActionName,[Sequence],CreatedById)
SELECT M.[MenuId],'Manage News',M.[ControllerName],'ManageNews',4,1
FROM Menu M Where M.[ControllerName]='HRPortal' AND M.[ParentMenuId]=0

UPDATE T
SET T.[IsActive]=0 , T.[ModifiedDate]=GETDATE(), T.[ModifiedById]=1
FROM Menu T
WHERE T.[ControllerName]='Administrations' AND T.[ActionName]='ManageNews'