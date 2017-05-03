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
      <title>Survey Page</title>
      <link href="<%=webContext%>support/css/site.css" rel="stylesheet">
      <%--<link href="<%=webContext%>support/lib/bootstrap.css" rel="stylesheet">--%>
      <script type="text/javascript" async="" src="<%=webContext%>support/js/ga.js"></script>
      <script src="<%=webContext%>/support/lib/jquery-3.2.0.js"></script>
      <%--<script src="<%=webContext%>/support/lib/bootstrap.js"></script>--%>
      <script type="text/javascript" async="" src="<%=webContext%>support/js/assessment.js"></script>
    </head>

    <body>

      <script>
        var planSection = {}, doSection = {}, checkSection = {}, allSections = {};

        <%
          int totalQuestions = 0;
          HashMap<String,String> planSection =new HashMap<String,String>();
          planSection.put("p1", "Can you locate all your current travellers?|plan-1.png");
          planSection.put("p2", "Do you assess the risks to your employees in those locations?|plan-2.png");
          planSection.put("p3", "Do you monitor the type and quantity of incidents your employees have been involved in over the last 2-3 years?|plan-3.png");
          planSection.put("p4", "Does your company understand its Duty of Care obligations?|plan-4.png");
          planSection.put("p5", "Do your policies cover the health, safety and security of employees abroad?|plan-5.png");
          planSection.put("p6", "Do you know who is responsible for Travel Risk Management in your organisation?|plan-6.png");
          planSection.put("p7", "Do you know how to integrate the components of Travel Risk Management into your risk management system?|plan-7.png");

          for(Map.Entry m:planSection.entrySet()) {
            System.out.println("Question #" + ++totalQuestions + ": QuestionId : " + m.getKey()+":Question : "+m.getValue());
        %>
        planSection["<%= m.getKey() %>"] =  {
          "qry" : "<%= m.getValue() %>".split('|')[0],
          "img" : "<%= m.getValue() %>".split('|')[1]
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
              $(".answer_wrap").attr('data-qid', targetQuestion.qid);
              $("#assessment").removeClass().addClass("section_" + targetQuestion.currentSection);
              $(".question_image").css("background-image", "url('support/img/resourceFiles/" + targetQuestion.img + "')");
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
        <div id="outer">
          <div id="header" class="inner">
            <div id="logo"></div>
          </div>
          <div id="content_wrap">
            <div class="inner">
              <div id="assessment" class="section_1">
                <div id="sections"></div>
                <div class="content">
                  <div class="question clearfix" data-section-id="1" data-question-id="1" style="">
                    <div class="left">
                      <div class="question_count_wrap">
                        <div class="question_count_heading">Question</div>
                        <div class="question_count">1</div>
                      </div>
                      <div class="question_image"></div>
                    </div>
                    <div class="right">
                      <div class="stripe">
                        <h3 class="question_text"></h3>
                      </div>
                      <div class="answer_wrap" data-section="" data-qid="">
                        <a href="javascript:;" class="btn btn-green" data-value="yes">Yes</a>
                        <a href="javascript:;" class="btn btn-red" data-value="no">No</a>
                        <a href="javascript:;" class="btn btn-orange" data-value="notsure">Not Sure</a>
                      </div>
                    </div>
                  </div>
                  <div id="progressBarWrap">
                    <h4>Progress:</h4>
                    <div id="progressBarOuter" class="stripe_progress">
                      <div id="progressBarInner" width="0%">​</div>
                    </div>
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