<!DOCTYPE html>
<%@page import="sas.bean.Question"%>
  <html xmlns="http://www.w3.org/1999/xhtml">
    <%@ page import="java.util.*" %>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>International SOS Self Assessment Tool - Admin</title>
        <script src="support/lib/jquery-3.2.0.js"></script>
        <script src="support/lib/jquery-ui.min.js"></script>
        <script src="support/lib/bootstrap.min.js"></script>
        <script src="support/lib/bootstrap-select.min.js"></script>
        <link href="support/lib/bootstrap.min.css" rel="stylesheet">
        <link href="support/lib/bootstrap-select.min.css" rel="stylesheet">
        <link href="support/lib/font-awesome.min.css" rel="stylesheet">
        <link href="support/lib/jquery-ui.min.css" rel="stylesheet">
        <link href="support/css/site.css" rel="stylesheet">
	<link rel="shortcut icon" href="${pageContext.request.contextPath}/favicon.ico" type="image/x-icon"/>
        <script type="text/javascript">
            var allData=[], allFieldsData=[];
            <%
                Hashtable<String, List<Question>> hs = (Hashtable<String, List<Question>>) request.getAttribute("questions");  
                List<Question> list = hs.get("plan");
                int totalQuestions = 0;
                Question q = null;
                //System.out.println(list.size());

                for(int i=0; i < list.size(); i++) {
                    q = list.get(i);
            %>
                    var obj = {
                        qorder: '<%= q.getQorder() %>',
                        id: '<%= q.getId() %>',
                        text: "<%= q.getText() %>",
                        subsection: "<%= q.getSubtype() %>",
                        description: "<%= q.getDesc() %>",
                        imagePath: "support/img/resourceFiles/<%= q.getImageName() %>",
                        type: 'plan'
                    };
                    allData.push(obj);
            <%
                }
            %>

            <%
                list = hs.get("do");

                for(int i=0; i < list.size(); i++) {
                    q = list.get(i);
            %>

                    var obj = {
                        qorder: '<%= q.getQorder() %>',
                        id: '<%= q.getId() %>',
                        text: "<%= q.getText() %>",
                        subsection: "<%= q.getSubtype() %>",
                        description: "<%= q.getDesc() %>",
                        imagePath: "support/img/resourceFiles/<%= q.getImageName() %>",
                        type: 'do'
                    };
                    allData.push(obj);
            <%
                }
            %>

            <%
                list = hs.get("check");

                for(int i=0; i < list.size(); i++) {
                    q = list.get(i);
            %>

                    var obj = {
                        qorder: '<%= q.getQorder() %>',
                        id: '<%= q.getId() %>',
                        text: "<%= q.getText() %>",
                        subsection: "<%= q.getSubtype() %>",
                        description: "<%= q.getDesc() %>",
                        imagePath: "support/img/resourceFiles/<%= q.getImageName() %>",
                        type: 'check'
                    };
                    allData.push(obj);
            <%
                }
            
                //    fieldid:   order:type:displayname:required:<<options>>     <<options>> exists only for select types.                        
                Hashtable<String, String> hmf = (Hashtable<String, String>) request.getAttribute("userformsfields");

                System.out.println(hmf);
                Set<String> hmfKeys = hmf.keySet();
                for(String key: hmfKeys){
                    System.out.println("Value of "+key+" is: "+hmf.get(key));

                    StringTokenizer st = new StringTokenizer(hmf.get(key), ":");
                    String fid, forder, ftype, flabel, frequired, foptions = "", fchecked,fincrementid;
                    fid = key;
                    fincrementid = st.nextToken();
                    forder = st.nextToken();
                    ftype = st.nextToken();
                    flabel = st.nextToken();
                    frequired = st.nextToken();                      
                    fchecked = frequired.equals("true") ? "checked" : "";
                    if(!ftype.equals("text")&&!ftype.equals("check")) {
                        foptions = st.nextToken();
                    }
            %>
                
                    var fieldValues = {
                        fid: '<%= fid%>',
                        fincrementid: '<%=fincrementid%>',
                        forder: '<%=forder%>',
                        ftype: '<%=ftype%>',
                        flabel: '<%=flabel%>',
                        frequired: '<%=frequired%>',
                        checked: '<%=fchecked%>',
                        foptions: '<%=foptions%>',
                        fchecked: '<%=fchecked%>'
                    };
                    allFieldsData.push(fieldValues);
                    //generateNewField(fieldValues);
               
                
            <%
                }
            %>


            
            function getLocaleData() {
                //console.log("admin?locale=" + $("#language").val());
                $("#localeForm").attr("action","admin?locale=" + $("#language").val());
                $("#localeForm").attr("method","get");
                
            }
            function updateLocaleData() {
                $(".admin-lang").val($("#sos-lang-select").val());                
            }

            function gatherInfo() {
                var generalFields = $(".sos-input-general"),
                    sectionFields = $(".sos-input-question"),
                    allGenerals = "",
                    allSections = "",
                    allFields = "",
                    allFieldsInfo = $(".sos-field-row-editable");
                generalFields.each(function(cur) {
                    allGenerals += $(this).attr("id") + ":" + $(this).val() + "|";
                });
                sectionFields.each(function(cur) {
                    var objId = $(this).data('id');
                    allSections +=  objId + ":" + $(this).data('section') + ":" + $(this).val() +":" + $(".sos-subsection-" + objId).val() +":"+ $(".sos-input-desc-" + objId).val() + ":";
                    var imgName = "";
                    var currImg = $("#file" + objId).val();
                    if(!!currImg) {
                        imgName = currImg.substring(currImg.lastIndexOf("\\") + 1, currImg.length);
                    } else {
                        currImg = $("#sos-img-" + objId).attr("src");
                        imgName = currImg.substring(currImg.lastIndexOf("/") + 1, currImg.length);
                    }
                    //console.log("imgName : " + imgName);
                    allSections += imgName + ":" + $(".sos-qorder-" + objId).val() + "|";
                });
                //    fieldid:   order:type:displayname:required:<<options>>     <<options>> exists only for select types
                allFieldsInfo.each(function(cur) {
                    var fid = $(this).data('fid'),
                        fincrementid = $(this).data('fincrementid');
                    allFields +=  fid + ":cmsedge:" + fincrementid + ":cmsedge:" + $('.sos-forder-' + fid).val() + ":cmsedge:" + $('.sos-ftype-' + fid).val() + ":cmsedge:" + $('.sos-fdisplayname-' + fid).val() + ":cmsedge:" + ($('.sos-frequired-' + fid).attr("checked") === "checked" ? "true" : "false") + ":cmsedge:" + $('.sos-foptions-' + fid).val() + ":cmsedge:" ;
                    allFields += "|cmsedge|";
                });
                
                $("#sos-labels").val(allGenerals);
                $("#sos-questions").val(allSections);
                $("#sos-form-fields").val(allFields);
               // return false;
                //console.log("allGenerals : " + allGenerals);
                //console.log("allSections : " + allSections);
                //console.log("allSections : " + allSections);
                //console.log("allFields : " + allFields);
                submitCompleteForm();
            }

            function submitCompleteForm(data) {
                return false;
                $("#localeForm1").submit();

                /*$.ajax({
                    url: 'admin',
                    type: 'multipart/form-data',
                    method: 'post',
                    data: data
                })
                .done(function( args ) {
                   // DO something.
                })
                .fail(function(err) {
                   // show error 
                });*/

            }

        </script>

        


    </head>
    <body class="sos-dark-theme">
        <div class="sos-admin-logo-wrapper">
            <div id="logo" class="sos-admin-logo"></div>
        </div>
		<%
                String lang = (String) request.getAttribute("language");
				//System.out.println("\n\n\n\n\n lang: "+lang);
                if(lang == null) {
                    lang = "english";
                }

				//System.out.println("\n\n\n\n\n lang: "+lang);
				List<String> langList = (List<String>) request.getAttribute("langList");
            %>
        <form name="localeForm" id="localeForm" method="get" action="admin" onsubmit="" >
            <div class="admin-locale-wrapper">
                
                <div style="sos-admin-first-form">
                    
                    
                    <a style="cursor: pointer;top: 20px;position: relative;display: inline-block;" data-toggle="modal" data-target="#myModalNorm">Create new site</a>
                    <!--button class="btn btn-primary btn-lg" data-toggle="modal" data-target="#myModalNorm">Launch Normal Form</button-->

                    <div class="modal fade" id="myModalNorm" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <!-- Modal Header -->
                                <div class="modal-header">
                                    <button type="button" class="close" 
                                       data-dismiss="modal">
                                           <span aria-hidden="true">&times;</span>
                                           <span class="sr-only">Close</span>
                                    </button>
                                    <h4 class="modal-title" id="myModalLabel">
                                        Create new site
                                    </h4>
                                </div>
                                
                                <!-- Modal Body -->
                                <div class="modal-body">                                    
                                    <form role="form">
                                      <div class="form-group">
                                        <label for="exampleInputEmail1">Enter site name: </label>
                                        <br />
                                        <input type="text" class="form-control sos-admin-new-site-input" id="sos-admin-new-site-input" placeholder="Enter site name"/>
                                      </div>
                                    </form>
                                </div>
                                
                                <!-- Modal Footer -->
                                <div class="modal-footer">
                                    <!--button type="button" class="btn btn-default"
                                            data-dismiss="modal">
                                                Close
                                    </button-->
                                    <button type="button" class="btn btn-primary" onClick="javascript: createSite();">
                                        Create!
                                    </button>
                                </div>
                            </div>
                        </div>
                        </div>





                    <input class="admin-lang form-control hidden" name="language" id="language" type="text" value="<%=(lang.equals("en") || lang.equals("english") ? "master" : lang)%>" />
                   <select id="sos-lang-select" class="selectpicker sos-admin-select" onchange="javascript: updateLocaleData();">
						<option value="master" <%=(lang.equals("en") || lang.equals("english") ? "selected" : "")%>>master</option>
					<%
						String tempLang = null;
						for(int i = 0; i < langList.size(); i++) {
							tempLang = (String) langList.get(i);
                            String tempLangDisplayName = tempLang.equals("en") || tempLang.equals("english") ? "master" : tempLang;
							System.out.println("tempLang....:"+tempLang);
                            String isSelected = lang.equals(tempLang) ? "selected" : "";
					%>
                        <option value="<%=tempLang%>" <%=isSelected%>><%= tempLangDisplayName %></option>
					<% } %>
                    </select>  
                    <button style="display: inline-block; width: 58px; float: right;" id="sos-admin-lang-submit" class="btn btn-primary admin-lang-btn col-lg-4 col-md-6 col-sm-12 col-xs-12" onclick="javascript: return getLocaleData();">Go!</button>
                    <script>
                    function createSite(event) {
                        var siteName = $("#sos-admin-new-site-input").val().trim();
                        if (siteName === '') {
                            alert("Please enter site name");
                        } else {
                            // submit new site form.
                            $("#sos-lang").val(siteName);
                            $(".admin-lang-btn").trigger("click");
                        }
                        console.log(siteName);
                    }
                    $(document).ready(function () {
                        $('#myModal').bind('show', function () {
                            //do stuf on show
                        });
                        $('#btn-modal').click(function() {
                            $('#myModal').modal('show');
                        });
                    });

                    function closeDialog() {
                        $('#myModal').modal('hide');
                    };

                    function okClicked() {
                        closeDialog();
                    };
                    $(".selectpicker").ready(function() {
                       $(".selectpicker").selectpicker();
                        });
                    </script>
                </div>
            </div>
        </form>
        <form name="localeForm1" id="localeForm1" method="post" enctype="multipart/form-data" action="admin" class='sos-admin-primary-wrapper<%=(lang.equals("en") || lang.equals("english") || lang.equals("master") ? "master" : "")%>' onsubmit="javascript: gatherInfo();" >
            
            <input type="hidden" id="sos-lang" name="language" value="<%= lang %>" />
            <input type="hidden" id="sos-labels"  name="labels" value="" />
            <input type="hidden" id="sos-questions"  name="questions" value="" />
            <input type="hidden" id="sos-deleted-questions"  name="deletedquestions" value="" />
            <input type="hidden" id="sos-form-fields"  name="userformsfields" value="" />
            <input type="hidden" id="sos-edited-questions"  name="editedquestions" value="" />

            <div id="item_panels">
                <h3 class="general_section">General Labels</h3>        
                <div class="store_addr">
                <div class="form-group">
                <%
                    
                    Hashtable<String, String> hm = (Hashtable<String, String>) request.getAttribute("labels");
                    Set<String> hmKeys = hm.keySet();
                    for(String key: hmKeys){
                        //System.out.println("Value of "+key+" is: "+hm.get(key));
                %>
                    <div class="labels-wrapper">
                        <span class="sos-admin-label-key"><%=key%>:</span>
                        <span class="sos-admin-label-value"><input type="text" class="sos-input-general form-control" id="<%=key%>"  placeholder="Enter <%=key%>" value="<%= hm.get(key) %>"></span>
                    </div>
                <%
                    }
                %>
                </div>
                </div>

                <h3 class="plan_header">Analyse</h3>        
                <div class="store_addr">
                    <table id="plan" class="table table-striped table-bordered table-hover">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Text</th>
                                <th>Subsection</th>
                                <th>Description</th>
                                <th>Image</th>
                                <th>Actions</th>
                                <th>Order</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                    <div class="btn-section sos-btn-section">
                        <button class="btn btn-primary pull-right" id="addFieldBtn" onclick="FieldView.addField('plan'); return false;">Add Item</button>
                    </div>
                </div>
                
                <h3 id="2" class="do_header">Mitigate</h3>        
                <div class="item_container">
                    <table id="do" class="table table-striped table-bordered table-hover">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Text</th>
                                <th>Subsection</th>
                                <th>Description</th>
                                <th>Image</th>
                                <th>Actions</th>
                                <th>Order</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                    <div class="btn-section sos-btn-section">
                        <button class="btn btn-primary pull-right" id="addFieldBtn" onclick="FieldView.addField('do'); return false;">Add Item</button>
                    </div>
                </div>

                <h3 id="3" class="check_header">Control</h3>        
                <div class="store_addr">
                    <table id="check" class="table table-striped table-bordered table-hover">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Text</th>
                                <th>Subsection</th>
                                <th>Description</th>
                                <th>Image</th>
                                <th>Actions</th>
                                <th>Order</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                    <div class="btn-section sos-btn-section">
                        <button class="btn btn-primary pull-right" id="addFieldBtn" onclick="FieldView.addField('check'); return false;">Add Item</button>
                    </div>
                </div>

                <h3 class="fields_section">Fields</h3>        
                <div class="store_addr">
                    <table id="sos-table-fields" class="table table-striped table-bordered table-hover">
                        <thead>
                            <tr>
                                <th>Order</th>
                                <th>Show</th>
                                <th>Display Name</th>
                                <th>Type</th>
                                <th>Options (Separate with | symbol)</th>
                                <th>Order</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                    <div class="btn-section sos-btn-section hidden">
                        <button class="btn btn-primary pull-right" id="addFieldBtn" onclick="FrmFieldView.addField({}); return false;">Add Field</button>
                    </div>
                </div>



             </div>
             <div class="admin-locale-submit">
                <button class="btn btn-primary admin-lang-btn" onclick="">Save</button>
            </div>
         </form>
    </body>
    <script src="support/js/admin.js"></script>
</html>
