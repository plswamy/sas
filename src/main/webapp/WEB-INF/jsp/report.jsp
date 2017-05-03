<!DOCTYPE html>
  <html xmlns="http://www.w3.org/1999/xhtml">
    <%@ page import="java.util.*" %>
    <head>
      <%
        String webContext = "";
      %>
      <script>
        var userSession = JSON.parse(localStorage.getItem("userInfo")),
        surveyProgress = {};

        if(!!userSession && !!userSession.email) {
          //user session is still alive, let's move-on.

          surveyProgress = !!userSession.fullData ? userSession.fullData : {};
          if(!!userSession.finished) {
            //TODO: let's continue to show report page.
            <%
              String scoreLable = "You scored ";
              int score = 0;
            %>
          } else {
            document.location.href = "survey";
          }
        } else {
          //user session got expired. let's re-direct to home page.
          document.location.href = "home";
        }

      </script>
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
      <title>Report Page</title>
      <link href="<%=webContext%>support/css/site.css" rel="stylesheet">
      <script type="text/javascript" async="" src="<%=webContext%>support/js/ga.js"></script>
      <script src="<%=webContext%>/support/lib/jquery-3.2.0.js"></script>
      <script type="text/javascript" async="" src="<%=webContext%>support/js/assessment.js"></script>
    </head>

    <body>
      <form name="reportForm" method="post" action="" id="reportForm">
        <div id="outer">
          <div id="header" class="inner">
            <div id="logo"></div>
          </div>
          <div id="content_wrap">
            <div class="inner">
              <div id="results" style="">
                <div class="results_header">
                  <a id="btnPrintPDF" href="return false;" target="_blank"></a>
                </div>
                <div class="content">
                  <div class="results_h2_wrap stripe">
                    <h2><%= scoreLable %> <span id="score"><%= score %></span>%</h2>
                  </div>
                  <div class="results_padding">
                    <div id="graph" class="action_needed"></div>

                    <script>
                      $(document).ready(function () {
                        var generateForm = function (sectionName){
                              var qNum = 0;
                              $.each(surveyProgress[sectionName], function(qid) {
                                qNum++;
                                if(this.val !== 'yes') {
                                  var tmpl = $('.question_template').clone(true);
                                  tmpl.find('.question_id').id = qid;
                                  tmpl.find('.question_number')[0].innerText = "Q" + qNum;
                                  tmpl.find('.question_text')[0].innerText = this.qry;
                                  tmpl.find('.question_desc')[0].innerText = "this is description for this question: " + this.qry;
                                  tmpl.show();
                                  $("." + sectionName + "_section")[0].appendChild(tmpl[0]);
                                }
                              });
                              if(qNum > 0) {
                                $("#" + sectionName).show();
                              }
                            };
                        generateForm('plan');
                        generateForm('do');
                        generateForm('check');
                      });
                    </script>


                    <div class="question_template" style="display: none;">
                      <div class="question_id clearfix row" style="display: block;">
                        <div class="left">
                          <div class="padding">
                            <span class="question_number"></span>
                            <p class="question_text"></p>
                          </div>
                        </div>
                        <div class="right">
                          <div class="padding">
                            <p class="last question_desc"></p>
                          </div>
                        </div>
                      </div>
                    </div>

                    <div id="plan" style="display: none;">
                      <div class="section_header"></div>
                      <div class="section_questions stripe">
                        <div class="white_line plan_section">

                        </div>
                      </div>
                    </div>

                    <div id="do" style="display: none;">
                      <div class="section_header"></div>
                      <div class="section_questions stripe">
                        <div class="white_line do_section">

                        </div>
                      </div>
                    </div>

                    <div id="check" style="display: none;">
                      <div class="section_header"></div>
                      <div class="section_questions stripe">
                        <div class="white_line check_section">

                        </div>
                      </div>
                    </div>


                    <h3>Integrated Travel Risk Mitigation, a Duty of Care Plan-Do-Check approach</h3>
                    <div class="diagram-area">
                      <a href="http://www.global.selfassessmenttool.com/img/diagram.png" target="_blank"><div class="diagram"></div></a>
                      <a href="http://www.global.selfassessmenttool.com/img/diagram.png" class="marginleft" target="_blank">Click here to open larger image of Integrated Travel Risk Mitigation</a>
                    </div>
                    <p>International SOS commissioned the first ever Duty of Care whitepaper. This reviews employers’ Duty of Care responsibilities and offers guidelines for the development of appropriate risk management strategies.</p>
                    <p>Following this sector first, our clients requested more research, tools and advice. Resulting in the commission of our Duty of Care and Travel Risk Management Global Benchmarking Study – the first comprehensive and authoritative research publication on the topic.</p>
                    <p>The paper outlines a framework for organisations to ensure they are adequately meeting their Duty of Care obligations. The framework follows the 'plan-do-check' approach.</p>
                    <p>For more information <a href="http://internationalsos.com/duty-of-care" target="_blank">internationalsos.com/duty-of-care</a> </p>
                    <h3>Need assistance with any of your responses or recommendations?</h3>
                    <p>Contact International SOS - <a href="mailto:inquiries@internationalsos.com">inquiries@internationalsos.com</a> | <a href="http://www.internationalsos.com/" target="_blank">www.internationalsos.com</a></p>
                    <p><em>The recommendations, suggested actions and broad maturity measure are for guidance purposes only and do not constitute formal advice. Please contact International SOS for customised analysis and recommendations specific to your organisation.</em></p>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div id="footer" class="inner">
            <img src="<%=webContext%>support/img/strapline.png" alt="Worldwide reach. Human touch.">
          </div>
        </div>
      </form>
    </body>
  </html>