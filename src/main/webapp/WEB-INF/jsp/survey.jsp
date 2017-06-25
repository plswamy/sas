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
          list = hs.get("do");
          q = null;
          System.out.println(list.size());
          for(int i=0; i < list.size(); i++) {
        	  q = list.get(i);
        %>
          doSection["<%= q.getId() %>"] =  {
          "qry" : "<%= q.getText() %>",
          "img" : "<%= q.getImageName() %>"
        };
        <%
          }
        %>
        
          allSections["do"] = doSection;


        
          <%
          list = hs.get("check");
          q = null;
          System.out.println(list.size());
          for(int i=0; i < list.size(); i++) {
        	  q = list.get(i);
        %>
          checkSection["<%= q.getId() %>"] =  {
          "qry" : "<%= q.getText() %>",
          "img" : "<%= q.getImageName() %>"
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
            //document.location.href = "report";
            $("#surveyForm").submit();
          } else {
            $(".question_text").ready(function() {
                $('#email').val(userSession.email);
                $('#firstname').val(userSession.firstname);
                $('#lastname').val(userSession.lastname);
                $('#jobtitle').val(userSession.jobtitle);
                $('#company').val(userSession.company);
                $('#businessindustry').val(userSession.businessindustry);
                $('#country').val(userSession.country);
                $('#state').val(userSession.state);

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

        function beforeSubmit() {
            console.log('before submit');
            var finalObj = "";
            var planObj = JSON.parse(localStorage.getItem("userInfo")).surveyProgress.plan;
            for(var propt in planObj){
                finalObj += propt + ":" + planObj[propt].val + "|";
            }
            var doObj = JSON.parse(localStorage.getItem("userInfo")).surveyProgress.do;
            for(var propt in doObj){
                finalObj += propt + ":" + doObj[propt].val + "|";
            }
            var checkObj = JSON.parse(localStorage.getItem("userInfo")).surveyProgress.check;
            for(var propt in checkObj){
                finalObj += propt + ":" + checkObj[propt].val + "|";
            }
            console.log("finalObj : " + finalObj);
            $('#userResponse').val(finalObj);
            return true;
        }
      </script>

      <form name="surveyForm" method="post" action="report" id="surveyForm" onsubmit="javascript:return beforeSubmit();">
        <input type="hidden" id="email" name="email"/>
        <input type="hidden" id="firstname" name="firstname"/>
        <input type="hidden" id="lastname" name="lastname"/>
        <input type="hidden" id="jobtitle" name="jobtitle"/>
        <input type="hidden" id="company" name="company"/>
        <input type="hidden" id="businessindustry" name="businessindustry"/>
        <input type="hidden" id="country" name="country"/>
        <input type="hidden" id="state" name="state"/>
        <input type="hidden" id="userResponse" name="userResponse"/>
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
								String yes=	lhs.get("yes");
								String no=	lhs.get("no");
								String notsure=	lhs.get("notsure");
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