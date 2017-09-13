
    $(function () {

          $("#item_panels").accordion({
			  hide: true,
              heightStyle: "content",
              collapsible: true,
              active: false,
              icons: true,
              activate: function (event, ui) {
                  var scrollTop = $("#item_panels").scrollTop();
                  var top = $(ui.newHeader).offset().top;
                  $("#item_panels").scrollTop(scrollTop + top - 200);
              },
              beforeActivate: function (event, ui) {
                  // The accordion believes a panel is being opened
                  if (ui.newHeader[0]) {
                      var currHeader = ui.newHeader;
                      var currContent = currHeader.next('.ui-accordion-content');
                      // The accordion believes a panel is being closed
                  } else {
                      var currHeader = ui.oldHeader;
                      var currContent = currHeader.next('.ui-accordion-content');
                  }
                  // Since we've changed the default behavior, this detects the actual status
                  var isPanelSelected = currHeader.attr('aria-selected') == 'true';

                  // Toggle the panel's header
                  currHeader.toggleClass('ui-corner-all', isPanelSelected).toggleClass('accordion-header-active ui-state-active ui-corner-top', !isPanelSelected).attr('aria-selected', ((!isPanelSelected).toString()));

                  // Toggle the panel's icon
                  //currHeader.children('.ui-icon').toggleClass('ui-icon-caret-1-s', isPanelSelected).toggleClass('ui-icon-caret-1-n', !isPanelSelected);

                  // Toggle the panel's content
                  currContent.toggleClass('accordion-content-active', !isPanelSelected)
                  if (isPanelSelected) {
                      currContent.slideUp();
                  } else {
                      currContent.slideDown();
                  }
                  $("td").addClass("sos-temp-padding");
                  setTimeout(function() {
                      $("td").removeClass("sos-temp-padding");
                  }, 500);

                  return false; // Cancel the default action
              }

          });
      });

  'use strict';

  var Field = function(qorder, id, text, subsection, desc, image, type, enabled) {
    this.qorder = qorder || ($('[id^=row_'+type+']').length + 1);
    this.id = id;
    this.text = text;
    this.subsection = subsection;
    this.desc = desc;
    this.image = image;
    this.enabled = enabled ? enabled : false;
    this.type = type;
  }

  var FrmField = function(fid, fincrementid, forder, fdisplayname, ftype, frequired, foptions, fchecked) {
    this.fid = fid;
    this.fincrementid = fincrementid;
    this.forder = forder;
    this.fdisplayname = fdisplayname;
    this.ftype = ftype;
    this.frequired = frequired;
    this.foptions = foptions;
    this.fchecked = fchecked;
  }

  Field.prototype.edit = function(qorder, text, subsection, desc, image) {
    this.qorder = newField.qorder;
    this.text = newField.text;
    this.subsection = newField.subsection;
    this.desc = newField.desc;
    this.image = newField.image;
    this.type = newField.type;
  }

  var FieldController = (function(){
    var _FieldData = [];

    var initFieldData = function initFieldData(data) {
      for (var i=0; i < data.length; i++) {
        _FieldData.push(new Field(data[i].qorder, data[i].id, data[i].text, data[i].subsection, data[i].description, data[i].imagePath, data[i].type));
      }
    };

    var editField = function editField(qorder, id, text, subsection, desc, image, type) {
      var oldField;
      for (var i=0; i < _FieldData.length; i++) {
        if (_FieldData[i].id === id) {
          oldField = _FieldData[i];
          break;
        }
      }
      if (oldField) {
        oldField.edit(qorder, text, subsection, desc, image);
      }
    };

    var enableFieldFields = function enableFieldFields(id, type) {
      $('.row-editable').find('.form-control').each(function() {
			if($(this).closest("#sos-table-fields").length === 0) {
				$(this).attr('disabled', true);
				if($(this).hasClass('sos-admin-subsection')) {
					$(this).addClass('hidden');
				}
			}
      });
      $('.row-editable').removeClass('row-editable').addClass('row-readonly');
	
	var newSelectedFieldValues = [];
	$("input[id^='subsection_']").each(function(){
		var val = $(this).val().trim();
		if(val.length > 0) {
			newSelectedFieldValues.push(val);
		}
	});

      var currentTarget = $(event.target).closest("tr");
      currentTarget.addClass('row-editable').removeClass('row-readonly');

	  var newSelectedFieldValues1 = $.unique(newSelectedFieldValues),
		ddEle = $('.row-editable #sos-subsection-dropdown-' + id);

	ddEle.children().remove();
	$.each(newSelectedFieldValues1, function( index, value ) {
		ddEle.append($('<option>', {
			value: value,
			text: value
		}));
	});
	var defVal = $("#subsection_" + id).val().trim();
	if(defVal.length > 0) {
		$('#sos-subsection-dropdown-' + id).val(defVal);
	}

	$('#sos-subsection-dropdown-' + id).ready(function() {
		$('#sos-subsection-dropdown-' + id).selectpicker();
	});

      currentTarget.find('.form-control').each(function() {
        $(this).attr('disabled', false);
        if($(this).hasClass('sos-admin-subsection')) {
			$(this).removeClass('hidden');
		}
      });
    };

    var addField = function addField(type) {
      var newField = new Field("", -1, "", "", "", "", type, true);
      _FieldData.push(newField);
      return newField;
    };

    var deleteField = function deleteField(id, type) {
      var index = -1;
      for (var i=0; i < _FieldData.length; i++) {
        if (_FieldData[i].id === id + '') {
          index = i;
          break;
        }
      }
      if (index !== -1) {
        _FieldData.splice(index, 1);

		var currRow = $('#row_'+type+'_'+id),
			nextAllRows = $('#row_'+type+'_'+id).nextAll();
			nextAllRows.each(function(){
				var currRow = $(this);
				    currRowQorder = currRow.find(".sos-qorder"),
				    currRowQorderLabel = currRow.find(".sos-qorder-label"),
					currRowUpdateQorder = parseInt(currRow.find(".sos-qorder").val()) - 1;
				//console.log(currRowUpdateQorder);
				currRowQorder.val(currRowUpdateQorder);
				currRowQorderLabel.html(currRowUpdateQorder);
			});


        $('#row_'+type+'_'+id).remove();
      } else {
        $(event.target).closest("tr").remove();
      };
    }

    var getFields = function getFields() {
      return _FieldData;
    }

    return {
      count: 1,
      initFieldData: initFieldData,
      editField: editField,
      addField: addField,
      deleteField: deleteField,
      getFields: getFields,
      enableFieldFields: enableFieldFields
    }
  })();

  var FieldView = (function() {

    var FieldTemplate = '<tr id="row_%type%_%id%" class="row-readonly">\
        <td><span class="sos-qorder-label">%qorder%</span>\
		<input class="sos-qorder sos-qorder-%id%" type="hidden" data-qorder="%qorder%" value="%qorder%"></td>\
        <td>\
           <input type="text" class="form-control sos-input sos-input-question" data-section="%type%" data-id="%id%" value="%text%" title="%text%" name="text%id%" id="text_%id%" %disabled% placeholder="Enter question">\
        </td>\
        <td>\
           <input type="text" class="form-control sos-input sos-subsection-%id%" data-section="%type%" data-id="subsection%id%" value="%subsection%" title="%text%" name="subsection%id%" id="subsection_%id%" %disabled% placeholder="Enter subsection">\
			<select class="form-control %hidden% sos-admin-subsection" name="sos-subsection-dropdown" id="sos-subsection-dropdown-%id%" onchange="FieldView.changeSubsectionValue(%id%)" value="%subsection%">\
			</select>\
        </td>\
        <td>\
          <textarea placeholder="Enter description" class="form-control admin-textarea sos-input-desc-%id%"  %disabled% name="desc%id%" id="desc_%id%">%desc%</textarea>\
        </td>\
        <td><img src="%img%" id="sos-img-%id%" class="img_size">\
        <input type="file" id="file%id%" class="file-input sos-input-file-%id%" name="file_%type%_%id%">\
        </td>\
        <td>\
          <i title="Edit" class="sos-edit-icon fa fa-pencil fa-lg editItem-%id%" id="editItem-%id%" data-type="%type%" onclick="FieldView.enableFieldFields(%id%);FieldView.editedField(%id%)"></i>\
          <i title="Delete" class="sos-delete-icon fa fa-trash-o fa-lg" id="deleteItem-%id%" data-type="%type%" onclick="FieldView.deleteField(%id%)"></i>\
        </td>\
        <td>\
		  <input type="hidden" value="%order%" id="order_%id%">\
          <i title="Up" class="sos-order-direction sos-up-icon fa fa-arrow-up fa-lg" id="up-%id%" data-type="%type%" onclick="FieldView.upField(%id%)"></i>\
          <i title="Down" class="sos-order-direction sos-down-icon fa fa-arrow-down fa-lg" id="down-%id%" data-type="%type%" onclick="FieldView.downField(%id%)"></i>\
        </td>\
      </tr>';

    //var $tbody = document.querySelector('tbody');

    var generateHTML = function generateHTML(Field) {
      return FieldTemplate.replace(/%qorder%/g, Field.qorder)
		          .replace(/%id%/g, Field.id)
                  .replace(/%text%/g, Field.text)
                  .replace(/%subsection%/g, Field.subsection)
                  .replace(/%desc%/g, Field.desc)
                  .replace(/%img%/g, Field.image)
                  .replace(/%type%/g, Field.type)
                  .replace(/%disabled%/g, Field.enabled ? '': 'disabled')
                  .replace(/%hidden%/g, Field.enabled ? '': 'hidden');
    };

    var render = function render(emp) {
      var Fields = emp ? emp : FieldController.getFields(),
          innerHTML = '';
      Fields.forEach(function(Field) {
        var $tbody = document.querySelector('#'+Field.type+' tbody');
        innerHTML = generateHTML(Field);
        $($tbody).append(innerHTML);
      });
	  var idx = $(".editItem--1").length - 1;
	  if(idx >= 0) {		
		$(".editItem--1")[idx].click();
	  }
    };

	var upField = function upField(id) {
      var currRow = $(event.target).closest("tr"),
		  prevRow = currRow.prev();
      if(prevRow.length > 0) {
		var preOrder = prevRow.find(".sos-qorder").val(),
			curOrder = currRow.find(".sos-qorder").val();
		currRow.find(".sos-qorder").val(preOrder);
		currRow.find(".sos-qorder-label").html(preOrder);
		prevRow.find(".sos-qorder").val(curOrder);
		prevRow.find(".sos-qorder-label").html(curOrder);
		currRow.insertBefore(prevRow);
	  }
    };

	var downField = function upField(id) {
      var currRow = $(event.target).closest("tr"),
		  nextRow = currRow.next();
	  if(nextRow.length > 0) {
		var nextOrder = nextRow.find(".sos-qorder").val(),
		curOrder = currRow.find(".sos-qorder").val();
		currRow.find(".sos-qorder").val(nextOrder);
		currRow.find(".sos-qorder-label").html(nextOrder);
		nextRow.find(".sos-qorder").val(curOrder);
		nextRow.find(".sos-qorder-label").html(curOrder);
		currRow.insertAfter(nextRow);
	  }
    };

	var changeSubsectionValue = function upField(id) {
      var selectedValue = $('#sos-subsection-dropdown-' + id).val();
	  $("#subsection_" + id).val(selectedValue)
    };

    var deleteField = function deleteField(id) {
	  var deletedQuestions = $('#sos-deleted-questions').val(),
          _type = $('#deleteItem-'+id).attr('data-type');
	  $('#sos-deleted-questions').val(deletedQuestions + "," + id);
      FieldController.deleteField(id, _type);
      //render();
    }
    
    var editedField = function editedField(id) {
  	  var editedQuestions = $('#sos-edited-questions').val(),
            _type = $('#editItem-'+id).attr('data-type');
  	  if($('#sos-edited-questions').val()==""){
  		  $('#sos-edited-questions').val(id);
  	  } else {
  		  $('#sos-edited-questions').val(editedQuestions + "," + id);
  	  }
    }
    
    var enableFieldFields = function enableFieldFields(id) {
      var _type = $('#editItem-'+id).attr('data-type');
      FieldController.enableFieldFields(id, _type);
      //render();
    }

    var addField = function addField(type) {
      render([FieldController.addField(type)]);
	  return false;
    }

    return {
      count: 1,
      render: render,
      deleteField: deleteField,
      enableFieldFields: enableFieldFields,
      upField: upField,
      downField: downField,
      changeSubsectionValue: changeSubsectionValue,
      addField: addField,
      editedField: editedField
    };
  })();

  ///////////////////////////////////////////////////////////// form fields - begin
  var FrmFieldController = (function(){
    var _FieldData = [];

    var initFieldData = function initFieldData(data) {
      for (var i=0; i < data.length; i++) {		  
        _FieldData.push(new FrmField(data[i].fid, data[i].fincrementid, data[i].forder, data[i].flabel, data[i].ftype, data[i].frequired, data[i].foptions, data[i].fchecked));
      }
    };  

    var addField = function addField(type) {
      var newField = new FrmField("", "", "", "", "text", "0", "", "");
      _FieldData.push(newField);
      return newField;
    };

    var deleteField = function deleteField(id, type) {
      $(event.target).closest("tr").remove();
    }

    var getFields = function getFields() {
      return _FieldData;
    }

    return {
      count: 1,
      initFieldData: initFieldData,
      addField: addField,
      deleteField: deleteField,
      getFields: getFields
    }
  })();


  var FrmFieldView = (function() {

    var FieldTemplate = '<tr class="row-editable sos-field-row-editable" data-fincrementid="%fincrementid%" data-fid="%fid%">\
        <td class="hidden">\
           <input type="text" class="form-control sos-input sos-form-field-input" value="%fid%" name="text%fid%" id="text_%fid%" >\
        </td>\
        <td>\
			<span class="sos-forder-label">%forder%</span>\
			<input class="sos-forder-input sos-forder-%fid%" type="hidden" value="%forder%"></td>\
        </td>\
        <td>\
           <input type="checkbox" %fcheckdisabled% class="sos-field-required form-control sos-frequired-%fid%" onclick="FrmFieldView.updateFrequired();" %fchecked%>\
        </td>\
        <td>\
           <input type="text" class="form-control sos-input sos-form-field-input sos-fdisplayname-%fid%" value="%fdisplayname%" title="%fdisplayname%" name="text%fdisplayname%" placeholder="Enter field display name">\
        </td>\
        <td>\
			<select class="form-control sos-form-field-input sos-form-field-input-select sos-ftype-%fid%" onchange="FrmFieldView.updateFoptions();">\
				<option class="form-control sos-form-field-input sos-form-field-input-option" value="text">Text Field</option>\
				<option class="form-control sos-form-field-input sos-form-field-input-option" value="select">Select Field</option>\
			</select>\
        </td>\
        <td>\
          <textarea placeholder="Enter DB query" %fdisabled% class="form-control admin-textarea-field sos-foptions-%fid%" >%foptions%</textarea>\
        </td>\
        <td>\
		  <input type="hidden" value="%order%" id="order_%fid%">\
          <i title="Up" class="sos-order-direction sos-up-icon fa fa-arrow-up fa-lg" id="up-%fid%" data-type="%type%" onclick="FrmFieldView.upField()"></i>\
          <i title="Down" class="sos-order-direction sos-down-icon fa fa-arrow-down fa-lg" id="down-%fid%" data-type="%type%" onclick="FrmFieldView.downField()"></i>\
        </td>\
      </tr>';

    var generateHTML = function generateHTML(Field) {
      return FieldTemplate.replace(/%fid%/g, Field.fid)
		          .replace(/%forder%/g, Field.forder)
		          .replace(/%fincrementid%/g, Field.fincrementid)
		          .replace(/%fdisplayname%/g, Field.fdisplayname)
                  .replace(/%fcheckdisabled%/g, (Field.fid === 'f4' ? "disabled" : ""))
                  .replace(/%fdisabled%/g, (Field.ftype === "text" ? "disabled" : ""))
                  .replace(/%foptions%/g, Field.foptions)
                  .replace(/%fchecked%/g, Field.fchecked);
    };

    var render = function render(emp) {
      var Fields = emp ? emp : FrmFieldController.getFields(),
          innerHTML = '';
      Fields.forEach(function(Field) {
		  //console.log('#'+Field.type+' tbody');
        var $tbody = document.querySelector('#sos-table-fields tbody');
        innerHTML = generateHTML(Field);
        $($tbody).append(innerHTML);
		$($tbody).find("select:last").val(Field.ftype ? Field.ftype : "text");
      });
    };
	$(".sos-form-field-input-select").ready(function() { 
		$(".sos-form-field-input-select").selectpicker();
	});

    var deleteField = function deleteField(id) {
	  var deletedQuestions = $('#sos-deleted-questions').val(),
          _type = $('#deleteItem-'+id).attr('data-type');
	  $('#sos-deleted-questions').val(deletedQuestions + "," + id);
      FieldController.deleteField(id, _type);
      //render();
    };

    var addField = function addField(type) {
      render([FrmFieldController.addField(type)]);
	  return false;
    };

	var upField = function upField(id) {
      var currRow = $(event.target).closest("tr"),
		  prevRow = currRow.prev();
      if(prevRow.length > 0) {
		var preOrder = prevRow.find(".sos-forder-input").val(),
			curOrder = currRow.find(".sos-forder-input").val();
		currRow.find(".sos-forder-input").val(preOrder);
		currRow.find(".sos-forder-label").html(preOrder);
		prevRow.find(".sos-forder-input").val(curOrder);
		prevRow.find(".sos-forder-label").html(curOrder);
		currRow.insertBefore(prevRow);
	  }
    };

	var downField = function upField(id) {
      var currRow = $(event.target).closest("tr"),
		  nextRow = currRow.next();
	  if(nextRow.length > 0) {
		var nextOrder = nextRow.find(".sos-forder-input").val(),
		curOrder = currRow.find(".sos-forder-input").val();
		currRow.find(".sos-forder-input").val(nextOrder);
		currRow.find(".sos-forder-label").html(nextOrder);
		nextRow.find(".sos-forder-input").val(curOrder);
		nextRow.find(".sos-forder-label").html(curOrder);
		currRow.insertAfter(nextRow);
	  }
    };




	var updateFoptions = function updateFoptions() {
      var selField = $(event.target),
		  currRow = selField.closest("tr"),
		  optionsField = currRow.find("textarea");
	  if(selField.val() === "text") {
		$(optionsField).attr("disabled", "disabled");
	  } else {
		$(optionsField).removeAttr("disabled");
	  }
    };
	
	var updateFrequired = function updateFrequired() {
		var ele = event.target;
		if ($(ele).is(':checked')) {
			$(ele).attr('checked', true);
		} else {
			$(ele).attr('checked', false);
		}
    };

    return {
      count: 1,
      render: render,
      deleteField: deleteField,
      upField: upField,
      downField: downField,
      updateFoptions: updateFoptions,
      updateFrequired: updateFrequired,
      addField: addField
    };
  })();
  ///////////////////////////////////////////////////////////// form fields - end

  var _doData = allData;
  var _doFieldsData = allFieldsData;
  
  function init() {
    FieldController.initFieldData(_doData);
    FieldView.render();


	function sortFrmFields(a,b) {
	  return parseInt(a.forder, 10) - parseInt(b.forder, 10);
	}
	_doFieldsData = _doFieldsData.sort(sortFrmFields);


	FrmFieldController.initFieldData(_doFieldsData);
    FrmFieldView.render();
  }

  init();
