GO
/****** Object:  StoredProcedure [dbo].[Proc_AddAppraisalSetting]    Script Date: 12-03-2019 11:24:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AddAppraisalSetting]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AddAppraisalSetting]
GO
/****** Object:  UserDefinedFunction [dbo].[Fun_GetUnCommonKey]    Script Date: 12-03-2019 11:24:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_GetUnCommonKey]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_GetUnCommonKey]
GO
/****** Object:  UserDefinedFunction [dbo].[Fun_GetUnCommonKey]    Script Date: 12-03-2019 11:24:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_GetUnCommonKey]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Sudhanshu Shekhar
-- Create date: 18-Feb-2017
-- Description:	To get common IDs from two comma separated string in table
-- SELECT * FROM [dbo].[Fun_GetUnCommonKey](''1,2,3,5,7,8'', ''3,6,7'', '','')
-- SELECT * FROM [dbo].[Fun_GetUnCommonKey](''3,6,7'', ''1,2,3,5,7,8'', '','')

-- =============================================
CREATE FUNCTION [dbo].[Fun_GetUnCommonKey]
(
	@AllString varchar(MAX),
	@CheckString varchar(MAX),
	@Delimiter CHAR(1)
)
RETURNS @Output TABLE(IdentyId int Identity(1,1), SplitData int)
AS
BEGIN
	--
	DECLARE @S1 TABLE(IdVal int)
	DECLARE @S2 TABLE(IdVal int)

	INSERT INTO @S1 SELECT SplitData FROM [dbo].[Fun_SplitStringInt](@AllString, '','')
	INSERT INTO @S2 SELECT SplitData FROM [dbo].[Fun_SplitStringInt](@CheckString, '','')

	INSERT INTO @Output (SplitData) 
	SELECT T1.IdVal FROM @S1 T1 
	LEFT JOIN @S2 T2 ON T1.IdVal=T2.IdVal 
	WHERE T2.IdVal IS NULL
    
	RETURN
END





' 
END

GO
/****** Object:  StoredProcedure [dbo].[Proc_AddAppraisalSetting]    Script Date: 12-03-2019 11:24:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AddAppraisalSetting]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_AddAppraisalSetting] AS' 
END
GO
-- =============================================
-- Author:		Sudhanshu Shekhar
-- Create date: 18-Feb-2017
-- Description:	To add appriasal setting and stage details

/**
DECLARE @res tinyint, @Dupl varchar(1000)
EXEC [Proc_AddAppraisalSetting]
 @AppraisalCycleId = 8,
 @LocationId = 1,
 @VerticalId = 1,
 @DivisionIds = '1,9,11,2,3,12,13,5,7,6,8,10,4,14',
 @DepartmentIds = '35,32,17,3,1,2,4,21,31,30,7,6,5,23,16,22,8,11,34,33,29,36,24,19,13,15,25,28,18,27,9,14,12,37,20,26,10',
 @TeamIds = '7,6,74,66,55,39,45,24,34,33,5,1,61,35,51,42,57,63,36,41,16,28,64,72,21,46,50,60,44,70,68,53,4,62,22,76,52,58,56,17,30,40,25,13,11,8,15,19,32,73,2,9,14,43,12,65,37,3,49,47,59,48,67,38,31,54,23,29,10,20,18,69,71,77,75,26,27',
 @DesignationIds = '69,59,49,80,85,101,26,36,14,103,94,91,89,102,66,56,46,2,28,18,61,51,76,105,19,20,15,33,67,57,47,77,5,6,3,4,1,7,8,9,10,55,45,86',
 @StartDate = '01/01/2019',
 @EndDate = '01/04/2019',
 @StageXmlString = '<root>
  <row AppraisalStageId="1" EndDate="01/02/2019" />
  <row AppraisalStageId="2" EndDate="01/03/2019" />
  <row AppraisalStageId="3" EndDate="01/04/2019" />
</root>',
 @TransById = 4,
 @Success = @res output,
 @DuplicateNames = @Dupl output
SELECT @res AS Result, @Dupl DuplicateNames

DECLARE @res tinyint, @Dupl varchar(1000)
EXEC [Proc_AddAppraisalSetting]
 @AppraisalCycleId = 8,
 @LocationId = 1,
 @VerticalId = 1,
 @DivisionIds = '1',
 @DepartmentIds = '1,3',
 @TeamIds = '7,6,1',
 @DesignationIds = '3,4',
 @StartDate = '01/01/2019',
 @EndDate = '01/04/2019',
 @StageXmlString = '<root>
  <row AppraisalStageId="1" EndDate="01/02/2019" />
  <row AppraisalStageId="2" EndDate="01/03/2019" />
  <row AppraisalStageId="3" EndDate="01/04/2019" />
</root>',
 @TransById = 4,
 @Success = @res output,
 @DuplicateNames = @Dupl output
SELECT @res AS Result, @Dupl DuplicateNames
**/
--=============================================
ALTER PROCEDURE [dbo].[Proc_AddAppraisalSetting]
(
	@AppraisalCycleId int,
	@LocationId	int,
	@VerticalId int,  --@GroupId	int,
	@DivisionIds varchar(500),
	@DepartmentIds varchar(500),
	@TeamIds varchar(500), --@UnitIds	varchar(500),
	@DesignationIds	varchar(500),
	@StartDate	datetime,
	@EndDate	datetime,
	@StageXmlString	xml,
	@TransById	int,
	@Success	tinyint output,
	@DuplicateNames varchar(4000) output
)
AS

BEGIN TRY
	SET NOCOUNT ON;
	IF OBJECT_ID('tempdb..#TempAppraisalSetting') IS NOT NULL
	DROP TABLE #TempAppraisalSetting

	IF OBJECT_ID('tempdb..#TempAppraisalSettingStage') IS NOT NULL
	DROP TABLE #TempAppraisalSettingStage

	CREATE TABLE #TempAppraisalSetting (
		TempAppraisalSettingId INT IDENTITY(1,1), 
		DivisionId INT, 
		DepartmentId INT, 
		TeamId bigint, 
		DesignationIds varchar(500), 
		ExistingDesignationIds varchar(500), 
		IsActive BIT DEFAULT(1), 
		Duplicates varchar(max) null,
		IdsToBeAdded varchar(500), 
		IdsToBeUpdated varchar(500),
		IdsToBeDeleted varchar(500),
	)

	CREATE TABLE #TempAppraisalSettingStage(
		TempAppraisalSettingStageId INT IDENTITY(1,1),
		AppraisalStageId int,
		StartDate datetime,
		EndDate datetime
	)

	DECLARE @AppraisalMonth int, @AppraisalYear INT

	IF (@DivisionIds IS NOT NULL AND @DivisionIds <> '' AND @DepartmentIds IS NOT NULL AND @DepartmentIds <> '' AND @TeamIds IS NOT NULL AND @TeamIds <> '' AND @DesignationIds IS NOT NULL AND @DesignationIds <> '')
	BEGIN
	   --Split and Insert into Temp AppraisalSetting
		INSERT INTO #TempAppraisalSetting(DivisionId, DepartmentId, TeamId, DesignationIds)
		SELECT --@AppraisalCycleId AS AppraisalCycleId, @LocationId AS LocationId, @VerticalId AS VerticalId,
		Div.DivisionId, Dept.DepartmentID, T.TeamId,
		STUFF((SELECT ',' + CAST(GUD.DesignationId AS VARCHAR(10)) FROM Team GT
						LEFT JOIN dbo.Department GDept ON GT.DepartmentId = GDept.DepartmentId
						LEFT JOIN dbo.Division GDiv ON GDept.DivisionId = GDiv.DivisionId
						LEFT JOIN dbo.Vertical GV ON GDiv.VerticalId = GV.VerticalId
						LEFT JOIN dbo.UserTeamMapping GUTM ON GUTM.TeamId = GT.TeamId
						LEFT JOIN dbo.UserDetail GUD ON GUTM.UserId = GUD.UserId
						WHERE GT.TeamId IN (SELECT SplitData FROM Fun_SplitStringInt(@TeamIds, ','))
						AND GDept.[DepartmentId] IN (SELECT SplitData FROM Fun_SplitStringInt(@DepartmentIds, ','))
						AND GDiv.[DivisionId] IN (SELECT SplitData FROM Fun_SplitStringInt(@DivisionIds, ','))
						AND GUD.[DesignationId] IN (SELECT SplitData FROM Fun_SplitStringInt(@DesignationIds, ','))
						AND GV.[VerticalId] = @VerticalId AND GT.IsActive = 1
						AND GT.TeamId = T.TeamId
						GROUP BY GDiv.DivisionId, GDept.DepartmentID, GT.TeamId, GUD.DesignationId
		FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '') AS DesignationIds
		FROM Team T
		LEFT JOIN dbo.Department Dept ON T.DepartmentId = Dept.DepartmentId
		LEFT JOIN dbo.Division Div ON Dept.DivisionId = Div.DivisionId
		LEFT JOIN dbo.Vertical V ON Div.VerticalId = V.VerticalId
		LEFT JOIN dbo.UserTeamMapping UTM ON UTM.TeamId = T.TeamId
		LEFT JOIN dbo.UserDetail UD ON UTM.UserId = UD.UserId
		Where T.TeamId IN (SELECT SplitData FROM Fun_SplitStringInt(@TeamIds, ','))
		AND Dept.[DepartmentId] IN (SELECT SplitData FROM Fun_SplitStringInt(@DepartmentIds, ','))
		AND Div.[DivisionId] IN (SELECT SplitData FROM Fun_SplitStringInt(@DivisionIds, ','))
		AND UD.[DesignationId] IN (SELECT SplitData FROM Fun_SplitStringInt(@DesignationIds, ','))
		AND V.[VerticalId] = @VerticalId 
		AND T.IsActive = 1
		GROUP BY Div.DivisionId, Dept.DepartmentID, T.TeamId      

		UPDATE T
		SET T.ExistingDesignationIds = S.[DesignationIds],
		T.IdsToBeAdded = (SELECT STUFF((SELECT ',' + CAST([SplitData] AS VARCHAR(10)) AS DuplicateDesignation FROM [dbo].[Fun_GetUnCommonKey](T.DesignationIds, S.[DesignationIds], ',') FOR XML PATH(''), TYPE ).value('.', 'NVARCHAR(MAX)'), 1, 1, '')),
		T.IdsToBeUpdated = (SELECT STUFF((SELECT ',' + CAST([SplitData] AS VARCHAR(10)) AS DuplicateDesignation FROM [dbo].[Fun_GetCommonKey](T.DesignationIds, S.[DesignationIds], ',') FOR XML PATH(''), TYPE ).value('.', 'NVARCHAR(MAX)'), 1, 1, '')),
		T.IdsToBeDeleted = (SELECT STUFF((SELECT ',' + CAST([SplitData] AS VARCHAR(10)) AS DuplicateDesignation FROM [dbo].[Fun_GetUnCommonKey](S.[DesignationIds], T.DesignationIds, ',') FOR XML PATH(''), TYPE ).value('.', 'NVARCHAR(MAX)'), 1, 1, ''))
		FROM [dbo].[AppraisalSetting] S 
		INNER JOIN #TempAppraisalSetting T ON ( S.AppraisalCycleId = @AppraisalCycleId
												AND S.LocationId = @LocationId
												AND S.[VerticalId] = @VerticalId
												AND S.[DivisionId] = T.[DivisionId]
												AND S.[DepartmentId] = T.[DepartmentId]
												AND S.[TeamId] = T.[TeamId])
      SELECT * FROM #TempAppraisalSetting where IsActive=1 --AND ExistingDesignationIds IS NOT NULL
      INSERT INTO #TempAppraisalSettingStage( AppraisalStageId, EndDate)
	   SELECT T.Item.value('@AppraisalStageId', 'int'),
		      T.Item.value('@EndDate', 'varchar(25)')
	   FROM @StageXmlString.nodes('/root/row') AS T(Item)
		            
	   --Compute start date for each stage
	   UPDATE T
	   SET T.StartDate = (CASE WHEN A.SequenceNo=1 THEN @StartDate ELSE (SELECT ST.EndDate+1 FROM #TempAppraisalSettingStage ST 
					      INNER JOIN AppraisalStage ASM ON ST.AppraisalStageId=ASM.AppraisalStageId WHERE ASM.SequenceNo=A.SequenceNo-1) END)
	   FROM #TempAppraisalSettingStage T INNER JOIN AppraisalStage A ON T.AppraisalStageId=A.AppraisalStageId

	    SELECT * FROM #TempAppraisalSettingStage 
	   -------------------------------------------NEW INSERTION---------------------------------------------------
	  ----insert into AppraisalSetting
		      INSERT INTO AppraisalSetting(AppraisalCycleId, LocationId, VerticalId, DivisionId, DepartmentId, TeamId, DesignationIds, StartDate, EndDate, IsActive, CreatedDate, CreatedById)
		      SELECT @AppraisalCycleId, @LocationId, @VerticalId, T.DivisionId, T.DepartmentId, T.TeamId, T.DesignationIds, @StartDate, @EndDate, 1, GETDATE(), @TransById
		      FROM #TempAppraisalSetting T WHERE T.ExistingDesignationIds IS NULL
			 ----insert into AppraisalSettingDesignation
		     INSERT INTO AppraisalSettingDesignation(AppraisalSettingId, DesignationId, CreatedById)
	         SELECT S.[AppraisalSettingId], D.SplitData AS DesignationId, @TransById
	         FROM AppraisalSetting S
			 INNER JOIN #TempAppraisalSetting T ON ( S.AppraisalCycleId = @AppraisalCycleId
												AND S.LocationId = @LocationId
												AND S.[VerticalId] = @VerticalId
												AND S.[DivisionId] = T.[DivisionId]
												AND S.[DepartmentId] = T.[DepartmentId]
												AND S.[TeamId] = T.[TeamId]
												AND S.[DesignationIds]=T.[DesignationIds] COLLATE SQL_Latin1_General_CP1_CI_AS) 
		     CROSS APPLY dbo.Fun_SplitStringInt(S.[DesignationIds], ',') D --@DesignationIds
             WHERE T.ExistingDesignationIds IS NULL
            ----insert into AppraisalSettingStage
            INSERT INTO AppraisalSettingStage(AppraisalSettingId, AppraisalStageId, StartDate, EndDate, CreatedById)
		      SELECT S.[AppraisalSettingId], TS.AppraisalStageId, TS.StartDate, TS.EndDate, @TransById
		      FROM AppraisalSetting S
			  INNER JOIN #TempAppraisalSetting T ON ( S.AppraisalCycleId = @AppraisalCycleId
												AND S.LocationId = @LocationId
												AND S.[VerticalId] = @VerticalId
												AND S.[DivisionId] = T.[DivisionId]
												AND S.[DepartmentId] = T.[DepartmentId]
												AND S.[TeamId] = T.[TeamId]
												AND S.[DesignationIds]=T.[DesignationIds] COLLATE SQL_Latin1_General_CP1_CI_AS) 
			 CROSS JOIN #TempAppraisalSettingStage TS
			 WHERE T.ExistingDesignationIds IS NULL
			
			  ----------------------------------------EXISTING INSERT/UPDATE--------------------------------
                                  ----------------FOR IDS TO BE UPDATED--------------
                                   ----------------in appraisal setting------------
		UPDATE S
		SET S.ModifiedDate = Getdate(), S.ModifiedById = @TransById
		FROM [dbo].[AppraisalSetting] S 
		INNER JOIN #TempAppraisalSetting T ON ( S.AppraisalCycleId = @AppraisalCycleId
												AND S.LocationId = @LocationId
												AND S.[VerticalId] = @VerticalId
												AND S.[DivisionId] = T.[DivisionId]
												AND S.[DepartmentId] = T.[DepartmentId]
												AND S.[TeamId] = T.[TeamId]
												AND S.[DesignationIds]=T.[ExistingDesignationIds] COLLATE SQL_Latin1_General_CP1_CI_AS) WHERE T.ExistingDesignationIds IS NOT NULL AND T.[IdsToBeUpdated] IS NOT NULL
                                  ----------------in appraisal setting designation---------------------
		UPDATE A
		SET A.ModifiedDate = Getdate(), A.ModifiedById = @TransById
        FROM AppraisalSettingDesignation A
		INNER JOIN [dbo].[AppraisalSetting] S ON S.[AppraisalSettingId]=A.[AppraisalSettingId]
		INNER JOIN #TempAppraisalSetting T ON ( S.AppraisalCycleId = @AppraisalCycleId
												AND S.LocationId = @LocationId
												AND S.[VerticalId] = @VerticalId
												AND S.[DivisionId] = T.[DivisionId]
												AND S.[DepartmentId] = T.[DepartmentId]
												AND S.[TeamId] = T.[TeamId]
												AND S.[DesignationIds]=T.[ExistingDesignationIds] COLLATE SQL_Latin1_General_CP1_CI_AS)
        WHERE A.[DesignationId] IN (SELECT SplitData FROM dbo.Fun_SplitStringInt(T.[IdsToBeUpdated], ',')) AND T.ExistingDesignationIds IS NOT NULL AND T.[IdsToBeUpdated] IS NOT NULL
                               ------------------------in appraisal setting stage-----------------
		UPDATE ASD
		SET ASD.ModifiedDate = Getdate(), ASD.ModifiedById = @TransById
        FROM AppraisalSettingStage ASD
		INNER JOIN [dbo].[AppraisalSetting] S ON S.[AppraisalSettingId]=ASD.[AppraisalSettingId]
		INNER JOIN #TempAppraisalSetting T ON ( S.AppraisalCycleId = @AppraisalCycleId
												AND S.LocationId = @LocationId
												AND S.[VerticalId] = @VerticalId
												AND S.[DivisionId] = T.[DivisionId]
												AND S.[DepartmentId] = T.[DepartmentId]
												AND S.[TeamId] = T.[TeamId]
												AND S.[DesignationIds]=T.[ExistingDesignationIds] COLLATE SQL_Latin1_General_CP1_CI_AS)
		WHERE T.ExistingDesignationIds IS NOT NULL AND T.[IdsToBeUpdated] IS NOT NULL
	                                       ------------FOR IDS TO BE DEACTIVATED--------------------
										   ----------------in appraisal setting------------
	UPDATE ST
		SET ST.ModifiedDate = Getdate(), ST.ModifiedById = @TransById
		FROM [dbo].[AppraisalSetting] ST 
		INNER JOIN #TempAppraisalSetting T ON ( ST.AppraisalCycleId = @AppraisalCycleId
												AND ST.LocationId = @LocationId
												AND ST.[VerticalId] = @VerticalId
												AND ST.[DivisionId] = T.[DivisionId]
												AND ST.[DepartmentId] = T.[DepartmentId]
												AND ST.[TeamId] = T.[TeamId]
												AND ST.[DesignationIds]=T.[ExistingDesignationIds] COLLATE SQL_Latin1_General_CP1_CI_AS) WHERE T.ExistingDesignationIds IS NOT NULL AND T.[IdsToBeDeleted] IS NOT NULL
						                  ----------------in appraisal setting designation---------------------
		UPDATE A
		SET A.ModifiedDate = Getdate(), A.ModifiedById = @TransById, A.[IsActive]=0
        FROM AppraisalSettingDesignation A
		INNER JOIN [dbo].[AppraisalSetting] S ON S.[AppraisalSettingId]=A.[AppraisalSettingId]
		INNER JOIN #TempAppraisalSetting T ON ( S.AppraisalCycleId = @AppraisalCycleId
												AND S.LocationId = @LocationId
												AND S.[VerticalId] = @VerticalId
												AND S.[DivisionId] = T.[DivisionId]
												AND S.[DepartmentId] = T.[DepartmentId]
												AND S.[TeamId] = T.[TeamId]
												AND S.[DesignationIds]=T.[ExistingDesignationIds] COLLATE SQL_Latin1_General_CP1_CI_AS)
        WHERE A.[DesignationId] IN (SELECT SplitData FROM dbo.Fun_SplitStringInt(T.[IdsToBeDeleted], ',')) AND T.ExistingDesignationIds IS NOT NULL AND T.[IdsToBeDeleted] IS NOT NULL
		                           ------------------------in appraisal setting stage-----------------
		UPDATE ASD
		SET ASD.ModifiedDate = Getdate(), ASD.ModifiedById = @TransById
        FROM AppraisalSettingStage ASD
		INNER JOIN [dbo].[AppraisalSetting] S ON S.[AppraisalSettingId]=ASD.[AppraisalSettingId]
		INNER JOIN #TempAppraisalSetting T ON ( S.AppraisalCycleId = @AppraisalCycleId
												AND S.LocationId = @LocationId
												AND S.[VerticalId] = @VerticalId
												AND S.[DivisionId] = T.[DivisionId]
												AND S.[DepartmentId] = T.[DepartmentId]
												AND S.[TeamId] = T.[TeamId]
												AND S.[DesignationIds]=T.[ExistingDesignationIds] COLLATE SQL_Latin1_General_CP1_CI_AS)
		WHERE T.ExistingDesignationIds IS NOT NULL AND T.[IdsToBeDeleted] IS NOT NULL
	------------FOR IDS TO BE INSERTED------------------------
 ----insert into AppraisalSetting
		      INSERT INTO AppraisalSetting(AppraisalCycleId, LocationId, VerticalId, DivisionId, DepartmentId, TeamId, DesignationIds, StartDate, EndDate, IsActive, CreatedDate, CreatedById)
		      SELECT @AppraisalCycleId, @LocationId, @VerticalId, T.DivisionId, T.DepartmentId, T.TeamId, T.[IdsToBeAdded], @StartDate, @EndDate, 1, GETDATE(), @TransById
		      FROM #TempAppraisalSetting T WHERE T.ExistingDesignationIds IS NOT NULL AND T.[IdsToBeAdded] IS NOT NULL
----insert into AppraisalSettingDesignation
           INSERT INTO AppraisalSettingDesignation(AppraisalSettingId, DesignationId, CreatedById)
	         SELECT S.[AppraisalSettingId], D.SplitData AS DesignationId, @TransById
	         FROM AppraisalSetting S
			 INNER JOIN #TempAppraisalSetting T ON ( S.AppraisalCycleId = @AppraisalCycleId
												AND S.LocationId = @LocationId
												AND S.[VerticalId] = @VerticalId
												AND S.[DivisionId] = T.[DivisionId]
												AND S.[DepartmentId] = T.[DepartmentId]
												AND S.[TeamId] = T.[TeamId]
												AND S.[DesignationIds]=T.[IdsToBeAdded] COLLATE SQL_Latin1_General_CP1_CI_AS) 
	         CROSS APPLY dbo.Fun_SplitStringInt(S.DesignationIds, ',') D --@DesignationIds
             WHERE T.ExistingDesignationIds IS NOT NULL AND T.[IdsToBeAdded] IS NOT NULL

            ----insert into AppraisalSettingStage
     INSERT INTO AppraisalSettingStage(AppraisalSettingId, AppraisalStageId, StartDate, EndDate, CreatedById)
		      SELECT S.[AppraisalSettingId], TS.AppraisalStageId, TS.StartDate, TS.EndDate, @TransById
		      FROM AppraisalSetting S
			  INNER JOIN #TempAppraisalSetting T ON ( S.AppraisalCycleId = @AppraisalCycleId
												AND S.LocationId = @LocationId
												AND S.[VerticalId] = @VerticalId
												AND S.[DivisionId] = T.[DivisionId]
												AND S.[DepartmentId] = T.[DepartmentId]
												AND S.[TeamId] = T.[TeamId]
												AND S.[DesignationIds]=T.[IdsToBeAdded] COLLATE SQL_Latin1_General_CP1_CI_AS) 
			 CROSS JOIN #TempAppraisalSettingStage TS
			 WHERE T.ExistingDesignationIds IS NOT NULL AND T.[IdsToBeAdded] IS NOT NULL
			 SET @Success = 1
	 END
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
	BEGIN
		SET @Success = 0
		ROLLBACK TRANSACTION

		DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))
		EXEC [spInsertErrorLog]
			 @ModuleName = 'AppraisalManagement'
			,@Source = 'Proc_AddAppraisalSetting'
			,@ErrorMessage = @ErrorMessage
			,@ErrorType = 'SP'
			,@ReportedByUserId = @TransById
	END
END CATCH


GO
