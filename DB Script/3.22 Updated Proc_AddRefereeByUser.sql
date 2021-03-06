USE [MIS]
GO
/****** Object:  StoredProcedure [dbo].[Proc_AddRefereeByUser]    Script Date: 21-08-2018 18:37:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AddRefereeByUser]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AddRefereeByUser]
GO
/****** Object:  StoredProcedure [dbo].[Proc_AddRefereeByUser]    Script Date: 21-08-2018 18:37:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AddRefereeByUser]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Proc_AddRefereeByUser] AS' 
END
GO
/***
   Created Date      :     2018-07-30
   Created By        :     Mimansa Agrawal
   Purpose           :     This procedure adds persons referred by any user for job openings
   
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   
   --------------------------------------------------------------------------

   Test Cases        :
   --------------------------------------------------------------------------
  
DECLARE @Result int
EXEC [dbo].[Proc_AddRefereeByUser]
    @ReferralId=1 
   ,@RefereeName='abc' 
   ,@Relation='pqr'
   ,@Resume='abc.pdf'
   ,@UserId=2434
   ,@Success = @Result output
SELECT @Result AS [RESULT]
***/
ALTER PROCEDURE [dbo].[Proc_AddRefereeByUser]
(
    @ReferralId int 
   ,@RefereeName varchar(100)  
   ,@Relation varchar(100)
   ,@Resume varchar(500)
   ,@UserId int
   ,@Success TINYINT = 0 OUTPUT
) 
AS
BEGIN
SET NOCOUNT ON;
	BEGIN TRY
      BEGIN TRANSACTION
	  
         INSERT INTO 
            [dbo].[ReferralDetail]
            ([ReferralId],[RefereeName],[RelationWithReferee],[Resume],[ReferredById])
         SELECT @ReferralId,@RefereeName,@Relation,@Resume,@UserId
               SET @Success=1 -------------------------added successfully
      COMMIT TRANSACTION
   END TRY
   BEGIN CATCH
         ROLLBACK TRANSACTION
         DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))

         EXEC [spInsertErrorLog]
	            @ModuleName = 'Referral'
            ,@Source = 'Proc_AddRefereeByUser'
            ,@ErrorMessage = @ErrorMessage
            ,@ErrorType = 'SP'
            ,@ReportedByUserId = @UserId        

           SET @Success=0 ----------------------error
         
      END CATCH 
END




GO
