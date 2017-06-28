
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
        $(this).attr('disabled', true);
      });
      $('.row-editable').removeClass('row-editable').addClass('row-readonly');

      var currentTarget = $(event.target).closest("tr");
      currentTarget.addClass('row-editable').removeClass('row-readonly');
      currentTarget.find('.form-control').each(function() {
        $(this).attr('disabled', false);
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
				console.log(currRowUpdateQorder);
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
        </td>\
        <td>\
          <textarea placeholder="Enter description" class="form-control admin-textarea sos-input-desc-%id%"  %disabled% name="desc%id%" id="desc_%id%">%desc%</textarea>\
        </td>\
        <td><img src="%img%" id="sos-img-%id%" class="img_size">\
        <input type="file" id="file%id%" class="file-input sos-input-file-%id%" name="file_%type%_%id%">\
        </td>\
        <td>\
          <i title="Edit" class="sos-edit-icon fa fa-pencil fa-lg" id="editItem-%id%" data-type="%type%" onclick="FieldView.enableFieldFields(%id%)"></i>\
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
                  .replace(/%disabled%/g, Field.enabled ? '': 'disabled');
    };

    var render = function render(emp) {
      var Fields = emp ? emp : FieldController.getFields(),
          innerHTML = '';
      Fields.forEach(function(Field) {
        var $tbody = document.querySelector('#'+Field.type+' tbody');
        innerHTML = generateHTML(Field);
        $($tbody).append(innerHTML);
      });
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
		currRow.insertAfter(nextRow);
	  }
    };

    var deleteField = function deleteField(id) {
	  var deletedQuestions = $('#sos-deleted-questions').val(),
          _type = $('#deleteItem-'+id).attr('data-type');
	  $('#sos-deleted-questions').val(deletedQuestions + "," + id);
      FieldController.deleteField(id, _type);
      //render();
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
      render: render,
      deleteField: deleteField,
      enableFieldFields: enableFieldFields,
      upField: upField,
      downField: downField,
      addField: addField
    };
  })();
  var _doData = allData;
  
  function init() {
    FieldController.initFieldData(_doData);
    FieldView.render();
  }

  init();