<!DOCTYPE html>
<%@ page import="java.util.*" %>
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>International SOS Self Assessment Tool</title>
        <script type="text/javascript" async="" src="support/js/ga.js"></script>
        <script src="support/lib/jquery-3.2.0.js"></script>
        <script src="support/lib/bootstrap.min.js"></script>
        <script src="support/lib/bootstrap-select.min.js"></script>
        <script src="support/js/countries2.js"></script>
        <script>
            function fnOnUpdateValidators() {
                var emailValScore = 0;
                var showMsg = false;
                for (var i = 0; i < Page_Validators.length; i++) {
                    var val = Page_Validators[i];
                    var ctrl = document.getElementById(val.controltovalidate);
                    if (ctrl != null) {
                        if (val.controltovalidate == "ctl00_ContentPlaceHolder1_tbxf4") {
                            if (val.isvalid) {
                                emailValScore++;
                            } else {
                                emailValScore--;
                            }
                            if (emailValScore != 2) {
                                ctrl.style.border = '1px solid #ba2222';
                                showMsg = true;
                            } else {
                                ctrl.style.border = '';
                                showMsg = false;
                            }
                        } else {
                            if (!val.isvalid) {
                                ctrl.style.border = '1px solid #ba2222';
                                var bsDD = $(ctrl).data("ddl");
                                if(!!bsDD) {
                                    $("." + bsDD).find('.btn').addClass('sos-btn-danger');
                                }
                                showMsg = true;
                            } else {
                                ctrl.style.border = '';
                            }
                        }
                    }
                }
                $('#validateMsg').toggle(showMsg);
            }
        </script>
        <link href="support/css/site.css" rel="stylesheet">
        <link href="support/lib/bootstrap.min.css" rel="stylesheet">
        <script src="support/lib/bootstrap-dialog.min.js"></script>
        <link href="support/lib/bootstrap-dialog.min.css" rel="stylesheet">
        <link href="support/lib/bootstrap-select.min.css" rel="stylesheet">
        <link rel="shortcut icon" href="${pageContext.request.contextPath}/favicon.ico" type="image/x-icon"/>
    </head>
    <body class="sos-dark-theme1">
        <form name="gsatForm" method="post" action="survey" onsubmit="javascript:return WebForm_OnSubmit();" id="gsatForm">
            <div>
                <input type="hidden" name="__EVENTTARGET" id="__EVENTTARGET" value="">
                <input type="hidden" name="__EVENTARGUMENT" id="__EVENTARGUMENT" value="">
                <input type="hidden" name="__VIEWSTATE" id="__VIEWSTATE"
                    value="/wEPDwULLTE1NzU4NDMxNDVkZJROh77NiIhAB9hkc8bVlwvhv/8Z">
            </div>
            <script type="text/javascript">
                //<![CDATA[
                var theForm = document.forms['gsatForm'];
                if (!theForm) {
                    theForm = document.gsatForm;
                }
                function __doPostBack(eventTarget, eventArgument) {
                    if (!theForm.onsubmit || (theForm.onsubmit() != false)) {
                        theForm.__EVENTTARGET.value = eventTarget;
                        theForm.__EVENTARGUMENT.value = eventArgument;
                        theForm.submit();
                    }
                }
                //]]>
            </script>
            <script src="support/js/WebResource.js" type="text/javascript"></script>
            <script src="support/js/WebResource(1).js" type="text/javascript"></script>
            <script type="text/javascript">
                //<![CDATA[
                function WebForm_OnSubmit() {
                    fnOnUpdateValidators();
                    if (typeof(ValidatorOnSubmit) == "function" && ValidatorOnSubmit() == false) {
                        return false;
                    }
                    var userInfo = {};
                
                    $.each(userFormFields, function(fid) {
                        userInfo[this.fkey] = $(".user-form-field-" + this.fkey).val();
                    });

                    userInfo["lang"] = '<%= request.getAttribute("language") %>';
                
                    localStorage.setItem("userInfo", JSON.stringify(userInfo));
                    return true;
                }
                //]]>
                
                var userFormFields = {};
                
                <%
                    Hashtable<String, String> hs = (Hashtable<String, String>) request.getAttribute("labels");  
                    
                    String welcomeHeader = hs.get("welcomeHeader");
                    String welcomeDesc = hs.get("welcomeDesc");
                    String[] welcomePoints = {"A broad indication of your organisations current maturity with regard to travel risk mitigation systems, processes and tools", "The level of remedial action required to minimise the risks facing your organisation and employees", "Recommended steps to improve your systems", "Outline of the Duty of Care Plan-Do-Check approach"};
                    String welcomeFooter = hs.get("welcomeFooter");
                    String regFormHeaderMsg = hs.get("regFormHeaderMsg");
                    String regFormHeaderErrorMsg = hs.get("regFormHeaderErrorMsg");
                    String countryLabel = "Country";
                    String businessIndustryLabel = "Business Industry";
                    String stateLabel = "State";
                    String enterLabel = hs.get("enter");
                    String mustbevalid = hs.get("mustbevalid");
                    String pleaseSelect = hs.get("pleaseselect");
                    String secName1 = hs.get("secName1");
                    String secName2 = hs.get("secName2");
                    String secName3 = hs.get("secName3");
                    
                    Hashtable<String, String> hmf1 = (Hashtable<String, String>) request.getAttribute("userformfields");                    
                    Set<String> hmf1Keys = hmf1.keySet();

                    for(String key1: hmf1Keys) {
                        String fieldInfo = hmf1.get(key1);
                        StringTokenizer stok = new StringTokenizer(fieldInfo, ":");
                        String fid, fdbid, forder, ftype, fdisplayname, frequired, foptions = "", fchecked, req;
                        fid = key1;
                        fdbid = stok.nextToken();
                        forder = stok.nextToken();
                        ftype = stok.nextToken();
                        fdisplayname = stok.nextToken();
                        if(fieldInfo.equals("f7")) {
                            countryLabel = fdisplayname;
                        } else if(fieldInfo.equals("f8")) {
                            stateLabel = fdisplayname;
                        } if(fieldInfo.equals("f6")) {
                            businessIndustryLabel = fdisplayname;
                        }
                        frequired = stok.nextToken();                      
                        fchecked = frequired.equals("true") ? "checked" : "";
                        if(!ftype.equals("text")) {
                            foptions = stok.nextToken();
                            Hashtable<String, String> opts = (Hashtable<String, String>) request.getAttribute(fid);
                    
                        }
                        req = frequired.equals("true") ? "required" : "";
                    
                %>
                        userFormFields['<%=forder%>'] = {
                            'fkey': '<%= fid %>',
                            'fdbid': '<%= fdbid %>',
                            'ftype': '<%= ftype %>',
                            'fdisplayname': '<%= fdisplayname %>',
                            'frequired': '<%= frequired %>',
                            'foptions': '<%= foptions %>',
                            'req': '<%= req %>',
                            'fchecked': '<%= fchecked %>',
                        };
                
                            userFormFields['<%=forder%>']['frequired'] = userFormFields['<%=forder%>']['frequired'] === 'true';
                
                <%
                    }
                %>
            </script>

            <div class="container">
                <div id="outer" class="row">
                    <div id="header" class="inner col-xs-12 col-sm-12 col-md-12 col-lg-12">
                        <div id="logo" class="pull-right"></div>
                    </div>
                    <div id="content_wrap" class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
                        <div class="inner col-xs-12 col-sm-12 col-md-12 col-lg-12">

                            <div class="banner-container col-xs-12 col-sm-12 col-md-12 col-lg-12">
                                <div class="plan-container col-xs-4 col-sm-4 col-md-4 col-lg-4">
                                    <span class="header-name"><%= secName1 %></span>
                                </div>
                                <div class="do-container col-xs-4 col-sm-4 col-md-4 col-lg-4">
                                    <span class="header-name"><%= secName2 %></span>
                                </div>
                                <div class="check-container col-xs-4 col-sm-4 col-md-4 col-lg-4">
                                    <span class="header-name"><%= secName3 %></span>
                                </div>
                            </div>

                            <div class="content col-xs-12 col-sm-12 col-md-12 col-lg-12">
                                <div class="sos-left-bar left col-xs-12 col-sm-12 col-md-6 col-lg-5">
                                    <h2 class="index-header-2"><%= welcomeHeader %></h2>
                                    <p><%= welcomeDesc %></p>
                                    <ul class="sos-wrapper-ul">
                                        <%
                                            for (int i = 0; i < welcomePoints.length; i++) {
                                                out.println("<li>" + welcomePoints[i] + "</li>");
                                            }
                                            %>
                                    </ul>
                                    <p><%= welcomeFooter %></p>
                                </div>
                                <div class="right sos-right-bar col-xs-12 col-sm-12 col-md-6 col-lg-7">
                                    <div id="reg_form" class="stripe">
                                        <h2 class="index-header-2 right-bar"><%= regFormHeaderMsg %></h2>
                                        <p id="validateMsg" style="display: none; margin: 1.4em 0; color: #ba2222;"><%= regFormHeaderErrorMsg %></p>
                                        <div class="sos-form-fields-wrapper">
                                        </div>
                                        <div class="sos-form-fields-hidden-wrapper hidden">
                                            <div class="form-group form-field-f8 col-xs-12 col-sm-6 col-md-6 col-lg-6">
                                                <label for="ctl00_ContentPlaceHolder1_ddlState"
                                                    id="ctl00_ContentPlaceHolder1_lblState" class="required"><%=stateLabel%></label>
                                                <select class="form-control sos-index-select ddlState user-form-field-f8" data-ddl="ddlState" name="ctl00$ContentPlaceHolder1$ddlState"
                                                    id="ctl00_ContentPlaceHolder1_ddlf8">
                                                    <option value="">Choose country first...</option>
                                                </select>
                                                <div id="ctl00_ContentPlaceHolder1_req_f8"
                                                    style="color:Red;display:none;"></div>
                                            </div>
                                            <%
                                                int idx = 0;
                                                
                                                for(String key1: hmf1Keys){
                                                    if(key1.equals("f8")) {
                                                            continue;
                                                        }
                                                    idx++;
                                                    String fieldInfo = hmf1.get(key1);
                                                    StringTokenizer stok = new StringTokenizer(fieldInfo, ":");
                                                    String fid, fdbid, forder, ftype, fdisplayname, frequired, foptions = "", fchecked, req;
                                                    fid = key1;
                                                    fdbid = stok.nextToken();
                                                    forder = stok.nextToken();
                                                    ftype = stok.nextToken();
                                                    fdisplayname = stok.nextToken();
                                                    frequired = stok.nextToken();                      
                                                    fchecked = frequired.equals("true") ? "checked" : "";
                                                    Hashtable<String, String> opts = null;
                                                    if(!ftype.equals("text")) {
                                                        foptions = stok.nextToken();
                                                        opts = (Hashtable<String, String>) request.getAttribute(fid);
                                                    }
                                                    req = frequired.equals("true") ? "required" : "";
        
                                                    if(frequired.equals("true")) {
                                            %>
                                                        <div class="form-group form-field-<%=fid%> col-xs-12 col-sm-6 col-md-6 col-lg-6" data-forder="<%=forder%>" >
                                                            <label for="ctl00_ContentPlaceHolder1_<%=fid%>" class="required" id="ctl00_ContentPlaceHolder1_<%=fid%>"><%= fdisplayname %></label>
                                                            <% if(ftype.equals("text")) { %>
                                                            <input class="form-control user-form-field-<%=fid%>" name="ctl00$ContentPlaceHolder1$tbx<%=fid%>" type="text" maxlength="40" id="ctl00_ContentPlaceHolder1_tbx<%=fid%>" value="" placeholder="<%=enterLabel%><%= fdisplayname.toLowerCase() %>">
                                                            <% } else { %>
                                                                <select class="form-control sos-index-select ddl<%=fid%> user-form-field-<%=fid%>" data-ddl="ddl<%=fid%>" name="ctl00$ContentPlaceHolder1$ddl<%=fid%>" id="ctl00_ContentPlaceHolder1_ddl<%=fid%>" <% if(fid.equals("f7")) { %> onchange="load_states(&#39;ctl00_ContentPlaceHolder1_ddlf8&#39;,this.selectedIndex);" <% } %>>
                                                                    <%
                                                                        if(opts != null && opts.size() > 0) {
                                                                            Enumeration<String> okeys = opts.keys();
                                                                            while (okeys.hasMoreElements()) {
                                                                                String tokenVal = okeys.nextElement();
                                                                                String tokenVal1 = opts.get(tokenVal);                                                                    
                                                                    %>
                                                                                <option value="<%=tokenVal%>"><%=tokenVal1%></option>
                                                                    <%
                                                                            }
                                                                        }
                                                                    %>
                                                                </select>
                                                            <%
                                                            }
                                                            %>
                                                            <div id="ctl00_ContentPlaceHolder1_req_<%=fid%>" style="color:Red;display:none;"></div>
                                                            <% if (fid.equals("f4")) { %>
                                                                <div id="ctl00_ContentPlaceHolder1_RegularExpressionValidator1" style="color:Red;display:none;"></div>
                                                            <%
                                                            }
                                                            if(idx%2 == 0) { %>
                                                                <div class="clearfix"></div>
                                                            <%
                                                            }
                                                            %>
                                                        </div>
                                                        <%
                                                    }
                                                }
                                                %>
                                            <div class="clearfix"></div>
                                        </div>
                                        <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
                                            <% String requiredFields=hs.get("requiredFields");
                                                %>
                                            <span class="required-text pull-left">* <%=requiredFields%></span>
                                            <span class="pull-right">
                                            <a id="ctl00_ContentPlaceHolder1_btnRegister" class="btn btn-success" href="javascript:WebForm_DoPostBackWithOptions(new
                                                WebForm_PostBackOptions(&quot;ctl00$ContentPlaceHolder1$btnRegister&quot;, &quot;&quot;, true,
                                                &quot;&quot;, &quot;&quot;, false, true))">Start
                                            <span class="arrow"></span></a>
                                            </span>
                                        </div>
                                        <div>
                                            <input type="hidden" name="ctl00$ContentPlaceHolder1$hidCountryCode"
                                                id="ctl00_ContentPlaceHolder1_hidCountryCode">
                                            <input type="hidden" name="ctl00$ContentPlaceHolder1$hidStateCode"
                                                id="ctl00_ContentPlaceHolder1_hidStateCode">
                                        </div>
                                        <div class="spacer"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div id="footer" class="inner img-responsive">
                        <img class="image-max-width" src="support/img/strapline.png" alt="Worldwide reach. Human touch.">
                    </div>
                </div>
            </div>
            <input type="hidden" id="sos-lang-val" value='<%= request.getAttribute("language") %>'/>
    </body>
    <script language="javascript">
        $(document).ready(function () {
        
            $('#ctl00_ContentPlaceHolder1_btnRegister').html(
            "Start <span class='arrow'></span>");
            //alert("country =" +  document.getElementById('ctl00_ContentPlaceHolder1_ddlf7') + "\n State = " + document.getElementById('ctl00_ContentPlaceHolder1_ddlf8'));
            if(document.getElementById('ctl00_ContentPlaceHolder1_ddlf7') !== null) {
	            load_countries('ctl00_ContentPlaceHolder1_ddlf7');
	            
	            $('#ctl00_ContentPlaceHolder1_ddlf7').change(function () {
	                $('#ctl00_ContentPlaceHolder1_hidCountryCode').val($(this).val());
	                $('#ctl00_ContentPlaceHolder1_hidStateCode').val(
	                $('#ctl00_ContentPlaceHolder1_ddlf8').val());            
	                $(".ddlCountry").find(".sos-btn-danger").removeClass("sos-btn-danger");
	            });
	            $.each(userFormFields, function(fid) {
	                 	if(this.fkey == 'f8' && !this.frequired) {
	                 		$('#ctl00_ContentPlaceHolder1_ddlf8').parent().remove();
	                 	}
	            });
            } else {
            	$('#ctl00_ContentPlaceHolder1_ddlf8').parent().remove();
            }
            if(document.getElementById('ctl00_ContentPlaceHolder1_ddlf8') !== null) {
	            $('#ctl00_ContentPlaceHolder1_ddlf8').change(function () {
	                $('#ctl00_ContentPlaceHolder1_hidStateCode').val(
	                $('#ctl00_ContentPlaceHolder1_ddlf8').val());
	                $(".ddlState").find(".sos-btn-danger").removeClass("sos-btn-danger");
	            });
            }
            $('#ctl00_ContentPlaceHolder1_ddlf6').change(function () {
                $(".ddlBusinessIndustry").find(".sos-btn-danger").removeClass("sos-btn-danger");
            });
        
            $(".sos-index-select").each(function() {
                var sortFrmFields = function sortFrmFields(a,b) {
                      if(a.value === '') {
                          return -1;
                      }
                      if (a.text > b.text) return 1;
                        else if (a.text < b.text) return -1;
                        else return 0;
                    },
                     opts = $(this.options).sort(sortFrmFields);                    
        
                $(this).empty();
                var that = this;
                $(opts).each(function(){
                    $(that).append("<option value='" + this.value + "'>" + this.text + "</option>");
                });
            });
        
            $(".sos-index-select").selectpicker();
            
            // re-order the form fields
        
            $.each(userFormFields, function(fid) {
                $(".form-field-" + this.fkey).appendTo($(".sos-form-fields-wrapper"))
            });
        });
    </script>
    <script type="text/javascript">
        //<![CDATA[
        var Page_Validators = new Array();
        
        $.each(userFormFields, function(fid) {
            var key = this.fkey,
                postFix = this.ftype === "text" ? "tbx" : "ddl",
                formEle = document.getElementById("ctl00_ContentPlaceHolder1_req_" + key);
        
            if(!!this.frequired) {
            	if(this.fkey=='f8' && formEle==null) {return;}
                Page_Validators.push(document.getElementById("ctl00_ContentPlaceHolder1_req_" + key));
        		
                formEle.controltovalidate = "ctl00_ContentPlaceHolder1_" + postFix + key;
                formEle.errormessage = $("#ctl00_ContentPlaceHolder1_" + key).html();
                formEle.display = "None";
                formEle.evaluationfunction = "RequiredFieldValidatorEvaluateIsValid";
                formEle.initialvalue = "";
        
                if(this.fkey === 'f4') { //for email
                    Page_Validators.push(document.getElementById("ctl00_ContentPlaceHolder1_RegularExpressionValidator1"))
        
                    var ctl00_ContentPlaceHolder1_RegularExpressionValidator1 = document.getElementById("ctl00_ContentPlaceHolder1_RegularExpressionValidator1");
                    ctl00_ContentPlaceHolder1_RegularExpressionValidator1.controltovalidate ="ctl00_ContentPlaceHolder1_tbxf4";
                    ctl00_ContentPlaceHolder1_RegularExpressionValidator1.errormessage = $("#ctl00_ContentPlaceHolder1_f4").html() + " (<%=mustbevalid%>)";
                    ctl00_ContentPlaceHolder1_RegularExpressionValidator1.display = "None";
                    ctl00_ContentPlaceHolder1_RegularExpressionValidator1.evaluationfunction = "RegularExpressionValidatorEvaluateIsValid";
                    ctl00_ContentPlaceHolder1_RegularExpressionValidator1.validationexpression = "\\w+([-+.\']\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*";
                }
            }
        });
        
        var Page_ValidationActive = false;
        if (typeof(ValidatorOnLoad) == "function") {
            var userInfo = localStorage.getItem('userInfo'),
            userSession = !!userInfo ? JSON.parse(userInfo) : {};
            if(!!userSession && !!userSession.f4 && userSession.lang === $("#sos-lang-val").val()) {            
                 BootstrapDialog.confirm({
                    title: 'Session exists!',
                    message: 'Hi '+ userSession.f1 + ' ' + userSession.f2+'! your session is still exists.',
                    draggable: true, // <-- Default value is false
                    btnCancelLabel: 'Start over', // <-- Default value is 'Cancel',
                    btnOKLabel: 'Resume',
                    btnOKClass: 'btn-primary',
                    callback: function(result) {
                        // result will be true if button was click, while it will be false if users close the dialog directly.
                        if(result) {
                            document.location.href = "survey";
                        }else {
                            localStorage.removeItem('userInfo');
                        }
                    }
                });
            }
            ValidatorOnLoad();
        }
        
        function ValidatorOnSubmit() {
            if (Page_ValidationActive) {
                return ValidatorCommonOnSubmit();
            } else {
                return true;
            }
        }
        //]]>
    </script>
    </form>
    <script type="text/javascript">
        var _gaq = _gaq || [];
        _gaq.push(['_setAccount', 'UA-36309826-1']);
        _gaq.push(['_trackPageview']);
        
        (function () {
            var ga = document.createElement('script');
            ga.type = 'text/javascript';
            ga.async = true;
            ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') +
            '.google-analytics.com/ga.js';
            var s = document.getElementsByTagName('script')[0];
            s.parentNode.insertBefore(ga, s);
        })();
        
    </script>
</html>
