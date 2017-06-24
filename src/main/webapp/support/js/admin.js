
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

  var Field = function(id, text, desc, image, type, enabled) {
    this.id = id;
    this.text = text;
    this.desc = desc;
    this.image = image;
    this.enabled = enabled ? enabled : false;
    this.type = type;
  }

  Field.prototype.edit = function(text, desc, image) {
    this.text = newField.text;
    this.desc = newField.desc;
    this.image = newField.image;
    this.type = newField.type;
  }

  var FieldController = (function(){
    var _FieldData = [];

    var initFieldData = function initFieldData(data) {
      for (var i=0; i < data.length; i++) {
        _FieldData.push(new Field(data[i].id, data[i].text, data[i].description, data[i].imagePath, data[i].type));
      }
    };

    var editField = function editField(id, text, desc, image, type) {
      var oldField;
      for (var i=0; i < _FieldData.length; i++) {
        if (_FieldData[i].id === id) {
          oldField = _FieldData[i];
          break;
        }
      }
      if (oldField) {
        oldField.edit(text, desc, image);
      }
    };

    var enableFieldFields = function enableFieldFields(id, type) {
      $('.row-editable').find('.form-control').each(function() {
        $(this).attr('disabled', true);
      });
      $('.row-editable').removeClass('row-editable').addClass('row-readonly');
      $('#row_'+type+'_'+id).addClass('row-editable').removeClass('row-readonly');
      $('#row_'+type+'_'+id).find('.form-control').each(function() {
        $(this).attr('disabled', false);
      });
    };

    var addField = function addField(type) {
      var newField = new Field(-1, "", "", "", type, true);
      _FieldData.push(newField);
      return newField;
    };

    var deleteField = function deleteField(id, type) {
      var index = -1;
      for (var i=0; i < _FieldData.length; i++) {
        if (_FieldData[i].id === id) {
          index = i;
          break;
        }
      }
      if (index !== -1) {
        _FieldData.splice(index, 1);
        $('#row_'+type+'_'+id).remove();
      }
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
        <td>%id%</td>\
        <td>\
           <input type="text" class="form-control sos-input sos-input-question" data-section="%type%" data-id="%id%" value="%text%" title="%text%" name="text%id%" id="text_%id%" %disabled% placeholder="Enter question">\
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
      </tr>';

    //var $tbody = document.querySelector('tbody');

    var generateHTML = function generateHTML(Field) {
      return FieldTemplate.replace(/%id%/g, Field.id)
                  .replace(/%text%/g, Field.text)
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

    var deleteField = function deleteField(id) {
	  var deletedQuestions = $('#sos-deleted-questions').val(),
          _type = $('#deleteItem-'+id).attr('data-type');
	  $('#sos-deleted-questions').val(deletedQuestions + "|" + id);
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
      addField: addField
    };
  })();
  var _doData = allData;
  
  function init() {
    FieldController.initFieldData(_doData);
    FieldView.render();
  }

  init();