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

                    localStorage.setItem("userInfo", JSON.stringify(userInfo));
                    //JSON.parse(localStorage.getItem('userInfo'))
                    return true;
                }
                //]]>

                var userFormFields = {};
            
            <%
                Hashtable<String, String> hs = (Hashtable<String, String>) request.getAttribute("labels");  
                System.out.println("labels length.....:"+hs.size());
                String welcomeHeader = hs.get("welcomeHeader");
                String welcomeDesc = hs.get("welcomeDesc");
                String[] welcomePoints = {"A broad indication of your organisations current maturity with regard to travel risk mitigation systems, processes and tools", "The level of remedial action required to minimise the risks facing your organisation and employees", "Recommended steps to improve your systems", "Outline of the Duty of Care Plan-Do-Check approach"};
                String welcomeFooter = hs.get("welcomeFooter");
                String regFormHeaderMsg = hs.get("regFormHeaderMsg");
                String regFormHeaderErrorMsg = hs.get("regFormHeaderErrorMsg");
                String countryLabel = "Country";
                String businessIndustryLabel = "Business Industry";
                String stateLabel = "State";




                Hashtable<String, String> hmf1 = (Hashtable<String, String>) request.getAttribute("userformfields");

                System.out.println(hmf1);
                Set<String> hmf1Keys = hmf1.keySet();
                for(String key1: hmf1Keys){


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
                            <img class="cover-width" src="support/img/sections.jpg" alt="Sections">
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

                                        
                                        
                                        <div class="form-group form-field-f6 col-xs-12 col-sm-6 col-md-6 col-lg-6">
                                            <label for="ctl00_ContentPlaceHolder1_ddlBusinessIndustry" class="required"
                                                id="ctl00_ContentPlaceHolder1_lblBusinessIndustry"><%=businessIndustryLabel%></label>
										<%
											String pleaseSelect = hs.get("pleaseselect");
										%>
                                            <select class="form-control sos-index-select ddlBusinessIndustry user-form-field-f6" data-ddl="ddlBusinessIndustry" name="ctl00$ContentPlaceHolder1$ddlBusinessIndustry"
                                                id="ctl00_ContentPlaceHolder1_ddlf6"
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
                                            <div id="ctl00_ContentPlaceHolder1_req_f6"
                                                style="color:Red;display:none;"></div>
                                        </div>
                                        
                                        <div class="form-group form-field-f7 col-xs-12 col-sm-6 col-md-6 col-lg-6">
                                            <label for="ctl00_ContentPlaceHolder1_ddlCountry"
                                                id="ctl00_ContentPlaceHolder1_lblCountry" class="required"><%=countryLabel%></label>
                                            <select class="form-control sos-index-select ddlCountry user-form-field-f7" data-ddl="ddlCountry" name="ctl00$ContentPlaceHolder1$ddlCountry" value="India"
                                                id="ctl00_ContentPlaceHolder1_ddlf7"
                                                onchange="load_states(&#39;ctl00_ContentPlaceHolder1_ddlf8&#39;,this.selectedIndex);">
                                                <option value=""><%=pleaseSelect %></option>
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
                                            <div id="ctl00_ContentPlaceHolder1_req_f7"
                                                style="color:Red;display:none;"></div>
                                        </div>
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
                                            if(key1.equals("f6") || key1.equals("f7") || key1.equals("f8")) {
                                                    continue;
                                                }
                                            idx++;
                                            /*String fieldId = key1;
                                            String fieldInfo = hmf1.get(key1);
                                            System.out.println("Value of "+key1+" is: "+hmf1.get(key1));*/

                                            /*    f1: 1:1:type:displayname:show/hide:options   */


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

                                            
                                        %>
                                            
                                                <div class="form-group form-field-<%=fid%> col-xs-12 col-sm-6 col-md-6 col-lg-6" data-forder="<%=forder%>" >
                                                    <label for="ctl00_ContentPlaceHolder1_<%=fid%>" class="required" id="ctl00_ContentPlaceHolder1_<%=fid%>"><%= fdisplayname %></label>
                                                    <% if(ftype.equals("text")) { %>
                                                        <input class="form-control user-form-field-<%=fid%>" name="ctl00$ContentPlaceHolder1$tbx<%=fid%>" type="text" maxlength="40" id="ctl00_ContentPlaceHolder1_tbx<%=fid%>" value="">
                                                    <% } else { %>
                                                        <select class="form-control sos-index-select ddl<%=fid%> user-form-field-<%=fid%>" data-ddl="ddl<%=fid%>" name="ctl00$ContentPlaceHolder1$ddl<%=fid%>"
                                                            id="ctl00_ContentPlaceHolder1_ddl<%=fid%>">

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
                                                    %></div><%
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
    </body>
    <script language="javascript">
        $(document).ready(function () {
        
            $('#ctl00_ContentPlaceHolder1_btnRegister').html(
            "Start <span class='arrow'></span>");
            load_countries('ctl00_ContentPlaceHolder1_ddlf7');
            
            $('#ctl00_ContentPlaceHolder1_ddlf7').change(function () {
                $('#ctl00_ContentPlaceHolder1_hidCountryCode').val($(this).val());
                $('#ctl00_ContentPlaceHolder1_hidStateCode').val(
                $('#ctl00_ContentPlaceHolder1_ddlf8').val());            
                $(".ddlCountry").find(".sos-btn-danger").removeClass("sos-btn-danger");
            });
            
            $('#ctl00_ContentPlaceHolder1_ddlf8').change(function () {
                $('#ctl00_ContentPlaceHolder1_hidStateCode').val(
                $('#ctl00_ContentPlaceHolder1_ddlf8').val());
                $(".ddlState").find(".sos-btn-danger").removeClass("sos-btn-danger");
            });

            $('#ctl00_ContentPlaceHolder1_ddlf6').change(function () {
                $(".ddlBusinessIndustry").find(".sos-btn-danger").removeClass("sos-btn-danger");
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
        for(i=1;i<17;i++) {
            Page_Validators.push(document.getElementById("ctl00_ContentPlaceHolder1_req_f" + i));
        }
        Page_Validators.push(document.getElementById("ctl00_ContentPlaceHolder1_RegularExpressionValidator1")); // email regualr matching.       
        //]]>
    </script>

    <script type="text/javascript">
        //<![CDATA[

        // f1: firstname
        var ctl00_ContentPlaceHolder1_req_f1 = document.all ? document.all["ctl00_ContentPlaceHolder1_req_f1"] : document.getElementById("ctl00_ContentPlaceHolder1_req_f1");
        ctl00_ContentPlaceHolder1_req_f1.controltovalidate = "ctl00_ContentPlaceHolder1_tbxf1";
        ctl00_ContentPlaceHolder1_req_f1.errormessage = $("#ctl00_ContentPlaceHolder1_f1").html();
        ctl00_ContentPlaceHolder1_req_f1.display = "None";
        ctl00_ContentPlaceHolder1_req_f1.evaluationfunction = "RequiredFieldValidatorEvaluateIsValid";
        ctl00_ContentPlaceHolder1_req_f1.initialvalue = "";

        // f2: lastname
        var ctl00_ContentPlaceHolder1_req_f2 = document.all ? document.all["ctl00_ContentPlaceHolder1_req_f2"] : document.getElementById("ctl00_ContentPlaceHolder1_req_f2");
        ctl00_ContentPlaceHolder1_req_f2.controltovalidate = "ctl00_ContentPlaceHolder1_tbxf2";
        ctl00_ContentPlaceHolder1_req_f2.errormessage = $("#ctl00_ContentPlaceHolder1_f2").html();
        ctl00_ContentPlaceHolder1_req_f2.display = "None";
        ctl00_ContentPlaceHolder1_req_f2.evaluationfunction = "RequiredFieldValidatorEvaluateIsValid";
        ctl00_ContentPlaceHolder1_req_f2.initialvalue = "";

        // f3: jobtitle
        var ctl00_ContentPlaceHolder1_req_f3 = document.all ? document.all["ctl00_ContentPlaceHolder1_req_f3"] : document.getElementById("ctl00_ContentPlaceHolder1_req_f3");
        ctl00_ContentPlaceHolder1_req_f3.controltovalidate = "ctl00_ContentPlaceHolder1_tbxf3";
        ctl00_ContentPlaceHolder1_req_f3.errormessage = $("#ctl00_ContentPlaceHolder1_f3").html();
        ctl00_ContentPlaceHolder1_req_f3.display = "None";
        ctl00_ContentPlaceHolder1_req_f3.evaluationfunction = "RequiredFieldValidatorEvaluateIsValid";
        ctl00_ContentPlaceHolder1_req_f3.initialvalue = "";

        // f4: email
        var ctl00_ContentPlaceHolder1_req_f4 = document.all ? document.all["ctl00_ContentPlaceHolder1_req_f4"] : document.getElementById("ctl00_ContentPlaceHolder1_req_f4");
        ctl00_ContentPlaceHolder1_req_f4.controltovalidate = "ctl00_ContentPlaceHolder1_tbxf4";
        ctl00_ContentPlaceHolder1_req_f4.errormessage = $("#ctl00_ContentPlaceHolder1_f4").html();
        ctl00_ContentPlaceHolder1_req_f4.display = "None";
        ctl00_ContentPlaceHolder1_req_f4.evaluationfunction = "RequiredFieldValidatorEvaluateIsValid";
        ctl00_ContentPlaceHolder1_req_f4.initialvalue = "";

        var ctl00_ContentPlaceHolder1_RegularExpressionValidator1 = document.all ? document.all["ctl00_ContentPlaceHolder1_RegularExpressionValidator1"] : document.getElementById("ctl00_ContentPlaceHolder1_RegularExpressionValidator1");
        ctl00_ContentPlaceHolder1_RegularExpressionValidator1.controltovalidate ="ctl00_ContentPlaceHolder1_tbxf4";
        ctl00_ContentPlaceHolder1_RegularExpressionValidator1.errormessage = $("#ctl00_ContentPlaceHolder1_f4").html() + " (must be valid)";
        ctl00_ContentPlaceHolder1_RegularExpressionValidator1.display = "None";
        ctl00_ContentPlaceHolder1_RegularExpressionValidator1.evaluationfunction = "RegularExpressionValidatorEvaluateIsValid";
        ctl00_ContentPlaceHolder1_RegularExpressionValidator1.validationexpression = "\\w+([-+.\']\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*";

        // f5: company
        var ctl00_ContentPlaceHolder1_req_f5 = document.all ? document.all["ctl00_ContentPlaceHolder1_req_f5"] : document.getElementById("ctl00_ContentPlaceHolder1_req_f5");
        ctl00_ContentPlaceHolder1_req_f5.controltovalidate = "ctl00_ContentPlaceHolder1_tbxf5";
        ctl00_ContentPlaceHolder1_req_f5.errormessage = $("#ctl00_ContentPlaceHolder1_f5").html();
        ctl00_ContentPlaceHolder1_req_f5.display = "None";
        ctl00_ContentPlaceHolder1_req_f5.evaluationfunction = "RequiredFieldValidatorEvaluateIsValid";
        ctl00_ContentPlaceHolder1_req_f5.initialvalue = "";

        // f6: businessindustry
        var ctl00_ContentPlaceHolder1_req_f6 = document.all ? document.all["ctl00_ContentPlaceHolder1_req_f6"] : document.getElementById("ctl00_ContentPlaceHolder1_req_f6");
        ctl00_ContentPlaceHolder1_req_f6.controltovalidate = "ctl00_ContentPlaceHolder1_ddlf6";
        ctl00_ContentPlaceHolder1_req_f6.errormessage = $("#ctl00_ContentPlaceHolder1_f6").html();
        ctl00_ContentPlaceHolder1_req_f6.display = "None";
        ctl00_ContentPlaceHolder1_req_f6.evaluationfunction = "RequiredFieldValidatorEvaluateIsValid";
        ctl00_ContentPlaceHolder1_req_f6.initialvalue = "";

        // f7: country
        var ctl00_ContentPlaceHolder1_req_f7 = document.all ? document.all["ctl00_ContentPlaceHolder1_req_f7"] : document.getElementById("ctl00_ContentPlaceHolder1_req_f7");
        ctl00_ContentPlaceHolder1_req_f7.controltovalidate = "ctl00_ContentPlaceHolder1_ddlf7";
        ctl00_ContentPlaceHolder1_req_f7.errormessage = $("#ctl00_ContentPlaceHolder1_f7").html();
        ctl00_ContentPlaceHolder1_req_f7.display = "None";
        ctl00_ContentPlaceHolder1_req_f7.evaluationfunction = "RequiredFieldValidatorEvaluateIsValid";
        ctl00_ContentPlaceHolder1_req_f7.initialvalue = "";

        // f8: state
        var ctl00_ContentPlaceHolder1_req_f8 = document.all ? document.all["ctl00_ContentPlaceHolder1_req_f8"] : document.getElementById("ctl00_ContentPlaceHolder1_req_f8");
        ctl00_ContentPlaceHolder1_req_f8.controltovalidate = "ctl00_ContentPlaceHolder1_ddlf8";
        ctl00_ContentPlaceHolder1_req_f8.errormessage = $("#ctl00_ContentPlaceHolder1_f8").html();
        ctl00_ContentPlaceHolder1_req_f8.display = "None";
        ctl00_ContentPlaceHolder1_req_f8.evaluationfunction = "RequiredFieldValidatorEvaluateIsValid";
        ctl00_ContentPlaceHolder1_req_f8.initialvalue = "";

        // f9: aboutme
        var ctl00_ContentPlaceHolder1_req_f9 = document.all ? document.all["ctl00_ContentPlaceHolder1_req_f9"] : document.getElementById("ctl00_ContentPlaceHolder1_req_f9");
        ctl00_ContentPlaceHolder1_req_f9.controltovalidate = "ctl00_ContentPlaceHolder1_tbxf9";
        ctl00_ContentPlaceHolder1_req_f9.errormessage = $("#ctl00_ContentPlaceHolder1_f9").html();
        ctl00_ContentPlaceHolder1_req_f9.display = "None";
        ctl00_ContentPlaceHolder1_req_f9.evaluationfunction = "RequiredFieldValidatorEvaluateIsValid";
        ctl00_ContentPlaceHolder1_req_f9.initialvalue = "";

        // f10: gender
        var ctl00_ContentPlaceHolder1_req_f10 = document.all ? document.all["ctl00_ContentPlaceHolder1_req_f10"] : document.getElementById("ctl00_ContentPlaceHolder1_req_f10");
        ctl00_ContentPlaceHolder1_req_f10.controltovalidate = "ctl00_ContentPlaceHolder1_ddlf10";
        ctl00_ContentPlaceHolder1_req_f10.errormessage = $("#ctl00_ContentPlaceHolder1_f10").html();
        ctl00_ContentPlaceHolder1_req_f10.display = "None";
        ctl00_ContentPlaceHolder1_req_f10.evaluationfunction = "RequiredFieldValidatorEvaluateIsValid";
        ctl00_ContentPlaceHolder1_req_f10.initialvalue = "";

        // f11: qualifications
        var ctl00_ContentPlaceHolder1_req_f11 = document.all ? document.all["ctl00_ContentPlaceHolder1_req_f11"] : document.getElementById("ctl00_ContentPlaceHolder1_req_f11");
        ctl00_ContentPlaceHolder1_req_f11.controltovalidate = "ctl00_ContentPlaceHolder1_ddlf11";
        ctl00_ContentPlaceHolder1_req_f11.errormessage = $("#ctl00_ContentPlaceHolder1_f11").html();
        ctl00_ContentPlaceHolder1_req_f11.display = "None";
        ctl00_ContentPlaceHolder1_req_f11.evaluationfunction = "RequiredFieldValidatorEvaluateIsValid";
        ctl00_ContentPlaceHolder1_req_f11.initialvalue = "";

        // f12: expertise
        var ctl00_ContentPlaceHolder1_req_f12 = document.all ? document.all["ctl00_ContentPlaceHolder1_req_f12"] : document.getElementById("ctl00_ContentPlaceHolder1_req_f12");
        ctl00_ContentPlaceHolder1_req_f12.controltovalidate = "ctl00_ContentPlaceHolder1_ddlf12";
        ctl00_ContentPlaceHolder1_req_f12.errormessage = $("#ctl00_ContentPlaceHolder1_f12").html();
        ctl00_ContentPlaceHolder1_req_f12.display = "None";
        ctl00_ContentPlaceHolder1_req_f12.evaluationfunction = "RequiredFieldValidatorEvaluateIsValid";
        ctl00_ContentPlaceHolder1_req_f12.initialvalue = "";

        // f13: certifications
        var ctl00_ContentPlaceHolder1_req_f13 = document.all ? document.all["ctl00_ContentPlaceHolder1_req_f13"] : document.getElementById("ctl00_ContentPlaceHolder1_req_f13");
        ctl00_ContentPlaceHolder1_req_f13.controltovalidate = "ctl00_ContentPlaceHolder1_tbxf13";
        ctl00_ContentPlaceHolder1_req_f13.errormessage = $("#ctl00_ContentPlaceHolder1_f13").html();
        ctl00_ContentPlaceHolder1_req_f13.display = "None";
        ctl00_ContentPlaceHolder1_req_f13.evaluationfunction = "RequiredFieldValidatorEvaluateIsValid";
        ctl00_ContentPlaceHolder1_req_f13.initialvalue = "";

        // f14: hobbies
        var ctl00_ContentPlaceHolder1_req_f14 = document.all ? document.all["ctl00_ContentPlaceHolder1_req_f14"] : document.getElementById("ctl00_ContentPlaceHolder1_req_f14");
        ctl00_ContentPlaceHolder1_req_f14.controltovalidate = "ctl00_ContentPlaceHolder1_tbxf14";
        ctl00_ContentPlaceHolder1_req_f14.errormessage = $("#ctl00_ContentPlaceHolder1_f14").html();
        ctl00_ContentPlaceHolder1_req_f14.display = "None";
        ctl00_ContentPlaceHolder1_req_f14.evaluationfunction = "RequiredFieldValidatorEvaluateIsValid";
        ctl00_ContentPlaceHolder1_req_f14.initialvalue = "";

        // f15: domain
        var ctl00_ContentPlaceHolder1_req_f15 = document.all ? document.all["ctl00_ContentPlaceHolder1_req_f15"] : document.getElementById("ctl00_ContentPlaceHolder1_req_f15");
        ctl00_ContentPlaceHolder1_req_f15.controltovalidate = "ctl00_ContentPlaceHolder1_ddlf15";
        ctl00_ContentPlaceHolder1_req_f15.errormessage = $("#ctl00_ContentPlaceHolder1_f15").html();
        ctl00_ContentPlaceHolder1_req_f15.display = "None";
        ctl00_ContentPlaceHolder1_req_f15.evaluationfunction = "RequiredFieldValidatorEvaluateIsValid";
        ctl00_ContentPlaceHolder1_req_f15.initialvalue = "";

        // f16: contactnumber
        var ctl00_ContentPlaceHolder1_req_f16 = document.all ? document.all["ctl00_ContentPlaceHolder1_req_f16"] : document.getElementById("ctl00_ContentPlaceHolder1_req_f16");
        ctl00_ContentPlaceHolder1_req_f16.controltovalidate = "ctl00_ContentPlaceHolder1_tbxf16";
        ctl00_ContentPlaceHolder1_req_f16.errormessage = $("#ctl00_ContentPlaceHolder1_f16").html();
        ctl00_ContentPlaceHolder1_req_f16.display = "None";
        ctl00_ContentPlaceHolder1_req_f16.evaluationfunction = "RequiredFieldValidatorEvaluateIsValid";
        ctl00_ContentPlaceHolder1_req_f16.initialvalue = "";

        //]]>
    </script>
    <script type="text/javascript">
        //<![CDATA[
        
        var Page_ValidationActive = false;
        if (typeof(ValidatorOnLoad) == "function") {
        var userInfo = localStorage.getItem('userInfo'),
        userSession = !!userInfo ? JSON.parse(userInfo) : {};
        if(!!userSession && !!userSession.f4) {

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