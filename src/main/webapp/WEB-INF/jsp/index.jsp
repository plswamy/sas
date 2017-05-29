<!DOCTYPE html>
<%@ page import="java.util.*" %>
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>International SOS Self Assessment Tool</title>
        <script type="text/javascript" async="" src="support/js/ga.js"></script>
        <script src="support/lib/jquery-3.2.0.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
        <script src="support/js/countries2.js"></script>
        <script>
            function fnOnUpdateValidators() {
                var emailValScore = 0;
                var showMsg = false;
                for (var i = 0; i < Page_Validators.length; i++) {
                    var val = Page_Validators[i];
                    var ctrl = document.getElementById(val.controltovalidate);
                    if (ctrl != null) {
                        if (val.controltovalidate == "ctl00_ContentPlaceHolder1_tbxEmail") {
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
        <link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body>
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
                    console.log("======================== success : " + $("#ctl00_ContentPlaceHolder1_tbxEmail").val());
                    var userInfo = {
                        "email": $("#ctl00_ContentPlaceHolder1_tbxEmail").val()
                    };
                    localStorage.setItem("userInfo", JSON.stringify(userInfo));
                    //JSON.parse(localStorage.getItem('userInfo'))
                    return true;
                }
                //]]>
            </script>
            <%
                Hashtable<String, String> hs = (Hashtable<String, String>) request.getAttribute("labels");  
                System.out.println("labels length.....:"+hs.size());
                String welcomeHeader = hs.get("welcomeHeader");
                String welcomeDesc = hs.get("welcomeDesc");
                String[] welcomePoints = {"A broad indication of your organisations current maturity with regard to travel risk mitigation systems, processes and tools", "The level of remedial action required to minimise the risks facing your organisation and employees", "Recommended steps to improve your systems", "Outline of the Duty of Care Plan-Do-Check approach"};
                String welcomeFooter = hs.get("welcomeFooter");
                String regFormHeaderMsg = hs.get("regFormHeaderMsg");
                /*String welcomeHeader = "Welcome to the travel risk mitigation self-assessment tool.";
                String welcomeDesc = "This best practice travel risk mitigation tool is based on our Duty of Care Plan-Do-Check approach. At the end of this assessment you will receive a report outlining:";
                String[] welcomePoints = {"A broad indication of your organisations current maturity with regard to travel risk mitigation systems, processes and tools", "The level of remedial action required to minimise the risks facing your organisation and employees", "Recommended steps to improve your systems", "Outline of the Duty of Care Plan-Do-Check approach"};
                String welcomeFooter = "It should take you approximately 5 minutes to complete the review.";
                String regFormHeaderMsg = "Fill out the form below to begin your risk mitigation evaluation";*/
                String regFormHeaderErrorMsg = hs.get("regFormHeaderErrorMsg");;
                %>
            <div class="container">
                <div id="outer" class="row">
                    <div id="header" class="inner col-xs-12 col-sm-12 col-md-12 col-lg-12">
                        <div id="logo" class="pull-right"></div>
                    </div>
                    <div id="content_wrap" class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
                        <div class="inner col-xs-12 col-sm-12 col-md-12 col-lg-12">
                            <!--<div id="sections_home col-xs-12 col-sm-12 col-md-12 col-lg-12"></div>-->
                            <img class="cover-width" src="support/img/sections.jpg" alt="Sections">
                            <!--<picture> -> USE THIS BLOCK IF CLIENT PROVIDES MULTIPLE IMAGES TO BE SHOWN BASED ON VIEWPORT...
                                <source
                                media="(min-width: 650px)"
                                srcset="./support/img/sections_large.jpg">
                                <source
                                media="(min-width: 465px)"
                                srcset="./support/img/sections_medium.jpg">
                                <img
                                src="./support/img/sections_small.jpg"
                                alt="section image">
                                </picture>-->
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
                                        <div class="form-group col-xs-12 col-sm-6 col-md-6 col-lg-6">
										<%
											String firstName = hs.get("firstName");
										%>
                                            <label for="ctl00_ContentPlaceHolder1_tbxFirstName" id="ctl00_ContentPlaceHolder1_lblFirstName" class="required"><%=firstName%></label>
                                            <input class="form-control" name="ctl00$ContentPlaceHolder1$tbxFirstName" type="text" maxlength="40" id="ctl00_ContentPlaceHolder1_tbxFirstName" value="Rahul">
                                            <div id="ctl00_ContentPlaceHolder1_reqFirstName" style="color:Red;display:none;"></div>
                                        </div>
                                        <div class="form-group col-xs-12 col-sm-6 col-md-6 col-lg-6">
										<%
											String lastName = hs.get("lastName");
										%>
                                            <label for="ctl00_ContentPlaceHolder1_tbxLastName" id="ctl00_ContentPlaceHolder1_lblLastName" class="required"><%=lastName%></label>
                                            <input name="ctl00$ContentPlaceHolder1$tbxLastName" type="text" maxlength="40"
                                                id="ctl00_ContentPlaceHolder1_tbxLastName" value="Dravid" class="form-control">
                                            <div id="ctl00_ContentPlaceHolder1_Requiredfieldvalidator1"
                                                style="color:Red;display:none;"></div>
                                        </div>
                                        <div class="clearfix"></div>
                                        <div class="form-group col-xs-12 col-sm-6 col-md-6 col-lg-6">
                                          <%
											String jobTitle = hs.get("jobTitle");
										%>
                                            <label for="ctl00_ContentPlaceHolder1_tbxJobTitle"
                                                id="ctl00_ContentPlaceHolder1_lblJobTitle" class="required"><%=jobTitle%></label>
                                            <input class="form-control" name="ctl00$ContentPlaceHolder1$tbxJobTitle" type="text" maxlength="100"
                                                id="ctl00_ContentPlaceHolder1_tbxJobTitle" value="Coach">
                                            <div id="ctl00_ContentPlaceHolder1_Requiredfieldvalidator2"
                                                style="color:Red;display:none;"></div>
                                        </div>
                                        <div class="form-group col-xs-12 col-sm-6 col-md-6 col-lg-6">
										<% String email=hs.get("email");
										%>
                                            <label for="ctl00_ContentPlaceHolder1_tbxEmail"
                                                id="ctl00_ContentPlaceHolder1_lblEmail" class="required"><%= email%></label>
                                            <input class="form-control" name="ctl00$ContentPlaceHolder1$tbxEmail" type="text" maxlength="100"
                                                id="ctl00_ContentPlaceHolder1_tbxEmail" value="rahul.dravid@india.com">
                                            <div id="ctl00_ContentPlaceHolder1_Requiredfieldvalidator3"
                                                style="color:Red;display:none;"></div>
                                            <div id="ctl00_ContentPlaceHolder1_RegularExpressionValidator1"
                                                style="color:Red;display:none;"></div>
                                        </div>
                                        <div class="clearfix"></div>
                                        <div class="form-group col-xs-12 col-sm-6 col-md-6 col-lg-6">
										<% String company=hs.get("company");
										%>
                                            <label for="ctl00_ContentPlaceHolder1_tbxCompany"
                                                id="ctl00_ContentPlaceHolder1_lblCompany" class="required"><%=company%></label>
                                            <input class="form-control" name="ctl00$ContentPlaceHolder1$tbxCompany" type="text" maxlength="100"
                                                id="ctl00_ContentPlaceHolder1_tbxCompany" value="BCCI">
                                            <div id="ctl00_ContentPlaceHolder1_Requiredfieldvalidator4"
                                                style="color:Red;display:none;"></div>
                                        </div>
                                        <div class="form-group col-xs-12 col-sm-6 col-md-6 col-lg-6">
                                        <% String businessIndustry=hs.get("businessIndustry");
										%>
                                            <label for="ctl00_ContentPlaceHolder1_ddlBusinessIndustry" class="required"
                                                id="ctl00_ContentPlaceHolder1_lblBusinessIndustry"><%=businessIndustry%></label>
										<%
											String pleaseSelect = hs.get("pleaseselect");
										%>
                                            <select class="form-control" name="ctl00$ContentPlaceHolder1$ddlBusinessIndustry"
                                                id="ctl00_ContentPlaceHolder1_ddlBusinessIndustry"
                                                value="Aviation: BGA">
                                                <option value=""><%=pleaseSelect%>...chvsr</option>
                                                <option value="Agent">Agent</option>
                                                <option value="Automobile, Aerospace and Defence Industry">Automobile,
                                                    Aerospace and Defence Industry
                                                </option>
                                                <option value="Aviation Commercial">Aviation Commercial</option>
                                                <option selected=selected value="Aviation: BGA">Aviation: BGA</option>
                                                <option value="Aviation: Fractional Owners">Aviation: Fractional Owners
                                                </option>
                                                <option value="Aviation: Mgt co/Charter Operator">Aviation: Mgt co/Charter
                                                    Operator
                                                </option>
                                                <option value="Aviation: OEM">Aviation: OEM</option>
                                                <option value="Bank and Financial Services">Bank and Financial Services
                                                </option>
                                                <option value="Broker">Broker</option>
                                                <option value="Business Services">Business Services</option>
                                                <option value="Construction">Construction</option>
                                                <option value="Corporate Office">Corporate Office</option>
                                                <option value="Credit Card companies">Credit Card companies</option>
                                                <option value="Education">Education</option>
                                                <option value="Energy">Energy</option>
                                                <option value="Food Industries">Food Industries</option>
                                                <option value="Government - Others">Government - Others</option>
                                                <option value="Government - Tricare">Government - Tricare</option>
                                                <option value="Health">Health</option>
                                                <option value="Heavy Machinery and Manufacturing">Heavy Machinery and
                                                    Manufacturing
                                                </option>
                                                <option value="High Tech, Info Tech and Electronics">High Tech, Info Tech and
                                                    Electronics
                                                </option>
                                                <option value="Individual">Individual</option>
                                                <option value="Life Insurer">Life Insurer</option>
                                                <option value="Maritime Commercial">Maritime Commercial</option>
                                                <option value="Maritime: Cruise Lines">Maritime: Cruise Lines</option>
                                                <option value="Maritime: Luxury Yachts">Maritime: Luxury Yachts</option>
                                                <option value="Media and Communication, Entertainment">Media and
                                                    Communication, Entertainment
                                                </option>
                                                <option value="Medical Services Location">Medical Services Location</option>
                                                <option value="Mining - Production">Mining - Production</option>
                                                <option value="Multi Industries">Multi Industries</option>
                                                <option value="Non Governmental Organisations">Non Governmental
                                                    Organisations
                                                </option>
                                                <option value="Offshore">Offshore</option>
                                                <option value="Oil and Gas Extraction">Oil and Gas Extraction</option>
                                                <option value="Pharmaceuticals">Pharmaceuticals</option>
                                                <option value="Property &amp; Casualty Insurer">Property &amp; Casualty
                                                    Insurer
                                                </option>
                                                <option value="Pulp and Paper">Pulp and Paper</option>
                                                <option value="Retail and Consumer Goods">Retail and Consumer Goods</option>
                                                <option value="Support Activities - Oil &amp; Gas/Mining">Support Activities -
                                                    Oil &amp; Gas/Mining
                                                </option>
                                                <option value="Trading">Trading</option>
                                                <option value="Transport Services">Transport Services</option>
                                                <option value="Travel Agent">Travel Agent</option>
                                                <option value="Travel, Tourism and Hospitality">Travel, Tourism and
                                                    Hospitality
                                                </option>
                                            </select>
                                            <div id="ctl00_ContentPlaceHolder1_Requiredfieldvalidator5"
                                                style="color:Red;display:none;"></div>
                                        </div>
                                        <div class="clearfix"></div>
                                        <div class="form-group col-xs-12 col-sm-6 col-md-6 col-lg-6">
										<% String country=hs.get("country");
										%>
                                            <label for="ctl00_ContentPlaceHolder1_ddlCountry"
                                                id="ctl00_ContentPlaceHolder1_lblCountry" class="required"><%=country%></label>
                                            <select class="form-control" name="ctl00$ContentPlaceHolder1$ddlCountry" value="India"
                                                id="ctl00_ContentPlaceHolder1_ddlCountry"
                                                onchange="load_states(&#39;ctl00_ContentPlaceHolder1_ddlState&#39;,this.selectedIndex);">
                                                <option value="">Please select...</option>
                                                <option value="Afghanistan">Afghanistan</option>
                                                <option value="Aland Islands">Aland Islands</option>
                                                <option value="Albania">Albania</option>
                                                <option value="Algeria">Algeria</option>
                                                <option value="American Samoa">American Samoa</option>
                                                <option value="Andorra">Andorra</option>
                                                <option value="Angola">Angola</option>
                                                <option value="Anguilla">Anguilla</option>
                                                <option value="Antarctica">Antarctica</option>
                                                <option value="Antigua and Barbuda">Antigua and Barbuda</option>
                                                <option value="Argentina">Argentina</option>
                                                <option value="Armenia">Armenia</option>
                                                <option value="Aruba">Aruba</option>
                                                <option value="Australia">Australia</option>
                                                <option value="Austria">Austria</option>
                                                <option value="Azerbaijan">Azerbaijan</option>
                                                <option value="Bahamas">Bahamas</option>
                                                <option value="Bahrain">Bahrain</option>
                                                <option value="Bangladesh">Bangladesh</option>
                                                <option value="Barbados">Barbados</option>
                                                <option value="Belarus">Belarus</option>
                                                <option value="Belgium">Belgium</option>
                                                <option value="Belize">Belize</option>
                                                <option value="Benin">Benin</option>
                                                <option value="Bermuda">Bermuda</option>
                                                <option value="Bhutan">Bhutan</option>
                                                <option value="Bolivia">Bolivia</option>
                                                <option value="Bonaire, Sint Eustatius and Saba">Bonaire, Sint Eustatius and
                                                    Saba
                                                </option>
                                                <option value="Bosnia and Herzegovina">Bosnia and Herzegovina</option>
                                                <option value="Botswana">Botswana</option>
                                                <option value="Bouvet Island">Bouvet Island</option>
                                                <option value="Brazil">Brazil</option>
                                                <option value="British Antartic Territory">British Antartic Territory</option>
                                                <option value="British Indian Ocean Territory">British Indian Ocean
                                                    Territory
                                                </option>
                                                <option value="British Virgin Islands">British Virgin Islands</option>
                                                <option value="Brunei Darussalam">Brunei Darussalam</option>
                                                <option value="Bulgaria">Bulgaria</option>
                                                <option value="Burkina Faso">Burkina Faso</option>
                                                <option value="Burundi">Burundi</option>
                                                <option value="Cambodia">Cambodia</option>
                                                <option value="Cameroon">Cameroon</option>
                                                <option value="Canada">Canada</option>
                                                <option value="Cape Verde">Cape Verde</option>
                                                <option value="Cayman Islands">Cayman Islands</option>
                                                <option value="Central African Republic">Central African Republic</option>
                                                <option value="Chad">Chad</option>
                                                <option value="Chile">Chile</option>
                                                <option value="China">China</option>
                                                <option value="Christmas Island">Christmas Island</option>
                                                <option value="Cocos (Keeling) Islands">Cocos (Keeling) Islands</option>
                                                <option value="Colombia">Colombia</option>
                                                <option value="Comoros">Comoros</option>
                                                <option value="Congo">Congo</option>
                                                <option value="Congo, Democratic Republic">Congo, Democratic Republic</option>
                                                <option value="Cook Islands">Cook Islands</option>
                                                <option value="Costa Rica">Costa Rica</option>
                                                <option value="Cote D&#39;Ivoire">Cote D'Ivoire</option>
                                                <option value="Croatia">Croatia</option>
                                                <option value="Cuba">Cuba</option>
                                                <option value="Curacao">Curacao</option>
                                                <option value="Cyprus">Cyprus</option>
                                                <option value="Czech Republic">Czech Republic</option>
                                                <option value="Denmark">Denmark</option>
                                                <option value="Djibouti">Djibouti</option>
                                                <option value="Dominica">Dominica</option>
                                                <option value="Dominican Republic">Dominican Republic</option>
                                                <option value="East Timor">East Timor</option>
                                                <option value="Ecuador">Ecuador</option>
                                                <option value="Egypt">Egypt</option>
                                                <option value="El Salvador">El Salvador</option>
                                                <option value="Equatorial Guinea">Equatorial Guinea</option>
                                                <option value="Eritrea">Eritrea</option>
                                                <option value="Estonia">Estonia</option>
                                                <option value="Ethiopia">Ethiopia</option>
                                                <option value="Falkland Islands (Islas Malvinas)">Falkland Islands (Islas
                                                    Malvinas)
                                                </option>
                                                <option value="Faroe Islands">Faroe Islands</option>
                                                <option value="Fiji">Fiji</option>
                                                <option value="Finland">Finland</option>
                                                <option value="France">France</option>
                                                <option value="French Guiana">French Guiana</option>
                                                <option value="French Polynesia">French Polynesia</option>
                                                <option value="French Southern and Antarctic Lands">French Southern and
                                                    Antarctic Lands
                                                </option>
                                                <option value="Gabon">Gabon</option>
                                                <option value="Gambia">Gambia</option>
                                                <option value="Georgia">Georgia</option>
                                                <option value="Germany">Germany</option>
                                                <option value="Ghana">Ghana</option>
                                                <option value="Gibraltar">Gibraltar</option>
                                                <option value="Greece">Greece</option>
                                                <option value="Greenland">Greenland</option>
                                                <option value="Grenada">Grenada</option>
                                                <option value="Guadeloupe">Guadeloupe</option>
                                                <option value="Guam">Guam</option>
                                                <option value="Guatemala">Guatemala</option>
                                                <option value="Guernsey">Guernsey</option>
                                                <option value="Guinea">Guinea</option>
                                                <option value="Guinea-Bissau">Guinea-Bissau</option>
                                                <option value="Guyana">Guyana</option>
                                                <option value="Haiti">Haiti</option>
                                                <option value="Heard Island &amp; McDonald Islands">Heard Island &amp;
                                                    McDonald Islands
                                                </option>
                                                <option value="Holy See (Vatican City)">Holy See (Vatican City)</option>
                                                <option value="Honduras">Honduras</option>
                                                <option value="Hong Kong, SAR">Hong Kong, SAR</option>
                                                <option value="Hungary">Hungary</option>
                                                <option value="Iceland">Iceland</option>
                                                <option selected=selected value="India">India</option>
                                                <option value="Indonesia">Indonesia</option>
                                                <option value="Iran">Iran</option>
                                                <option value="Iraq">Iraq</option>
                                                <option value="Ireland">Ireland</option>
                                                <option value="Israel">Israel</option>
                                                <option value="Italy">Italy</option>
                                                <option value="Jamaica">Jamaica</option>
                                                <option value="Japan">Japan</option>
                                                <option value="Jersey">Jersey</option>
                                                <option value="Jordan">Jordan</option>
                                                <option value="Kazakhstan">Kazakhstan</option>
                                                <option value="Kenya">Kenya</option>
                                                <option value="Kerguelen Islands">Kerguelen Islands</option>
                                                <option value="Kiribati">Kiribati</option>
                                                <option value="Korea, North">Korea, North</option>
                                                <option value="Korea, South">Korea, South</option>
                                                <option value="Kosovo">Kosovo</option>
                                                <option value="Kuwait">Kuwait</option>
                                                <option value="Kyrgyzstan">Kyrgyzstan</option>
                                                <option value="Laos">Laos</option>
                                                <option value="Latvia">Latvia</option>
                                                <option value="Lebanon">Lebanon</option>
                                                <option value="Lesotho">Lesotho</option>
                                                <option value="Liberia">Liberia</option>
                                                <option value="Libya">Libya</option>
                                                <option value="Liechtenstein">Liechtenstein</option>
                                                <option value="Lithuania">Lithuania</option>
                                                <option value="Luxembourg">Luxembourg</option>
                                                <option value="Macao, SAR">Macao, SAR</option>
                                                <option value="Macedonia">Macedonia</option>
                                                <option value="Madagascar">Madagascar</option>
                                                <option value="Malawi">Malawi</option>
                                                <option value="Malaysia">Malaysia</option>
                                                <option value="Maldives">Maldives</option>
                                                <option value="Mali">Mali</option>
                                                <option value="Malta">Malta</option>
                                                <option value="Man, Isle of">Man, Isle of</option>
                                                <option value="Marshall Islands">Marshall Islands</option>
                                                <option value="Martinique">Martinique</option>
                                                <option value="Mauritania">Mauritania</option>
                                                <option value="Mauritius">Mauritius</option>
                                                <option value="Mayotte">Mayotte</option>
                                                <option value="Mexico">Mexico</option>
                                                <option value="Micronesia, Federated States">Micronesia, Federated States
                                                </option>
                                                <option value="Midway Islands">Midway Islands</option>
                                                <option value="Moldova">Moldova</option>
                                                <option value="Monaco">Monaco</option>
                                                <option value="Mongolia">Mongolia</option>
                                                <option value="Montenegro">Montenegro</option>
                                                <option value="Montserrat">Montserrat</option>
                                                <option value="Morocco">Morocco</option>
                                                <option value="Mozambique">Mozambique</option>
                                                <option value="Myanmar">Myanmar</option>
                                                <option value="Namibia">Namibia</option>
                                                <option value="Nauru">Nauru</option>
                                                <option value="Nepal">Nepal</option>
                                                <option value="Netherland Antilles">Netherland Antilles</option>
                                                <option value="Netherlands">Netherlands</option>
                                                <option value="New Caledonia">New Caledonia</option>
                                                <option value="New Zealand">New Zealand</option>
                                                <option value="Nicaragua">Nicaragua</option>
                                                <option value="Niger">Niger</option>
                                                <option value="Nigeria">Nigeria</option>
                                                <option value="Niue">Niue</option>
                                                <option value="Norfolk Island">Norfolk Island</option>
                                                <option value="Northern Mariana Islands">Northern Mariana Islands</option>
                                                <option value="Norway">Norway</option>
                                                <option value="Oman">Oman</option>
                                                <option value="Pakistan">Pakistan</option>
                                                <option value="Palau">Palau</option>
                                                <option value="Panama">Panama</option>
                                                <option value="Papua New Guinea">Papua New Guinea</option>
                                                <option value="Paraguay">Paraguay</option>
                                                <option value="Peru">Peru</option>
                                                <option value="Philippines">Philippines</option>
                                                <option value="Pitcairn Islands">Pitcairn Islands</option>
                                                <option value="Poland">Poland</option>
                                                <option value="Portugal">Portugal</option>
                                                <option value="Puerto Rico">Puerto Rico</option>
                                                <option value="Qatar">Qatar</option>
                                                <option value="Reunion">Reunion</option>
                                                <option value="Romania">Romania</option>
                                                <option value="Russia">Russia</option>
                                                <option value="Rwanda">Rwanda</option>
                                                <option value="Saint Barthelemy">Saint Barthelemy</option>
                                                <option value="Saint Helena">Saint Helena</option>
                                                <option value="Saint Kitts and Nevis">Saint Kitts and Nevis</option>
                                                <option value="Saint Lucia">Saint Lucia</option>
                                                <option value="Saint Martin (French Part)">Saint Martin (French Part)</option>
                                                <option value="Saint Pierre and Miquelon">Saint Pierre and Miquelon</option>
                                                <option value="Saint Vincent and the Grenadines">Saint Vincent and the
                                                    Grenadines
                                                </option>
                                                <option value="Samoa">Samoa</option>
                                                <option value="San Marino">San Marino</option>
                                                <option value="Sao Tome and Principe">Sao Tome and Principe</option>
                                                <option value="Saudi Arabia">Saudi Arabia</option>
                                                <option value="Senegal">Senegal</option>
                                                <option value="Serbia">Serbia</option>
                                                <option value="Seychelles">Seychelles</option>
                                                <option value="Sierra Leone">Sierra Leone</option>
                                                <option value="Singapore">Singapore</option>
                                                <option value="Sint Maarten (Dutch Part)">Sint Maarten (Dutch Part)</option>
                                                <option value="Slovakia">Slovakia</option>
                                                <option value="Slovenia">Slovenia</option>
                                                <option value="Solomon Islands">Solomon Islands</option>
                                                <option value="Somalia">Somalia</option>
                                                <option value="South Africa">South Africa</option>
                                                <option value="South Georgia and the South Sandwich Islands">South Georgia and
                                                    the South Sandwich Islands
                                                </option>
                                                <option value="Spain">Spain</option>
                                                <option value="Sri Lanka">Sri Lanka</option>
                                                <option value="Sudan">Sudan</option>
                                                <option value="Suriname">Suriname</option>
                                                <option value="Svalbard">Svalbard</option>
                                                <option value="Swaziland">Swaziland</option>
                                                <option value="Sweden">Sweden</option>
                                                <option value="Switzerland">Switzerland</option>
                                                <option value="Syrian Arab Republic">Syrian Arab Republic</option>
                                                <option value="Taiwan, ROC">Taiwan, ROC</option>
                                                <option value="Tajikistan">Tajikistan</option>
                                                <option value="Tanzania">Tanzania</option>
                                                <option value="Thailand">Thailand</option>
                                                <option value="Togo">Togo</option>
                                                <option value="Tokelau">Tokelau</option>
                                                <option value="Tonga">Tonga</option>
                                                <option value="Trinidad and Tobago">Trinidad and Tobago</option>
                                                <option value="Tunisia">Tunisia</option>
                                                <option value="Turkey">Turkey</option>
                                                <option value="Turkmenistan">Turkmenistan</option>
                                                <option value="Turks and Caicos Islands">Turks and Caicos Islands</option>
                                                <option value="Tuvalu">Tuvalu</option>
                                                <option value="Uganda">Uganda</option>
                                                <option value="Ukraine">Ukraine</option>
                                                <option value="United Arab Emirates">United Arab Emirates</option>
                                                <option value="United Kingdom">United Kingdom</option>
                                                <option value="United States">United States</option>
                                                <option value="Uruguay">Uruguay</option>
                                                <option value="US Virgin Islands">US Virgin Islands</option>
                                                <option value="Uzbekistan">Uzbekistan</option>
                                                <option value="Vanuatu">Vanuatu</option>
                                                <option value="Venezuela">Venezuela</option>
                                                <option value="Vietnam">Vietnam</option>
                                                <option value="Wallis and Futuna">Wallis and Futuna</option>
                                                <option value="West Bank-Gaza Strip">West Bank-Gaza Strip</option>
                                                <option value="Western Sahara">Western Sahara</option>
                                                <option value="Yemen">Yemen</option>
                                                <option value="Zambia">Zambia</option>
                                                <option value="Zimbabwe">Zimbabwe</option>
                                            </select>
                                            <div id="ctl00_ContentPlaceHolder1_Requiredfieldvalidator6"
                                                style="color:Red;display:none;"></div>
                                        </div>
                                        <div class="form-group col-xs-12 col-sm-6 col-md-6 col-lg-6">
										<% String state=hs.get("state");
										%>
                                            <label for="ctl00_ContentPlaceHolder1_ddlState"
                                                id="ctl00_ContentPlaceHolder1_lblState" class="required"><%=state%></label>
                                            <select class="form-control" name="ctl00$ContentPlaceHolder1$ddlState"
                                                id="ctl00_ContentPlaceHolder1_ddlState">
                                                <option value="">Choose country first...</option>
                                            </select>
                                            <div id="ctl00_ContentPlaceHolder1_Requiredfieldvalidator7"
                                                style="color:Red;display:none;"></div>
                                        </div>
                                        <div>
                                            <input type="hidden" name="ctl00$ContentPlaceHolder1$hidCountryCode"
                                                id="ctl00_ContentPlaceHolder1_hidCountryCode">
                                            <input type="hidden" name="ctl00$ContentPlaceHolder1$hidStateCode"
                                                id="ctl00_ContentPlaceHolder1_hidStateCode">
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
                                        <div class="clearfix"></div>
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
    </body>
    <script language="javascript">
        $(document).ready(function () {
        
        $('#ctl00_ContentPlaceHolder1_btnRegister').html(
        "Start <span class='arrow'></span>");
        load_countries('ctl00_ContentPlaceHolder1_ddlCountry');
        
        $('#ctl00_ContentPlaceHolder1_ddlCountry').change(function () {
        $('#ctl00_ContentPlaceHolder1_hidCountryCode').val($(this).val());
        $('#ctl00_ContentPlaceHolder1_hidStateCode').val(
        $('#ctl00_ContentPlaceHolder1_ddlState').val());
        
        });
        
        $('#ctl00_ContentPlaceHolder1_ddlState').change(function () {
        $('#ctl00_ContentPlaceHolder1_hidStateCode').val(
        $('#ctl00_ContentPlaceHolder1_ddlState').val());
        });
        });
    </script>
    <script type="text/javascript">
        //<![CDATA[
        var Page_Validators = new Array(document.getElementById(
        "ctl00_ContentPlaceHolder1_reqFirstName"), document.getElementById(
        "ctl00_ContentPlaceHolder1_Requiredfieldvalidator1"), document.getElementById(
        "ctl00_ContentPlaceHolder1_Requiredfieldvalidator2"), document.getElementById(
        "ctl00_ContentPlaceHolder1_Requiredfieldvalidator3"), document.getElementById(
        "ctl00_ContentPlaceHolder1_RegularExpressionValidator1"), document.getElementById(
        "ctl00_ContentPlaceHolder1_Requiredfieldvalidator4"), document.getElementById(
        "ctl00_ContentPlaceHolder1_Requiredfieldvalidator5"), document.getElementById(
        "ctl00_ContentPlaceHolder1_Requiredfieldvalidator6"), document.getElementById(
        "ctl00_ContentPlaceHolder1_Requiredfieldvalidator7"));
        //]]>
    </script>
    <script type="text/javascript">
        //<![CDATA[
        var ctl00_ContentPlaceHolder1_reqFirstName = document.all ?
        document.all["ctl00_ContentPlaceHolder1_reqFirstName"] :
        document.getElementById(
        "ctl00_ContentPlaceHolder1_reqFirstName");
        ctl00_ContentPlaceHolder1_reqFirstName.controltovalidate =
        "ctl00_ContentPlaceHolder1_tbxFirstName";
        ctl00_ContentPlaceHolder1_reqFirstName.errormessage = "First Name";
        ctl00_ContentPlaceHolder1_reqFirstName.display = "None";
        ctl00_ContentPlaceHolder1_reqFirstName.evaluationfunction =
        "RequiredFieldValidatorEvaluateIsValid";
        ctl00_ContentPlaceHolder1_reqFirstName.initialvalue = "";
        var ctl00_ContentPlaceHolder1_Requiredfieldvalidator1 = document.all ?
        document.all["ctl00_ContentPlaceHolder1_Requiredfieldvalidator1"] :
        document.getElementById(
        "ctl00_ContentPlaceHolder1_Requiredfieldvalidator1");
        ctl00_ContentPlaceHolder1_Requiredfieldvalidator1.controltovalidate =
        "ctl00_ContentPlaceHolder1_tbxLastName";
        ctl00_ContentPlaceHolder1_Requiredfieldvalidator1.errormessage = "Last Name";
        ctl00_ContentPlaceHolder1_Requiredfieldvalidator1.display = "None";
        ctl00_ContentPlaceHolder1_Requiredfieldvalidator1.evaluationfunction =
        "RequiredFieldValidatorEvaluateIsValid";
        ctl00_ContentPlaceHolder1_Requiredfieldvalidator1.initialvalue = "";
        var ctl00_ContentPlaceHolder1_Requiredfieldvalidator2 = document.all ?
        document.all["ctl00_ContentPlaceHolder1_Requiredfieldvalidator2"] :
        document.getElementById(
        "ctl00_ContentPlaceHolder1_Requiredfieldvalidator2");
        ctl00_ContentPlaceHolder1_Requiredfieldvalidator2.controltovalidate =
        "ctl00_ContentPlaceHolder1_tbxJobTitle";
        ctl00_ContentPlaceHolder1_Requiredfieldvalidator2.errormessage = "Job Title";
        ctl00_ContentPlaceHolder1_Requiredfieldvalidator2.display = "None";
        ctl00_ContentPlaceHolder1_Requiredfieldvalidator2.evaluationfunction =
        "RequiredFieldValidatorEvaluateIsValid";
        ctl00_ContentPlaceHolder1_Requiredfieldvalidator2.initialvalue = "";
        var ctl00_ContentPlaceHolder1_Requiredfieldvalidator3 = document.all ?
        document.all["ctl00_ContentPlaceHolder1_Requiredfieldvalidator3"] :
        document.getElementById(
        "ctl00_ContentPlaceHolder1_Requiredfieldvalidator3");
        ctl00_ContentPlaceHolder1_Requiredfieldvalidator3.controltovalidate =
        "ctl00_ContentPlaceHolder1_tbxEmail";
        ctl00_ContentPlaceHolder1_Requiredfieldvalidator3.errormessage = "Email";
        ctl00_ContentPlaceHolder1_Requiredfieldvalidator3.display = "None";
        ctl00_ContentPlaceHolder1_Requiredfieldvalidator3.evaluationfunction =
        "RequiredFieldValidatorEvaluateIsValid";
        ctl00_ContentPlaceHolder1_Requiredfieldvalidator3.initialvalue = "";
        var ctl00_ContentPlaceHolder1_RegularExpressionValidator1 = document.all ?
        document.all["ctl00_ContentPlaceHolder1_RegularExpressionValidator1"] :
        document.getElementById(
        "ctl00_ContentPlaceHolder1_RegularExpressionValidator1");
        ctl00_ContentPlaceHolder1_RegularExpressionValidator1.controltovalidate =
        "ctl00_ContentPlaceHolder1_tbxEmail";
        ctl00_ContentPlaceHolder1_RegularExpressionValidator1.errormessage = "Email (must be valid)";
        ctl00_ContentPlaceHolder1_RegularExpressionValidator1.display = "None";
        ctl00_ContentPlaceHolder1_RegularExpressionValidator1.evaluationfunction =
        "RegularExpressionValidatorEvaluateIsValid";
        ctl00_ContentPlaceHolder1_RegularExpressionValidator1.validationexpression =
        "\\w+([-+.\']\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*";
        var ctl00_ContentPlaceHolder1_Requiredfieldvalidator4 = document.all ?
        document.all["ctl00_ContentPlaceHolder1_Requiredfieldvalidator4"] :
        document.getElementById(
        "ctl00_ContentPlaceHolder1_Requiredfieldvalidator4");
        ctl00_ContentPlaceHolder1_Requiredfieldvalidator4.controltovalidate =
        "ctl00_ContentPlaceHolder1_tbxCompany";
        ctl00_ContentPlaceHolder1_Requiredfieldvalidator4.errormessage = "Company";
        ctl00_ContentPlaceHolder1_Requiredfieldvalidator4.display = "None";
        ctl00_ContentPlaceHolder1_Requiredfieldvalidator4.evaluationfunction =
        "RequiredFieldValidatorEvaluateIsValid";
        ctl00_ContentPlaceHolder1_Requiredfieldvalidator4.initialvalue = "";
        var ctl00_ContentPlaceHolder1_Requiredfieldvalidator5 = document.all ?
        document.all["ctl00_ContentPlaceHolder1_Requiredfieldvalidator5"] :
        document.getElementById(
        "ctl00_ContentPlaceHolder1_Requiredfieldvalidator5");
        ctl00_ContentPlaceHolder1_Requiredfieldvalidator5.controltovalidate =
        "ctl00_ContentPlaceHolder1_ddlBusinessIndustry";
        ctl00_ContentPlaceHolder1_Requiredfieldvalidator5.errormessage = "Business Industry";
        ctl00_ContentPlaceHolder1_Requiredfieldvalidator5.display = "None";
        ctl00_ContentPlaceHolder1_Requiredfieldvalidator5.evaluationfunction =
        "RequiredFieldValidatorEvaluateIsValid";
        ctl00_ContentPlaceHolder1_Requiredfieldvalidator5.initialvalue = "";
        var ctl00_ContentPlaceHolder1_Requiredfieldvalidator6 = document.all ?
        document.all["ctl00_ContentPlaceHolder1_Requiredfieldvalidator6"] :
        document.getElementById(
        "ctl00_ContentPlaceHolder1_Requiredfieldvalidator6");
        ctl00_ContentPlaceHolder1_Requiredfieldvalidator6.controltovalidate =
        "ctl00_ContentPlaceHolder1_ddlCountry";
        ctl00_ContentPlaceHolder1_Requiredfieldvalidator6.errormessage = "Country";
        ctl00_ContentPlaceHolder1_Requiredfieldvalidator6.display = "None";
        ctl00_ContentPlaceHolder1_Requiredfieldvalidator6.evaluationfunction =
        "RequiredFieldValidatorEvaluateIsValid";
        ctl00_ContentPlaceHolder1_Requiredfieldvalidator6.initialvalue = "";
        var ctl00_ContentPlaceHolder1_Requiredfieldvalidator7 = document.all ?
        document.all["ctl00_ContentPlaceHolder1_Requiredfieldvalidator7"] :
        document.getElementById(
        "ctl00_ContentPlaceHolder1_Requiredfieldvalidator7");
        ctl00_ContentPlaceHolder1_Requiredfieldvalidator7.controltovalidate =
        "ctl00_ContentPlaceHolder1_ddlState";
        ctl00_ContentPlaceHolder1_Requiredfieldvalidator7.errormessage = "State";
        ctl00_ContentPlaceHolder1_Requiredfieldvalidator7.display = "None";
        ctl00_ContentPlaceHolder1_Requiredfieldvalidator7.evaluationfunction =
        "RequiredFieldValidatorEvaluateIsValid";
        ctl00_ContentPlaceHolder1_Requiredfieldvalidator7.initialvalue = "";
        //]]>
    </script>
    <script type="text/javascript">
        //<![CDATA[
        
        var Page_ValidationActive = false;
        if (typeof(ValidatorOnLoad) == "function") {
        var userInfo = localStorage.getItem('userInfo'),
        userSession = !!userInfo ? JSON.parse(userInfo) : {};
        if(!!userSession && !!userSession.email) {
        document.location.href = "survey";
        }
        ValidatorOnLoad();
        }
        
        function ValidatorOnSubmit() {
        if (Page_ValidationActive) {
        return ValidatorCommonOnSubmit();
        }
        else {
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