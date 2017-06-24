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
        <script src="support/lib/bootstrap.js"></script>
        <link href="support/lib/bootstrap.css" rel="stylesheet">
        <link href="support/lib/font-awesome.min.css" rel="stylesheet">
        <link href="support/lib/jquery-ui.min.css" rel="stylesheet">
        <link href="support/css/site.css" rel="stylesheet">

        <script type="text/javascript">
            var allData=[];
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
                        id: '<%= q.getId() %>',
                        text: "<%= q.getText() %>",
                        description: "<%= q.getDesc() %>",
                        imagePath: "support/img/resourceFiles/<%= q.getImageName() %>",
                        type: 'plan'
                    };
                    allData.push(obj);
            <%
                }
            %>

            <%
                list = hs.get("Do");

                for(int i=0; i < list.size(); i++) {
                    q = list.get(i);
            %>

                    var obj = {
                        id: '<%= q.getId() %>',
                        text: "<%= q.getText() %>",
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
                        id: '<%= q.getId() %>',
                        text: "<%= q.getText() %>",
                        description: "<%= q.getDesc() %>",
                        imagePath: "support/img/resourceFiles/<%= q.getImageName() %>",
                        type: 'check'
                    };
                    allData.push(obj);
            <%
                }
            %>
            
            function getLocaleData() {
                console.log("admin?locale=" + $("#language").val());
                $("#localeForm").attr("action","admin?locale=" + $("#language").val());
                $("#localeForm").attr("method","get");
                
            }

            function gatherInfo() {
                var generalFields = $(".sos-input-general"),
                    sectionFields = $(".sos-input-question"),
                    allGenerals = "",
                    allSections = "";
                generalFields.each(function(cur) {
                    allGenerals += $(this).attr("id") + ":" + $(this).attr("value") + "|";
                });
                sectionFields.each(function(cur) {
                    var objId = $(this).data('id');
                    allSections +=  objId + ":" + $(this).data('section') + ":" + $(this).val() +":" + $(".sos-input-desc-" + objId).val() + ":";
                    var imgName = "";
                    var currImg = $("#file" + objId).val();
                    if(!!currImg) {
                        imgName = currImg.substring(currImg.lastIndexOf("\\") + 1, currImg.length);
                    } else {
                        currImg = $("#sos-img-" + objId).attr("src");
                        imgName = currImg.substring(currImg.lastIndexOf("/") + 1, currImg.length);
                    }
                    console.log("imgName : " + imgName);
                    allSections += imgName + "|";
                });
                
                $("#sos-labels").val(allGenerals);
                $("#sos-questions").val(allSections);
                //console.log("allGenerals : " + allGenerals);
                //console.log("allSections : " + allSections);
                //console.log("allSections : " + allSections);
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
				System.out.println("\n\n\n\n\n lang: "+lang);
                if(lang == null) {
                    lang = "en";
                }

				System.out.println("\n\n\n\n\n lang: "+lang);
            %>
        <form name="localeForm" id="localeForm" method="get" action="admin" onsubmit="" >
            <div class="admin-locale-wrapper">
                Locale: <input class="admin-lang" name="language" id="language" type="text" value="<%=lang%>" />
                <button class="btn btn-primary admin-lang-btn" onclick="javascript: return getLocaleData();">Go!</button>
            </div>
        </form>
        <form name="localeForm1" id="localeForm1" method="post" type="multipart/form-data" action="admin" class="sos-admin-primary-wrapper<%=lang%>" onsubmit="javascript: gatherInfo();" >
            
            <input type="hidden" id="sos-lang" name="lang" value="<%= lang %>" />
            <input type="hidden" id="sos-labels"  name="labels" value="" />
            <input type="hidden" id="sos-questions"  name="questions" value="" />
            <input type="hidden" id="sos-deleted-questions"  name="deletedquestions" value="" />

            <div id="item_panels">
                <h3 class="general_section">General Labels</h3>        
                <div class="store_addr">
                <div class="form-group">
                <%
                    
                    Hashtable<String, String> hm = (Hashtable<String, String>) request.getAttribute("labels");
                    Set<String> hmKeys = hm.keySet();
                    for(String key: hmKeys){
                        System.out.println("Value of "+key+" is: "+hm.get(key));
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
                                <th>Description</th>
                                <th>Image</th>
                                <th>Actions</th>
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
                                <th>Description</th>
                                <th>Image</th>
                                <th>Actions</th>
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
                            <th>Description</th>
                            <th>Image</th>
                            <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>

                    <div class="btn-section sos-btn-section">
                        <button class="btn btn-primary pull-right" id="addFieldBtn" onclick="FieldView.addField('check'); return false;">Add Item</button>
                    </div>
                 </div>
             </div>
             <div class="admin-locale-submit">
                <button class="btn btn-primary admin-lang-btn" onclick="">Submit</button>
            </div>
         </form>
    </body>
    <script src="support/js/admin.js"></script>
</html>