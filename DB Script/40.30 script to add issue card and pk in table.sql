------for adding pk in table----------------
alter table [TempCardIssueDetail] add primary key (IssueId)
-------------------------------
GO
/****** Object:  StoredProcedure [dbo].[Proc_AddIssueCardDetails]    Script Date: 01-03-2019 18:54:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***
   Created Date      :     2019-03-01
   Created By        :     Mimansa Agrawal
   Purpose           :     This stored proc is used to add new issued card details
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By            Change Description
   --------------------------------------------------------------------------
   
   --------------------------------------------------------------------------
	DECLARE @Result int
		EXEC [dbo].[Proc_AddIssueCardDetails]
		@EmployeeId=' Mapping' ,
		@AccessCardId= 'Card Mapping',
		@IssueDate='Card',
		@ReturnDate= 1,
		@Reason= 'Hour',
		@IsReturn=1,
		@UserId = ,
		@Success = @Result output
	SELECT @Result AS [RESULT]
***/
CREATE PROCEDURE [dbo].[Proc_AddIssueCardDetails]
(
	    @EmployeeId INT,
		@AccessCardId INT,
		@IssueDate DATETIME,
		@ReturnDate DATETIME,
		@Reason VARCHAR(200),
		@IsReturn BIT,
		@UserId INT,
	    @Success tinyint = 0 OUTPUT
)
AS
BEGIN TRY
	SET NOCOUNT ON;
			BEGIN TRANSACTION;
				INSERT INTO [dbo].[TempCardIssueDetail]([EmployeeId],[AccessCardId],[IssueDate],[ReturnDate],[Reason],[IsReturn])
				SELECT @EmployeeId,@AccessCardId ,@IssueDate,@ReturnDate,@Reason,@IsReturn
			COMMIT TRANSACTION;
			SET @Success= 1;
END TRY
BEGIN CATCH
	--On Error
	IF @@TRANCOUNT > 0
	 ROLLBACK TRANSACTION;
     SET @Success = 0; -- Error occurred
	 DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))
	 --Log Error
	 EXEC [spInsertErrorLog]
			 @ModuleName = 'Reports'
			,@Source = 'Proc_AddIssueCardDetails'
			,@ErrorMessage = @ErrorMessage
			,@ErrorType = 'SP'
			,@ReportedByUserId = @UserId
END CATCH
GO
