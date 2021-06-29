--INSERT INTO Menu(ParentMenuId, MenuName,ControllerName,ActionName,Sequence,IsLinkEnabled,IsVisible,IsActive,CreatedById, CssClass,IsDelegatable,IsTabMenu)
  --VALUES(0,'Cab Request', 'CabRequest', 'Index', 23, 0, 1, 1, 1,'fa fa-taxi', 0, 0)
 --,(121,'Review Request', 'CabRequest', 'Review', 1, 1, 1, 1, 1,null, 0, 0)
--,(121,'Finalize Request', 'CabRequest', 'FinalizeRequest', 1, 1, 1, 1, 1,null, 0, 0)

SELECT * FROM Menu WHERE ParentMenuId = 121
UPDATE Menu SET MenuName = 'Finalize Request', ActionName = 'FinalizeRequest' WHERE MenuId = 123


