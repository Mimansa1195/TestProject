$(document).ready(function () {
    bindSkillLevelDropDown("#ddlSkillLevel", 0);
    bindSkillDropDown("#ddlSkills", 0);
    bindSkillTypeDropDown("#ddlSkillType", 0);
    $("#ddlSkills").select2();
});

function bindSkillLevelDropDown(ControlId, SelectedId) {
    $(ControlId).empty();
    $(ControlId).append($("<option></option>").val(0).html("Select"));
    calltoAjax(misApiUrl.listSkillLevel, "POST", '',
       function (result) {
           $.each(result, function (idx, item) {
               $(ControlId).append($("<option></option>").val(item.Value).html(item.Text));
           });
           if (SelectedId > 0) {
               $(ControlId).val(SelectedId)
           }
       });
}

function bindSkillDropDown(ControlId, SelectedId) {
    $(ControlId).empty();
    $(ControlId).append($("<option></option>").val(0).html("Select"));
    calltoAjax(misApiUrl.listSkill, "POST", '',
      function (result) {
          $.each(result, function (idx, item) {
                $(ControlId).append($("<option></option>").val(item.Value).html(item.Text));
            });
            if (SelectedId > 0) {
                $(ControlId).val(SelectedId)
            }
    });
}

function bindSkillTypeDropDown(ControlId, SelectedId) {
    $(ControlId).empty();
    $(ControlId).append($("<option></option>").val(0).html("Select"));
    calltoAjax(misApiUrl.listSkillTypesForUser, "POST", '',
      function (result) {
          $.each(result, function (idx, item) {
              $(ControlId).append($("<option></option>").val(item.Value).html(item.Text));
          });
          if (SelectedId > 0) {
              $(ControlId).val(SelectedId)
          }
      });
}

$("#btnSaveSkills").click(function () {
    var url = window.location.pathname.split("/");
    var controllerName = url[1];
    var actionName = url[1];

    if (!validateControls('skillsdiv')) {
        return false;
    }
    var jsonObject = {
        'SkillId': $("#ddlSkills").val(),
        'SkillLevelId': $("#ddlSkillLevel").val(),
        'ExperienceMonths': $("#expinMonths").val(),
        'SkillTypeId': $("#ddlSkillType").val(),
        'UserAbrhs': misSession.userabrhs
    };
    calltoAjax(misApiUrl.addSkills, "POST", jsonObject,
        function (result) {
            if (result == 1) {
                misAlert("Skills has been saved successfully.", 'Success', 'success');
                $("#mypopupUpdateSkills").modal("hide");
                if (controllerName == 'Dashboard' && actionName == 'Index') {
                    getSkills();
                }
            }
           else if (result == 2) {
                misAlert("Duplicate Skills not Allowed.", 'Warning', 'warning');
           }
           else {
               misAlert("Unauthorized Access !", 'Warning', 'warning');
               //misAlert("Don't be smart ! Do some meaningful work.", 'Warning', 'warning');
           }
        });
});

$("#btnskillsClose").click(function () {
    $("#mypopupUpdateSkills").modal("hide");
});