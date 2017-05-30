<!DOCTYPE html>
  <%@page import="sas.bean.Question"%>
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
          //get survery progress done so far for the current user.
          surveyProgress = !!userSession.surveyProgress ? userSession.surveyProgress : {};

          // TODO: once all questions are having values, then re-direct to final/report page.
          //document.location.href = "report";
        } else {
          //user session got expired. let's re-direct to home page.
          document.location.href = "home";
        }
      </script>
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	  <meta name="viewport" content="width=device-width, initial-scale=1">
      <title>Survey Page</title>
      <link href="<%=webContext%>support/css/site.css" rel="stylesheet">
  <link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
      <%--<link href="<%=webContext%>support/lib/bootstrap.css" rel="stylesheet">--%>
      <script type="text/javascript" async="" src="<%=webContext%>support/js/ga.js"></script>
      <script src="<%=webContext%>/support/lib/jquery-3.2.0.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
      <%--<script src="<%=webContext%>/support/lib/bootstrap.js"></script>--%>
      <script type="text/javascript" async="" src="<%=webContext%>support/js/assessment.js"></script>
    </head>

    <body>

      <script>
        var planSection = {}, doSection = {}, checkSection = {}, allSections = {};

        <%
          Hashtable<String, List<Question>> hs = (Hashtable<String, List<Question>>) request.getAttribute("questions");  
          List<Question> list = hs.get("plan");
          int totalQuestions = 0;
          Question q = null;
          System.out.println(list.size());
          for(int i=0; i < list.size(); i++) {
        	  q = list.get(i);
        %>
          planSection["<%= q.getId() %>"] =  {
          "qry" : "<%= q.getText() %>",
          "img" : "<%= q.getImageName() %>"
        };
        <%
          }
        %>
          allSections["plan"] = planSection;
        <%

          HashMap<String,String> doSection =new HashMap<String,String>();
          doSection.put("d1", "Do you have a travel approval process that includes travel risk assessments?|do-8.png");
          doSection.put("d2", "Do your employees have access to relevant information & advice to support them when making these risk assessments?|do-9.png");
          doSection.put("d3", "Do you have plans in place if things go wrong?|do-10.png");
          doSection.put("d4", "Do you check the safety and security of hotels and accommodation?|do-11.png");
          doSection.put("d5", "Do you know how many RTA's (Road Traffic Accidents) your company has experienced in the last 3 years?|do-12.png");
          doSection.put("d6", "Do you assess the fitness for travel for expatriate or travelling staff?|do-13.png");
          doSection.put("d7", "Do you have a program to help employees understand and manage their existing health issues whist away?|do-14.png");
          doSection.put("d8", "Are your employees aware of your Travel Risk Mitigation plans and their responsibilities?|do-15.png");
          doSection.put("d9", "Do your employees receive training about the risks at the destinations they are travelling to?|do-16.png");
          doSection.put("d10", "Do your managers understand their responsibilities when approving travel?|do-17.png");
          doSection.put("d11", "Do you have a system in place to inform your people of a situation that may impact them?|do-18.png");
          doSection.put("d12", "Do you have a system in place to quickly account for employees in an emergency?|do-19.png");
          doSection.put("d13", "Do your employees have access to advice and support 24/7?|do-20.png");
          doSection.put("d14", "Do you have measures in place to check the health of employees returning to work?|do-21.png");

          for(Map.Entry d:doSection.entrySet()) {
            System.out.println("Question #" + ++totalQuestions + ": QuestionId : " + d.getKey()+":Question : "+d.getValue());
        %>
            doSection["<%= d.getKey() %>"] =  {
              "qry" : "<%= d.getValue() %>".split('|')[0],
              "img" : "<%= d.getValue() %>".split('|')[1]
              };
        <%
          }
        %>
          allSections["do"] = doSection;
        <%

          HashMap<String,String> checkSection =new HashMap<String,String>();
          checkSection.put("c1", "Are your plans and procedures tested for effectiveness?|check-22.png");
          checkSection.put("c2", "Do you have a system in place to ensure compliance with your policies and procedures|check-23.png");

          for(Map.Entry c:checkSection.entrySet()) {
            System.out.println("Question #" + ++totalQuestions + ": QuestionId : " + c.getKey()+":Question : "+c.getValue());
        %>
          checkSection["<%= c.getKey() %>"] =  {
          "qry" : "<%= c.getValue() %>".split('|')[0],
          "img" : "<%= c.getValue() %>".split('|')[1]
          };
        <%
          }
        %>
          allSections["check"] = checkSection;
        <%
          System.out.println("Total Question : " + totalQuestions);
        %>
        var deepObjectExtend = function (target, source) {
          for (var prop in source) {
            if (source.hasOwnProperty(prop)) {
              if (target[prop] && typeof source[prop] === 'object') {
                deepObjectExtend(target[prop], source[prop]);
              } else {
                target[prop] = source[prop];
              }
            }
          }
          return target;
        },
        currentValues = deepObjectExtend(surveyProgress, allSections),
        targetQuestion = undefined,
        currentSection = "",
        totalIndexOfCurrent = 0,
        indexOfCurrent = 0,
        fillForm = function(sectionObj) {
          totalIndexOfCurrent = 0,
          indexOfCurrent = 0;
          targetQuestion = undefined;
          $.each(sectionObj["plan"], function(qid) {
            if(this.val === undefined && targetQuestion === undefined) {
              totalIndexOfCurrent = indexOfCurrent;
              targetQuestion = this;
              targetQuestion.currentSection = "plan";
              targetQuestion.qid = qid;
            } else {
              indexOfCurrent++;
            }
          });

          if(targetQuestion === undefined) {
            indexOfCurrent = 0;
            totalIndexOfCurrent = 0;
            $.each(sectionObj["do"], function(qid) {
              if(this.val === undefined && targetQuestion === undefined) {
                totalIndexOfCurrent = indexOfCurrent;
                indexOfCurrent = totalIndexOfCurrent;
                targetQuestion = this;
                targetQuestion.currentSection = "do";
                targetQuestion.qid = qid;
              } else {
                indexOfCurrent++;
              }
            });
          }

          if(targetQuestion === undefined) {
            indexOfCurrent = 0;
            totalIndexOfCurrent = 0;
            $.each(sectionObj["check"], function(qid) {
              if(this.val === undefined && targetQuestion === undefined) {
                totalIndexOfCurrent = indexOfCurrent;
                targetQuestion = this;
                targetQuestion.currentSection = "check";
                targetQuestion.qid = qid;
              } else {
                indexOfCurrent++;
              }
            });
          }

          if(targetQuestion === undefined) {
            console.log("let's re-direct to report page.");
            var userInfo = JSON.parse(localStorage.getItem("userInfo"));
            userInfo.finished = true;
            userInfo.fullData = currentValues;
            localStorage.setItem("userInfo", JSON.stringify(userInfo));
            document.location.href = "report";
          } else {
            $(".question_text").ready(function() {
              //targetQuestion.currentSection = "plan";
              $(".answer_wrap").attr('data-section', targetQuestion.currentSection);
              $(".section_1").addClass('section_' + targetQuestion.currentSection);
              $(".answer_wrap").attr('data-qid', targetQuestion.qid);
              //$("#assessment").removeClass().addClass("section_" + targetQuestion.currentSection);
              $(".section-imgage").attr("src", "support/img/section_" + targetQuestion.currentSection + ".png");
              //$(".question_image").css("background-image", "url('support/img/resourceFiles/" + targetQuestion.img + "')");
              $(".question_image").attr("src", "support/img/resourceFiles/" + targetQuestion.img);
              $(".question_text")[0].innerHTML = targetQuestion.qry;
              $(".question_count")[0].innerHTML = totalIndexOfCurrent + 1;

              var pBarWidth = Number(Number(totalIndexOfCurrent) / Number(Object.keys(allSections[targetQuestion.currentSection]).length) * 100).toFixed(2);
              //$("#progressBarInner").css("width", (totalIndexOfCurrent === 0 ? "0px" : pBarWidth + "%"));
              if((totalIndexOfCurrent === 0)) {
                $("#progressBarInner").css("width", 0).html('');
              } else {
                $("#progressBarInner").css("width", pBarWidth + "%");
              }
            });
          }
        };
        fillForm(currentValues);
      </script>

      <form name="surveyForm" method="post" action="" id="surveyForm">
        <div class="container">
          <div id="outer" class="row">
            <div id="header" class="inner col-xs-12 col-sm-12 col-md-12 col-lg-12">
              <div id="logo" class="pull-right"></div>
            </div>
            <div id="content_wrap" class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
              <div class="inner col-xs-12 col-sm-12 col-md-12 col-lg-12">
                <div id="assessment" class="section_1">
                  <!--<div id="sections"></div>-->
                  <img class="section-imgage cover-width" src="support/img/section_plan.png" alt="Sections"/>
                  <%--<img class="section-img-do cover-width" src="support/img/section_do.png" alt="Sections"/>--%>
                  <%--<img class="section-img-check cover-width" src="support/img/section_check.png" alt="Sections"/>--%>
                  <div class="content col-xs-12 col-sm-12 col-md-12 col-lg-12">
                    <div class="question clearfix" data-section-id="1" data-question-id="1" style="">
                      <div class="left col-xs-12 col-sm-12 col-md-6 col-lg-5">
                        <div class="question_count_wrap">
                          <div class="question_count_heading">Question</div>
                          <div class="question_count">1</div>
                        </div>
                        <%--<div class="question_image"></div><!-- TODO: replace images-->--%>
                        <img class="question_image" src="support/img/resourceFiles/plan-2.png"/>
                      </div>
                      <div class="col-xs-12 col-sm-12 col-md-6 col-lg-7">
                        <div class="right">
                          <div class="stripe col-xs-12 col-sm-12 col-md-12 col-lg-12">
                            <h3 class="question_text"></h3>
                          </div>
                          <div class="answer_wrap col-xs-12 col-sm-12 col-md-12 col-lg-12" data-section="" data-qid="">
						  <%
				                Hashtable<String, String> lhs = (Hashtable<String, String>) request.getAttribute("labels");  
				                Hashtable<String, String> ahs = (Hashtable<String, String>) request.getAttribute("answertypes");  
								String yes=	ahs.get("yes");
								String no=	ahs.get("no");
								String notsure=	ahs.get("notsure");
								String progress = lhs.get("progress");
						  %>
                            <a href="javascript:;" class="btn btn-success" data-value="yes"><%=yes%></a>
                            <a href="javascript:;" class="btn btn-danger" data-value="no"><%=no%></a>
                            <a href="javascript:;" class="btn btn-warning" data-value="notsure"><%=notsure%></a>
                          </div>
                          <div class="clearfix"></div>
                          <div class="spacer"></div>
                        </div>
                        <div id="progressBarWrap">
                          <h4><%=progress%>:</h4>
                          <div id="progressBarOuter" class="stripe_progress progress">
                            <%--<div id="progressBarInner" class="progress-bar" width="0%">​</div>--%>
                            <div id="progressBarInner" class="progress-bar" role="progressbar" aria-valuenow="60" aria-valuemin="0" aria-valuemax="100" width="0%" style="width: 14.29%;">
                              <span class="sr-only">14.29% Complete</span>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div id="footer" class="inner img-responsive">
              <img class="image-max-width" src="<%=webContext%>support/img/strapline.png" alt="Worldwide reach. Human touch.">
            </div>
          </div>
        </div>
      </form>
    </body>
  </html>