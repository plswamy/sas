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
                /*Hashtable<String, String> hmf = new Hashtable<String,String>();
                                                hmf.put("f1",   "1:text:First Name:true");
                                                hmf.put("lastname",   "2:text:Last Name:true");
                                                hmf.put("jobtitle",   "3:text:Job Title:true");
                                                hmf.put("email",   "4:text:Email:true");
                                                hmf.put("company",   "5:text:Company:true");
                                                hmf.put("businessindustry",   "6:select:Business Industry:true:select * from businessindustry;");
                                                hmf.put("country",   "7:select:Country:true:select * from country;");
                                                hmf.put("state",   "8:select:State:true:select * from state;");
                                                hmf.put("aboutme",   "10:text:About Me:true");
                                                hmf.put("gender",   "9:select:Gender:true:select * from gender;");
                                                hmf.put("qualification",   "12:select:Qualifications:true:select * from qualifications;");
                                                hmf.put("expertise",   "11:select:Expertise:true:select * from expertise;");*/
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
                    if(!ftype.equals("text")) {
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
    <body>
		<%
                String lang = (String) request.getAttribute("language");
				//System.out.println("\n\n\n\n\n lang: "+lang);
                if(lang == null) {
                    lang = "en";
                }

				//System.out.println("\n\n\n\n\n lang: "+lang);
				List<String> langList = (List<String>) request.getAttribute("langList");
            %>
        <form name="localeForm" id="localeForm" method="get" action="admin" onsubmit="" >
            <div class="admin-locale-wrapper">
                <div style="float: right; width: 40%;">
                    <input class="admin-lang form-control" name="language" id="language" type="text" value="<%=lang%>" />
                    <select id="sos-lang-select" class="selectpicker sos-admin-select" onchange="javascript: updateLocaleData();">
						<option value="english">english</option>
					<%
						String tempLang = null;
						for(int i = 0; i < langList.size(); i++) {
							tempLang = (String) langList.get(i);
							System.out.println("tempLang....:"+tempLang);
					%>
                        <option value="<%=tempLang%>"><%=tempLang%></option>
					<% } %>
                    </select>  
                    <button style="display: inline-block; width: 17%; float: right;" class="btn btn-primary admin-lang-btn col-lg-4 col-md-6 col-sm-12 col-xs-12" onclick="javascript: return getLocaleData();">Go!</button>
                    <script>
                    $(".selectpicker").ready(function() {
                       $(".selectpicker").selectpicker();
                        });
                    </script>
                </div>
            </div>
        </form>
        <form name="localeForm1" id="localeForm1" method="post" enctype="multipart/form-data" action="admin" class="sos-admin-primary-wrapper<%=lang%>" onsubmit="javascript: gatherInfo();" >
            
            <input type="hidden" id="sos-lang" name="lang" value="<%= lang %>" />
            <input type="hidden" id="sos-labels"  name="labels" value="" />
            <input type="hidden" id="sos-questions"  name="questions" value="" />
            <input type="hidden" id="sos-deleted-questions"  name="deletedquestions" value="" />
            <input type="hidden" id="sos-form-fields"  name="userformsfields" value="" />

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

                <h3 class="plan_header">Plan</h3>        
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
                
                <h3 id="2" class="do_header">Do</h3>        
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

                <h3 id="3" class="check_header">Check</h3>        
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