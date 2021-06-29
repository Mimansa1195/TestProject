using MIS.BO;
using System.Configuration;
using System.Net.Mail;

namespace MIS.Utilities
{
    public sealed class MailSettings : ConfigurationSection
    {
        public MailerBO MailInformation;

        [ConfigurationProperty("SenderEmailAddress", IsRequired = true)]
        public string SenderEmailAddress
        {
            get { return (string)this["SenderEmailAddress"]; }
            set { this["SenderEmailAddress"] = value; }
        }

        [ConfigurationProperty("SenderPassword", IsRequired = true)]
        public string SenderPassword
        {
            get { return (string)this["SenderPassword"]; }
            set { this["SenderPassword"] = value; }
        }

        [ConfigurationProperty("SenderDisplayName", IsRequired = true)]
        public string SenderDisplayName
        {
            get { return (string)this["SenderDisplayName"]; }
            set { this["SenderDisplayName"] = value; }
        }

        [ConfigurationProperty("SenderSmtpHost", IsRequired = true)]
        public string SenderSmtpHost
        {
            get { return (string)this["SenderSmtpHost"]; }
            set { this["SenderSmtpHost"] = value; }
        }

        [ConfigurationProperty("SenderPort", IsRequired = true)]
        public int SenderPort
        {
            get { return (int)this["SenderPort"]; }
            set { this["SenderPort"] = value; }
        }

        [ConfigurationProperty("IsSslRequired", IsRequired = true)]
        public bool IsSslRequired
        {
            get { return (bool)this["IsSslRequired"]; }
            set { this["IsSslRequired"] = value; }
        }

        [ConfigurationProperty("IsUseDefaultCredentials", IsRequired = true)]
        public bool IsUseDefaultCredentials
        {
            get { return (bool)this["IsUseDefaultCredentials"]; }
            set { this["IsUseDefaultCredentials"] = value; }
        }

        [ConfigurationProperty("SuccessMessage", IsRequired = true)]
        public string SuccessMessage
        {
            get { return (string)this["SuccessMessage"]; }
            set { this["SuccessMessage"] = value; }
        }

        [ConfigurationProperty("RecipientAddress", IsRequired = true)]
        public string RecipientAddress
        {
            get { return (string)this["RecipientAddress"]; }
            set { this["RecipientAddress"] = value; }
        }

        [ConfigurationProperty("RecipientDisplayName", IsRequired = true)]
        public string RecipientDisplayName
        {
            get { return (string)this["RecipientDisplayName"]; }
            set { this["RecipientDisplayName"] = value; }
        }

        [ConfigurationProperty("MailSendingPriority", IsRequired = true)]
        public MailPriority MailSendingPriority
        {
            get { return (MailPriority)this["MailSendingPriority"]; }
            set { this["MailSendingPriority"] = value; }
        }

        [ConfigurationProperty("MailSubject", IsRequired = true)]
        public string MailSubject
        {
            get { return (string)this["MailSubject"]; }
            set { this["MailSubject"] = value; }
        }

        public string MailBody
        {
            get
            {
                return string.Format("Hello {0}," +
                                   "<br/>You have been successfully registered with {1}  <br/>" +
                                   "<br/>Your username & password are as" +
                                   "<br/>UserName:{2}" + "<br/>Password:{3}" +
                                   "<br/><br/>Regards." +
                                   "<br/>This is an auto generated mail, please do not reply to this mail.",
                                   MailInformation.RecipientName, MailInformation.CompanyName,
                                   MailInformation.RecipientUserName, MailInformation.RecipientPassword);
            }
        }
    }

    public class MailResponse
    {
        public bool IsMailSent { get; set; }
        public string ErrorMessage { get; set; }
    }
}
