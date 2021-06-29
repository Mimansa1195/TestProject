
/***
   Created Date      :     2016-09-27
   Created By        :     Shubhra Upadhyay
   Purpose           :     This stored proc is used to add new access cardtus
   Change History    :
   --------------------------------------------------------------------------
   Modify Date       Edited By           Change Description
   2018-05-04        kanchan kumari       for staff access card mapping
   --------------------------------------------------------------------------
   --------------------------------------------------------------------------
   Test Cases        :
   --------------------------------------------------------------------------
        DECLARE @Result int
		EXEC [dbo].[Proc_VerifyUserRegDetails]
		 @RegistrationId=543
	    ,@accessCardId = 284
        ,@userId = 4
        ,@IsPimcoUserCardMapping = 0
        ,@createdBy = 2167
		,@IsStaff = 0
		,@fromDate='2018-05-14'
		,@success=@Result output
		SELECT @Result AS RESULT
		
***/
CREATE Proc Proc_VerifyUserRegDetails
  (
    @RegistrationId bigint,
	@AccessCardId int,
	@UserId int,
	@IsPimcoUserCardMapping bit,
	@CreatedBy [int],
	@IsStaff  bit,
	@FromDate date,
	@success tinyint output
  )
  AS
  BEGIN TRY
     SET NOCOUNT ON;

	   DECLARE @result int;
	   EXEC [dbo].[spAddUserAccessCardMapping] @AccessCardId,@UserId,@IsPimcoUserCardMapping,@CreatedBy,@IsStaff,@FromDate,@result OUTPUT
	   
	   BEGIN TRANSACTION;
	   IF(@result=1)
	   BEGIN
	       UPDATE  [UserAccessCard] SET IsFinalised=1 WHERE UserId=@UserId
	       DELETE FROM [dbo].[TempUserAddressDetail] WHERE [RegistrationId] = @RegistrationId
           DELETE FROM [dbo].[TempUserRegistration]  WHERE [RegistrationId] = @RegistrationId
		   
		   SET @success=@result 
	   END
	  ELSE 
	  BEGIN
	  SET @success=@result
	  END
	    COMMIT;
 END TRY
     BEGIN CATCH
	 IF(@@TRANCOUNT>0)
	 BEGIN
        ROLLBACK TRANSACTION;
	 END
    DECLARE  @ErrorMessage varchar(max) = ('Ms Sql Server Error occured at: ' + CONVERT(VARCHAR(20), ISNULL(ERROR_LINE(), 0)) + '. Error message: - ' + ISNULL(ERROR_MESSAGE(), 'NA'))
	 SET @Success=0;
    EXEC [spInsertErrorLog]
	     @ModuleName = 'ManageUser'
        ,@Source = 'Proc_VerifyUserRegDetails'
        ,@ErrorMessage = @ErrorMessage
        ,@ErrorType = 'SP'
        ,@ReportedByUserId = @CreatedBy

		 SET @success=0
   END CATCH


 
