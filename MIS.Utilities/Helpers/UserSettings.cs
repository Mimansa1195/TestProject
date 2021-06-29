using System.Configuration;

namespace MIS.Utilities
{
    public sealed class UserSettings : ConfigurationSection
    {
        [ConfigurationProperty("EmployeeIdPrefix", IsRequired = true)]
        public string EmployeeIdPrefix
        {
            get { return (string)this["EmployeeIdPrefix"]; }
            set { this["EmployeeIdPrefix"] = value; }
        }

        [ConfigurationProperty("EmployeeIdStartSuffix", IsRequired = true)]
        public string EmployeeIdStartSuffix
        {
            get { return (string)this["EmployeeIdStartSuffix"]; }
            set { this["EmployeeIdStartSuffix"] = value; }
        }
    }
}
